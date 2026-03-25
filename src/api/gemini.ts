import Constants from "expo-constants";
import { BLOCKS } from "../data/blocks";
import { busRoutes } from "../data/busRoutes";
import { buildings } from "../parking/buildings";
import { parkingAreas } from "../parking/parkingLocations";

// API Key Configuration:
// 1. For local development: Add GEMINI_API_KEY to .env file
// 2. For production: Set environment variable in your deployment platform
// 3. Get your key from: https://makersuite.google.com/app/apikey
const GEMINI_API_KEY =
  (Constants.expoConfig?.extra as any)?.GEMINI_API_KEY ||
  (Constants.manifest?.extra as any)?.GEMINI_API_KEY ||
  process.env.GEMINI_API_KEY;

const GEMINI_MODEL =
  (Constants.expoConfig?.extra as any)?.GEMINI_MODEL ||
  (Constants.manifest?.extra as any)?.GEMINI_MODEL ||
  process.env.GEMINI_MODEL ||
  "gemini-1.5-flash";

const GEMINI_URL = `https://generativelanguage.googleapis.com/v1beta/models/${GEMINI_MODEL}:generateContent`;

export async function askGemini(userQuestion: string): Promise<string> {
  if (!GEMINI_API_KEY) {
    return "Gemini API key is not configured.\n\nTo set it up:\n1. Get your API key from: https://makersuite.google.com/app/apikey\n2. Add GEMINI_API_KEY=your_key_here to your .env file\n3. Restart the app\n\nFor production builds, set the environment variable in your deployment platform.";
  }

  const systemPrompt = `
You are a comprehensive assistant for the SRM KTR Smart Campus mobile app with access to all campus information.

CAMPUS BUILDINGS & FACILITIES:
${BLOCKS.map((b) => `${b.name} (${b.short}) - ${b.category}: ${b.description} [${b.lat}, ${b.lng}]`).join("\n")}

PARKING AREAS:
${parkingAreas.map((p) => `${p.name} [${p.lat}, ${p.lng}]`).join("\n")}

KEY BUILDINGS (for navigation):
${buildings.map((b) => `${b.name} [${b.lat}, ${b.lng}]`).join("\n")}

BUS ROUTES & SCHEDULES:
${busRoutes
  .map(
    (r) =>
      `Route ${r.route_no} (${r.route_name}) - Campus arrival: ${r.campusArrival}\nStops: ${r.stops.map((s) => `${s.stop} (${s.time})`).join(" → ")}`,
  )
  .join("\n\n")}

CAPABILITIES:
- Provide detailed bus route information, schedules, and stop timings
- Give directions and walking distances between any campus locations
- Recommend best parking areas for different destinations
- Help with navigation around campus buildings and facilities
- Answer questions about academic blocks, labs, food courts, sports facilities
- Provide information about campus gates, entrances, and transportation

DISTANCE GUIDELINES:
- Use coordinates to calculate approximate walking distances
- General rule: 100 meters ≈ 2 minutes walking time
- Main Gate to Tech Park: ~800m (16 minutes)
- University Building to Class Room Complex: ~400m (8 minutes)
- Tech Park Tower I to II: ~100m (2 minutes)

RESPONSE GUIDELINES:
- Be comprehensive and detailed - don't just give one piece of information
- For distance questions: Include walking time, directions, nearby landmarks, and parking suggestions
- For navigation: Provide step-by-step directions, mention buildings you'll pass, and alternative routes
- For bus questions: Include all stops, times, and helpful tips about the route
- Always provide context and additional useful information the user might need
- Use building short codes (TP-I, CRC, UB, etc.) for clarity
- Suggest parking areas based on destination proximity
- Include practical tips like "allow extra time for walking" or "check bus schedule"
- If information is unavailable, suggest alternatives or ask for clarification

EXAMPLES OF COMPREHENSIVE ANSWERS:
- Distance question: "Tech Park Tower I to University Building is approximately 400m (8 minutes walk). Walk north from TP-I toward the central walkway, pass the Java Canteen on your right, and UB will be on your left. Best parking is Tech Park Parking (2 minute walk) or Library Parking (5 minute walk)."
- Navigation question: "To get from Main Gate to CRC: Enter through Main Gate, walk straight for 300m (6 minutes) along the main road, turn left at the University Building, and CRC will be 100m ahead on your right. Total distance: 400m (8 minutes)."
  `.trim();

  const res = await fetch(`${GEMINI_URL}?key=${GEMINI_API_KEY}`, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({
      contents: [
        {
          parts: [
            {
              text: systemPrompt + "\n\nUser: " + userQuestion,
            },
          ],
        },
      ],
      generationConfig: {
        temperature: 0.2,
        maxOutputTokens: 1000,
      },
    }),
  });

  if (!res.ok) {
    const errText = await res.text().catch(() => "");
    console.warn("Gemini error:", errText);
    throw new Error(`Gemini request failed (${res.status})`);
  }

  const data = await res.json();
  const text =
    data?.candidates?.[0]?.content?.parts?.[0]?.text ||
    "Sorry, I could not understand that.";

  // Clean up markdown formatting for better readability in the app
  const cleanedText = text.replace(/\*\*(.*?)\*\*/g, "$1"); // Remove **bold** formatting

  return cleanedText as string;
}
