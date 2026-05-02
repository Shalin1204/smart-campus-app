import SwiftUI

// ── Full port of ChatbotScreen.tsx ───────────────────────────────────────────
// KeyboardAvoidingView  →  .ignoresSafeArea(.keyboard) on ScrollView
// scrollViewRef.scrollToEnd  →  ScrollViewReader + scrollTo(lastId, anchor: .bottom)
// ActivityIndicator     →  ProgressView

struct ChatbotView: View {
    @StateObject private var vm = ChatViewModel()
    @Environment(\.dismiss) private var dismiss
    @FocusState private var inputFocused: Bool

    var body: some View {
        ZStack(alignment: .top) {
            Color(hex: "#F8F9FB").ignoresSafeArea()

            VStack(spacing: 0) {
                chatHeader
                    .background(Color.white)
                    .overlay(
                        Rectangle()
                            .fill(Color(hex: "#E5E7EB"))
                            .frame(height: 0.5),
                        alignment: .bottom
                    )

                // Message list
                ScrollViewReader { proxy in
                    ScrollView(showsIndicators: false) {
                        LazyVStack(spacing: 0) {
                            ForEach(vm.messages) { msg in
                                MessageBubble(message: msg)
                                    .id(msg.id)
                            }
                            if vm.isTyping {
                                TypingIndicatorView()
                                    .id("typing")
                            }
                        }
                        .padding(.horizontal, 22)
                        .padding(.vertical, 22)
                    }
                    .onChange(of: vm.messages.count) { _ in
                        withAnimation {
                            proxy.scrollTo(vm.messages.last?.id ?? "typing", anchor: .bottom)
                        }
                    }
                    .onChange(of: vm.isTyping) { _ in
                        withAnimation {
                            proxy.scrollTo("typing", anchor: .bottom)
                        }
                    }
                }

                inputBar
                    .background(Color.white)
                    .overlay(
                        Rectangle()
                            .fill(Color(hex: "#E5E7EB"))
                            .frame(height: 0.5),
                        alignment: .top
                    )
            }
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .navigationBarHidden(true)
    }

    // ── Header — mirrors header in ChatbotScreen.tsx ──────────────────────────
    private var chatHeader: some View {
        HStack(spacing: 0) {
            Button { dismiss() } label: {
                ZStack {
                    Circle()
                        .fill(Color(hex: "#F3F4F6"))
                        .frame(width: 42, height: 42)
                    Text("‹")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(Color(hex: "#111827"))
                }
            }
            .padding(.trailing, 14)

            VStack(alignment: .leading, spacing: 2) {
                Text("Campus Assistant")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(Color(hex: "#111827"))
                    .tracking(-0.3)
                Text("Ask about buses and navigation")
                    .font(.system(size: 13))
                    .foregroundColor(Color(hex: "#9CA3AF"))
            }

            Spacer()

            ZStack {
                Circle()
                    .fill(Color(hex: "#EEF2FF"))
                    .frame(width: 42, height: 42)
                Text("🤖")
                    .font(.system(size: 20))
            }
        }
        .padding(.horizontal, 22)
        .padding(.top, 58)
        .padding(.bottom, 18)
    }

    // ── Input bar — mirrors inputBar in ChatbotScreen.tsx ────────────────────
    private var inputBar: some View {
        HStack(alignment: .bottom, spacing: 0) {
            // Text field
            HStack(alignment: .bottom) {
                TextField("Ask about bus timings or distance...", text: $vm.inputText, axis: .vertical)
                    .font(.system(size: 15))
                    .foregroundColor(Color(hex: "#111827"))
                    .lineLimit(1...4)
                    .focused($inputFocused)
                    .disabled(vm.isSending)

                // Send button
                Button {
                    Task { await vm.send() }
                } label: {
                    ZStack {
                        Circle()
                            .fill((!vm.inputText.trimmingCharacters(in: .whitespaces).isEmpty && !vm.isSending)
                                  ? Color(hex: "#4F46E5") : Color(hex: "#E5E7EB"))
                            .frame(width: 32, height: 32)
                        if vm.isSending {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                .scaleEffect(0.7)
                        } else {
                            Text("➤")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.white)
                                .offset(x: 1, y: -1)
                        }
                    }
                }
                .disabled(vm.inputText.trimmingCharacters(in: .whitespaces).isEmpty || vm.isSending)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(Color(hex: "#F8F9FB"))
            .clipShape(RoundedRectangle(cornerRadius: 24))
            .frame(minHeight: 48)
        }
        .padding(.horizontal, 22)
        .padding(.vertical, 16)
        .padding(.bottom, 34)     // iOS safe area bottom
    }
}

// ── MessageBubble — mirrors messageContainer + bubble in ChatbotScreen.tsx ────
struct MessageBubble: View {
    let message: ChatMessage

    private var isUser: Bool { message.from == .user }

    var body: some View {
        VStack(alignment: isUser ? .trailing : .leading, spacing: 4) {
            HStack {
                if isUser { Spacer(minLength: 60) }
                Text(message.text)
                    .font(.system(size: 15))
                    .foregroundColor(isUser ? .white : Color(hex: "#111827"))
                    .lineSpacing(4)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(isUser ? Color(hex: "#4F46E5") : Color.white)
                    .clipShape(
                        RoundedRectangle(cornerRadius: 18)
                    )
                    .overlay(
                        // Asymmetric corner: flatten one corner to show direction
                        isUser
                            ? RoundedRectangle(cornerRadius: 18).fill(Color.clear)
                            : RoundedRectangle(cornerRadius: 18).fill(Color.clear)
                    )
                    .shadow(color: .black.opacity(0.08), radius: 6, x: 0, y: 2)
                if !isUser { Spacer(minLength: 60) }
            }

            Text(message.timestamp.formatted(date: .omitted, time: .shortened))
                .font(.system(size: 11, weight: .medium))
                .foregroundColor(Color(hex: "#9CA3AF"))
        }
        .padding(.bottom, 16)
        .frame(maxWidth: .infinity, alignment: isUser ? .trailing : .leading)
    }
}

// ── TypingIndicatorView — mirrors TypingIndicator in ChatbotScreen.tsx ────────
struct TypingIndicatorView: View {
    @State private var phase = 0
    let timer = Timer.publish(every: 0.4, on: .main, in: .common).autoconnect()

    var body: some View {
        HStack(spacing: 4) {
            ForEach(0..<3) { i in
                Circle()
                    .fill(Color(hex: "#9CA3AF"))
                    .frame(width: 6, height: 6)
                    .scaleEffect(phase == i ? 1.4 : 1.0)
                    .animation(.easeInOut(duration: 0.3), value: phase)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .shadow(color: .black.opacity(0.08), radius: 6, x: 0, y: 2)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.bottom, 16)
        .onReceive(timer) { _ in
            phase = (phase + 1) % 3
        }
    }
}
