import SwiftUI

// Mirrors the Module type and MODULES array in DashboardScreen.tsx
struct CampusModule: Identifiable {
    let id: String
    let label: String
    let subtitle: String
    let icon: String          // SF Symbol name
    let emoji: String         // for quick fallback / badge
    let accent: Color
    let background: Color
    let destination: AppRoute
}

enum AppRoute: Hashable {
    case busTracking
    case canteen
    case campusMap
    case parking
    case helpline
    case chatbot
}

extension CampusModule {
    // 1:1 mapping from MODULES array in DashboardScreen.tsx
    static let all: [CampusModule] = [
        CampusModule(
            id: "bus",
            label: "Bus Tracking",
            subtitle: "Routes & Schedules",
            icon: "bus.fill",
            emoji: "🚌",
            accent: Color(hex: "#FF6B35"),
            background: Color(hex: "#FFF4EF"),
            destination: .busTracking
        ),
        CampusModule(
            id: "canteen",
            label: "Food Court",
            subtitle: "Order Food",
            icon: "fork.knife",
            emoji: "🍱",
            accent: Color(hex: "#0EA5E9"),
            background: Color(hex: "#EFF8FF"),
            destination: .canteen
        ),
        CampusModule(
            id: "map",
            label: "Campus Map",
            subtitle: "Navigate Campus",
            icon: "map.fill",
            emoji: "🗺️",
            accent: Color(hex: "#8B5CF6"),
            background: Color(hex: "#F5F3FF"),
            destination: .campusMap
        ),
        CampusModule(
            id: "parking",
            label: "Parking ID",
            subtitle: "Digital Pass",
            icon: "parkingsign.circle.fill",
            emoji: "🅿️",
            accent: Color(hex: "#F59E0B"),
            background: Color(hex: "#FFFBEB"),
            destination: .parking
        ),
        CampusModule(
            id: "helpline",
            label: "Helpline",
            subtitle: "Important Contacts",
            icon: "phone.fill",
            emoji: "📞",
            accent: Color(hex: "#10B981"),
            background: Color(hex: "#ECFDF5"),
            destination: .helpline
        ),
        CampusModule(
            id: "chat",
            label: "Campus Assistant",
            subtitle: "Ask anything",
            icon: "brain.head.profile",
            emoji: "🤖",
            accent: Color(hex: "#4F46E5"),
            background: Color(hex: "#EEF2FF"),
            destination: .chatbot
        ),
    ]
}