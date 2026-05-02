import Foundation

// ── Port of ChatbotScreen.tsx state + handleSend() ───────────────────────────

struct ChatMessage: Identifiable {
    let id:        String
    let from:      Sender
    let text:      String
    let timestamp: Date

    enum Sender { case user, bot }
}

@MainActor
final class ChatViewModel: ObservableObject {
    @Published var messages:  [ChatMessage] = [
        ChatMessage(
            id:        "welcome",
            from:      .bot,
            text:      "Hi, I'm your Smart Campus assistant.\n\nYou can ask about:\n• Bus timings and routes\n• Distance between campus locations\n• Parking information\n• Building directions",
            timestamp: Date()
        )
    ]
    @Published var inputText: String  = ""
    @Published var isSending: Bool    = false
    @Published var isTyping:  Bool    = false

    // ── handleSend() — port of handleSend in ChatbotScreen.tsx ───────────────
    func send() async {
        let q = inputText.trimmingCharacters(in: .whitespaces)
        guard !q.isEmpty, !isSending else { return }

        let userMsg = ChatMessage(id: "\(Date().timeIntervalSince1970)-u", from: .user, text: q, timestamp: Date())
        messages.append(userMsg)
        inputText = ""
        isSending = true
        isTyping  = true

        do {
            let reply = try await GeminiService.ask(q)
            messages.append(ChatMessage(id: "\(Date().timeIntervalSince1970)-b", from: .bot, text: reply, timestamp: Date()))
        } catch GeminiError.missingAPIKey {
            messages.append(ChatMessage(
                id: "\(Date().timeIntervalSince1970)-e",
                from: .bot,
                text: "Gemini API key is not configured.\n\nAdd GEMINI_API_KEY to your app's Info.plist.\nGet your key at: https://makersuite.google.com/app/apikey",
                timestamp: Date()
            ))
        } catch {
            messages.append(ChatMessage(
                id: "\(Date().timeIntervalSince1970)-e",
                from: .bot,
                text: "Something went wrong talking to Gemini. Please try again in a moment.",
                timestamp: Date()
            ))
        }

        isSending = false
        isTyping  = false
    }
}
