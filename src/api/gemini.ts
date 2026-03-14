import Constants from 'expo-constants';
import { BLOCKS } from '../data/blocks';
import { busRoutes } from '../data/busRoutes';

const GEMINI_API_KEY =
  (Constants.expoConfig?.extra as any)?.GEMINI_API_KEY ||
  (Constants.manifest?.extra as any)?.GEMINI_API_KEY ||
  process.env.GEMINI_API_KEY ||
  '';

const GEMINI_MODEL =
  (Constants.expoConfig?.extra as any)?.GEMINI_MODEL ||
  (Constants.manifest?.extra as any)?.GEMINI_MODEL ||
  process.env.GEMINI_MODEL ||
  'gemini-1.5-flash-latest';

const GEMINI_URL =
  `https://generativelanguage.googleapis.com/v1/models/${GEMINI_MODEL}:generateMessage`;

export async function askGemini(userQuestion: string): Promise<string> {
  if (!GEMINI_API_KEY || GEMINI_API_KEY === 'YOUR_GEMINI_API_KEY_HERE') {
    return 'Gemini API key is not configured. Set GEMINI_API_KEY in environment or expo extra (app.json / eas).';
  }

  const systemPrompt = `
You are a helpful assistant for the SRM KTR Smart Campus mobile app.

You can answer:
- Bus questions using this JSON (routes, stops, times):
${JSON.stringify(busRoutes).slice(0, 8000)}
- Campus map / distance questions using this JSON:
${JSON.stringify(BLOCKS).slice(0, 8000)}

Rules:
- If the user asks about buses, use ONLY the busRoutes data above.
- If the user asks about buildings, locations or distance, use ONLY the BLOCKS data above.
- Be concise (2–4 sentences), no markdown or bullet points.
- If something is not in the data, say you do not have that information instead of guessing.
  `.trim();

  const res = await fetch(`${GEMINI_URL}?key=${GEMINI_API_KEY}`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({
      messages: [
        {
          author: 'system',
          content: [{ type: 'text', text: systemPrompt }],
        },
        {
          author: 'user',
          content: [{ type: 'text', text: userQuestion }],
        },
      ],
      temperature: 0.2,
      maxOutputTokens: 500,
    }),
  });

  if (!res.ok) {
    const errText = await res.text().catch(() => '');
    console.warn('Gemini error:', errText);
    throw new Error(`Gemini request failed (${res.status})`);
  }

  const data = await res.json();
  const text =
    data?.candidates?.[0]?.content?.[0]?.text ||
    data?.output?.[0]?.content?.[0]?.text ||
    'Sorry, I could not understand that.';
  return text as string;
}

