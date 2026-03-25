import { useRouter } from "expo-router";
import React, { useRef, useState } from "react";
import {
  ActivityIndicator,
  KeyboardAvoidingView,
  Platform,
  ScrollView,
  StatusBar,
  StyleSheet,
  Text,
  TextInput,
  TouchableOpacity,
  View,
} from "react-native";
import { askGemini } from "../src/api/gemini";

type Message = {
  id: string;
  from: "user" | "bot";
  text: string;
  timestamp: Date;
};

export default function ChatbotScreen() {
  const router = useRouter();
  const scrollViewRef = useRef<ScrollView>(null);
  const [messages, setMessages] = useState<Message[]>([
    {
      id: "welcome",
      from: "bot",
      text:
        "Hi, I'm your Smart Campus assistant.\n\n" +
        "You can ask about:\n" +
        "• Bus timings and routes\n" +
        "• Distance between campus locations\n" +
        "• Parking information\n" +
        "• Building directions",
      timestamp: new Date(),
    },
  ]);
  const [input, setInput] = useState("");
  const [sending, setSending] = useState(false);
  const [typing, setTyping] = useState(false);

  const handleSend = async () => {
    const q = input.trim();
    if (!q || sending) return;

    const userMsg: Message = {
      id: `${Date.now()}-u`,
      from: "user",
      text: q,
      timestamp: new Date(),
    };
    setMessages((prev) => [...prev, userMsg]);
    setInput("");
    setSending(true);
    setTyping(true);

    // Scroll to bottom after sending
    setTimeout(
      () => scrollViewRef.current?.scrollToEnd({ animated: true }),
      100,
    );

    try {
      const reply = await askGemini(q);
      const botMsg: Message = {
        id: `${Date.now()}-b`,
        from: "bot",
        text: reply,
        timestamp: new Date(),
      };
      setMessages((prev) => [...prev, botMsg]);
    } catch (e) {
      const botMsg: Message = {
        id: `${Date.now()}-e`,
        from: "bot",
        text: "Something went wrong talking to Gemini. Please try again in a moment.",
        timestamp: new Date(),
      };
      setMessages((prev) => [...prev, botMsg]);
    } finally {
      setSending(false);
      setTyping(false);
      // Scroll to bottom after response
      setTimeout(
        () => scrollViewRef.current?.scrollToEnd({ animated: true }),
        100,
      );
    }
  };

  const TypingIndicator = () => (
    <View style={styles.typingContainer}>
      <View style={[styles.bubble, styles.bubbleBot]}>
        <View style={styles.typingDots}>
          <View style={[styles.typingDot, { animationDelay: "0s" }]} />
          <View style={[styles.typingDot, { animationDelay: "0.2s" }]} />
          <View style={[styles.typingDot, { animationDelay: "0.4s" }]} />
        </View>
      </View>
    </View>
  );

  return (
    <KeyboardAvoidingView
      style={styles.container}
      behavior={Platform.OS === "ios" ? "padding" : "height"}
      keyboardVerticalOffset={Platform.OS === "ios" ? 0 : 0}
    >
      <StatusBar barStyle="dark-content" backgroundColor="#F8F9FB" />

      <View style={styles.header}>
        <TouchableOpacity onPress={() => router.back()} style={styles.backBtn}>
          <Text style={styles.backTxt}>‹</Text>
        </TouchableOpacity>
        <View style={styles.headerContent}>
          <Text style={styles.title}>Campus Assistant</Text>
          <Text style={styles.sub}>Ask about buses and navigation</Text>
        </View>
        <View style={styles.headerIcon}>
          <Text style={styles.botIcon}>🤖</Text>
        </View>
      </View>

      <ScrollView
        ref={scrollViewRef}
        style={styles.messages}
        contentContainerStyle={styles.messagesContent}
        showsVerticalScrollIndicator={false}
        keyboardShouldPersistTaps="handled"
        keyboardDismissMode="interactive"
      >
        {messages.map((m) => (
          <View
            key={m.id}
            style={[
              styles.messageContainer,
              m.from === "user" ? styles.messageUser : styles.messageBot,
            ]}
          >
            <View
              style={[
                styles.bubble,
                m.from === "user" ? styles.bubbleUser : styles.bubbleBot,
              ]}
            >
              <Text
                style={m.from === "user" ? styles.textUser : styles.textBot}
              >
                {m.text}
              </Text>
            </View>
            <Text style={styles.timestamp}>
              {m.timestamp.toLocaleTimeString([], {
                hour: "2-digit",
                minute: "2-digit",
              })}
            </Text>
          </View>
        ))}
        {typing && <TypingIndicator />}
      </ScrollView>

      <View style={styles.inputBar}>
        <View style={styles.inputContainer}>
          <TextInput
            style={styles.input}
            placeholder="Ask about bus timings or distance..."
            placeholderTextColor="#9CA3AF"
            value={input}
            onChangeText={setInput}
            editable={!sending}
            multiline
            maxLength={500}
            blurOnSubmit={false}
          />
          <TouchableOpacity
            style={[
              styles.sendBtn,
              (!input.trim() || sending) && styles.sendBtnDisabled,
            ]}
            onPress={handleSend}
            disabled={!input.trim() || sending}
          >
            {sending ? (
              <ActivityIndicator size="small" color="#FFFFFF" />
            ) : (
              <Text style={styles.sendTxt}>➤</Text>
            )}
          </TouchableOpacity>
        </View>
      </View>
    </KeyboardAvoidingView>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: "#F8F9FB" },

  header: {
    paddingTop: 58,
    paddingHorizontal: 22,
    paddingBottom: 18,
    flexDirection: "row",
    alignItems: "center",
    backgroundColor: "#FFFFFF",
    borderBottomWidth: StyleSheet.hairlineWidth,
    borderBottomColor: "#E5E7EB",
  },
  backBtn: {
    width: 42,
    height: 42,
    borderRadius: 21,
    backgroundColor: "#F3F4F6",
    alignItems: "center",
    justifyContent: "center",
    marginRight: 14,
  },
  backTxt: { fontSize: 20, fontWeight: "600", color: "#111827" },
  headerContent: { flex: 1 },
  title: {
    fontSize: 20,
    fontWeight: "700",
    color: "#111827",
    letterSpacing: -0.3,
  },
  sub: { fontSize: 13, color: "#9CA3AF", marginTop: 2 },
  headerIcon: {
    width: 42,
    height: 42,
    borderRadius: 21,
    backgroundColor: "#EEF2FF",
    alignItems: "center",
    justifyContent: "center",
  },
  botIcon: { fontSize: 20 },

  messages: { flex: 1 },
  messagesContent: { padding: 22, paddingBottom: 20 },

  messageContainer: {
    marginBottom: 16,
    maxWidth: "85%",
  },
  messageUser: { alignSelf: "flex-end", alignItems: "flex-end" },
  messageBot: { alignSelf: "flex-start", alignItems: "flex-start" },

  bubble: {
    borderRadius: 18,
    paddingHorizontal: 16,
    paddingVertical: 12,
    shadowColor: "#000",
    shadowOpacity: 0.08,
    shadowOffset: { width: 0, height: 2 },
    shadowRadius: 6,
    elevation: 3,
  },
  bubbleUser: {
    backgroundColor: "#4F46E5",
    borderBottomRightRadius: 6,
  },
  bubbleBot: {
    backgroundColor: "#FFFFFF",
    borderBottomLeftRadius: 6,
  },

  textUser: {
    color: "#FFFFFF",
    fontSize: 15,
    lineHeight: 20,
    fontWeight: "400",
  },
  textBot: {
    color: "#111827",
    fontSize: 15,
    lineHeight: 20,
    fontWeight: "400",
  },

  timestamp: {
    fontSize: 11,
    color: "#9CA3AF",
    marginTop: 4,
    fontWeight: "500",
  },

  typingContainer: {
    alignSelf: "flex-start",
    marginBottom: 16,
    maxWidth: "85%",
  },
  typingDots: {
    flexDirection: "row",
    alignItems: "center",
    paddingHorizontal: 4,
  },
  typingDot: {
    width: 6,
    height: 6,
    borderRadius: 3,
    backgroundColor: "#9CA3AF",
    marginHorizontal: 2,
  },

  inputBar: {
    backgroundColor: "#FFFFFF",
    borderTopWidth: StyleSheet.hairlineWidth,
    borderTopColor: "#E5E7EB",
    paddingHorizontal: 22,
    paddingVertical: 16,
    paddingBottom: Platform.OS === "ios" ? 34 : 16,
  },
  inputContainer: {
    flexDirection: "row",
    alignItems: "flex-end",
    backgroundColor: "#F8F9FB",
    borderRadius: 24,
    paddingHorizontal: 16,
    paddingVertical: 8,
    minHeight: 48,
  },
  input: {
    flex: 1,
    fontSize: 15,
    color: "#111827",
    maxHeight: 100,
    paddingTop: 8,
    paddingBottom: 8,
  },
  sendBtn: {
    width: 32,
    height: 32,
    borderRadius: 16,
    backgroundColor: "#4F46E5",
    alignItems: "center",
    justifyContent: "center",
    marginLeft: 8,
  },
  sendBtnDisabled: {
    backgroundColor: "#E5E7EB",
  },
  sendTxt: {
    color: "#FFFFFF",
    fontSize: 16,
    fontWeight: "600",
    marginTop: -1,
  },
});
