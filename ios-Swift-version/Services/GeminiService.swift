import Foundation

// ── Full port of src/api/gemini.ts ───────────────────────────────────────────
// fetch()  →  URLSession.shared.data(for:)
// System prompt injected identically, including BLOCKS + busRoutes data.
//
// SETUP: Set your Gemini API key in Info.plist as GEMINI_API_KEY
// or pass it in from your secret store. Never hardcode in source.

enum GeminiError: Error {
    case missingAPIKey
    case httpError(Int)
    case noContent
}

struct GeminiService {

    // ── API key — mirrors process.env.EXPO_PUBLIC_GEMINI_API_KEY lookup ───────
    // Read from Info.plist so the key never lives in source code.
    static var apiKey: String? {
        Bundle.main.object(forInfoDictionaryKey: "GEMINI_API_KEY") as? String
    }

    static let model   = "gemini-1.5-flash"
    static var apiURL: URL {
        URL(string: "https://generativelanguage.googleapis.com/v1beta/models/\(model):generateContent")!
    }

    // ── askGemini(_ question) — exact port of askGemini() from gemini.ts ─────
    static func ask(_ userQuestion: String) async throws -> String {
        guard let key = apiKey, !key.isEmpty else {
            throw GeminiError.missingAPIKey
        }

        let prompt = buildPrompt(userQuestion)

        // Build request body — same shape as the TS fetch body
        let body: [String: Any] = [
            "contents": [
                ["parts": [["text": prompt]]]
            ],
            "generationConfig": [
                "temperature":     0.2,
                "maxOutputTokens": 1000
            ]
        ]

        var req = URLRequest(url: apiURL.appending(queryItems: [URLQueryItem(name: "key", value: key)]))
        req.httpMethod = "POST"
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.httpBody = try JSONSerialization.data(withJSONObject: body)

        let (data, resp) = try await URLSession.shared.data(for: req)

        if let http = resp as? HTTPURLResponse, !(200...299).contains(http.statusCode) {
            throw GeminiError.httpError(http.statusCode)
        }

        guard
            let json      = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
            let candidates = json["candidates"] as? [[String: Any]],
            let content   = candidates.first?["content"] as? [String: Any],
            let parts     = content["parts"] as? [[String: Any]],
            let text      = parts.first?["text"] as? String
        else {
            throw GeminiError.noContent
        }

        // Strip **bold** markdown — mirrors cleanedText in gemini.ts
        return text.replacingOccurrences(of: #"\*\*(.*?)\*\*"#, with: "$1", options: .regularExpression)
    }

    // ── System prompt — mirrors systemPrompt const in gemini.ts ─────────────
    // Uses the exact same campus data embedded inline.
    private static func buildPrompt(_ question: String) -> String {
        let blocksText = CampusBlock.all.map { b in
            "\(b.name) (\(b.short)) - \(b.category.rawValue): \(b.description) [\(b.lat), \(b.lng)]"
        }.joined(separator: "\n")

        let routesText = BusRoute.all.map { r in
            let stops = r.stops.map { "\($0.stop) (\($0.time))" }.joined(separator: " → ")
            return "Route \(r.routeNo) (\(r.routeName)) - Campus arrival: \(r.campusArrival)\nStops: \(stops)"
        }.joined(separator: "\n\n")

        return """
You are a comprehensive assistant for the SRM KTR Smart Campus mobile app with access to all campus information.

CAMPUS BUILDINGS & FACILITIES:
\(blocksText)

BUS ROUTES & SCHEDULES:
\(routesText)

CAPABILITIES:
- Provide detailed bus route information, schedules, and stop timings
- Give directions and walking distances between any campus locations
- Help with navigation around campus buildings and facilities
- Answer questions about academic blocks, labs, food courts, sports facilities
- Provide information about campus gates, entrances, and transportation

DISTANCE GUIDELINES:
- Use coordinates to calculate approximate walking distances
- General rule: 100 metres ≈ 2 minutes walking time
- Main Gate to Tech Park: ~800m (16 minutes)
- University Building to Class Room Complex: ~400m (8 minutes)
- Tech Park Tower I to II: ~100m (2 minutes)

RESPONSE GUIDELINES:
- Be comprehensive and detailed
- For distance questions: Include walking time, directions, nearby landmarks
- For navigation: Provide step-by-step directions and alternative routes
- For bus questions: Include all stops, times, and helpful tips
- Use building short codes (TP-I, CRC, UB, etc.) for clarity
- If information is unavailable, suggest alternatives

User: \(question)
"""
    }
}
