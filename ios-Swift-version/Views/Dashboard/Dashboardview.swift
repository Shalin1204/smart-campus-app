import SwiftUI

// ── Full conversion of DashboardScreen.tsx ───────────────────────────────────
// ModuleCard  →  ModuleCardView
// DashboardScreen  →  DashboardView
// router.push(href)  →  NavigationLink with AppRoute value

struct DashboardView: View {
    @State private var headerOpacity: Double = 0

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 0) {

                // ── Header (mirrors the Animated.View header in DashboardScreen.tsx)
                VStack(alignment: .leading, spacing: 4) {
                    Text("Smart Campus")
                        .font(.system(size: 26, weight: .heavy, design: .rounded))
                        .foregroundColor(Color(hex: "#111827"))
                        .tracking(-0.5)

                    Text("SRM KTR")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(Color(hex: "#9CA3AF"))
                }
                .padding(.horizontal, 22)
                .padding(.top, 58)
                .padding(.bottom, 18)
                .opacity(headerOpacity)

                // ── Module list
                LazyVStack(spacing: 12) {
                    ForEach(Array(CampusModule.all.enumerated()), id: \.element.id) { idx, module in
                        NavigationLink(value: module.destination) {
                            ModuleCardView(module: module, index: idx)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 40)
            }
        }
        .background(Color(hex: "#F8F9FB").ignoresSafeArea())
        .navigationDestination(for: AppRoute.self) { route in
            destinationView(for: route)
        }
        .onAppear {
            withAnimation(.easeIn(duration: 0.5)) { headerOpacity = 1 }
        }
    }

    // Maps AppRoute → concrete SwiftUI view (equivalent of router.push in RN)
    @ViewBuilder
    private func destinationView(for route: AppRoute) -> some View {
        switch route {
        case .busTracking: BusTrackingView()
        case .canteen:     PlaceholderView(title: "Food Court",      icon: "🍱")
        case .campusMap:   PlaceholderView(title: "Campus Map",      icon: "🗺️")
        case .parking:     PlaceholderView(title: "Parking ID",      icon: "🅿️")
        case .helpline:    PlaceholderView(title: "Helpline",        icon: "📞")
        case .chatbot:     PlaceholderView(title: "Campus Assistant",icon: "🤖")
        }
    }
}

// ── ModuleCardView — mirrors ModuleCard component in DashboardScreen.tsx ─────
struct ModuleCardView: View {
    let module: CampusModule
    let index:  Int

    @State private var appeared = false
    @State private var pressed  = false

    var body: some View {
        HStack(spacing: 0) {

            // Icon box
            ZStack {
                RoundedRectangle(cornerRadius: 14)
                    .fill(module.background)
                    .frame(width: 52, height: 52)
                Text(module.emoji)
                    .font(.system(size: 26))
            }
            .padding(.trailing, 14)

            // Labels
            VStack(alignment: .leading, spacing: 2) {
                Text(module.label)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(Color(hex: "#111827"))
                Text(module.subtitle)
                    .font(.system(size: 13))
                    .foregroundColor(Color(hex: "#9CA3AF"))
            }

            Spacer()

            // Arrow pill
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(module.accent.opacity(0.094))
                    .frame(width: 32, height: 32)
                Text("›")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(module.accent)
                    .offset(y: -1)
            }
        }
        .padding(16)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
        .scaleEffect(pressed ? 0.96 : 1)
        .opacity(appeared ? 1 : 0)
        .offset(y: appeared ? 0 : 12)
        .onAppear {
            withAnimation(.easeOut(duration: 0.35).delay(Double(index) * 0.06)) {
                appeared = true
            }
        }
        ._onButtonGesture(pressing: { isPressing in
            withAnimation(.spring(response: 0.25, dampingFraction: 0.7)) {
                pressed = isPressing
            }
        }, perform: {})
    }
}

// ── Placeholder for screens not yet implemented ───────────────────────────────
struct PlaceholderView: View {
    let title: String
    let icon:  String

    var body: some View {
        ZStack {
            Color(hex: "#F8F9FB").ignoresSafeArea()
            VStack(spacing: 16) {
                Text(icon).font(.system(size: 64))
                Text(title)
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(Color(hex: "#111827"))
                Text("Coming soon")
                    .font(.system(size: 14))
                    .foregroundColor(Color(hex: "#9CA3AF"))
            }
        }
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
    }
}