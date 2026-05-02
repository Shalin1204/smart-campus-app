import SwiftUI
import CoreLocation

// Direct port of Category type and Block type from blocks.ts

enum BlockCategory: String, CaseIterable, Codable {
    case academic = "academic"
    case lab      = "lab"
    case facility = "facility"
    case food     = "food"
    case hostel   = "hostel"
    case sports   = "sports"
    case gate     = "gate"

    var color: Color {
        switch self {
        case .academic: return Color(hex: "#6366F1")
        case .lab:      return Color(hex: "#0EA5E9")
        case .facility: return Color(hex: "#10B981")
        case .food:     return Color(hex: "#FF6B35")
        case .hostel:   return Color(hex: "#EC4899")
        case .sports:   return Color(hex: "#8B5CF6")
        case .gate:     return Color(hex: "#374151")
        }
    }

    var icon: String {
        switch self {
        case .academic: return "🏫"
        case .lab:      return "🔬"
        case .facility: return "🏢"
        case .food:     return "🍽️"
        case .hostel:   return "🏠"
        case .sports:   return "⚽"
        case .gate:     return "🚪"
        }
    }

    var filterLabel: String {
        switch self {
        case .academic: return "🏫 Academic"
        case .lab:      return "🔬 Labs"
        case .facility: return "🏢 Facility"
        case .food:     return "🍽️ Food"
        case .hostel:   return "🏠 Hostels"
        case .sports:   return "⚽ Sports"
        case .gate:     return "🚪 Gates"
        }
    }
}

struct CampusBlock: Identifiable {
    let id: String
    let name: String
    let short: String
    let category: BlockCategory
    let lat: Double
    let lng: Double
    let description: String

    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: lat, longitude: lng)
    }
}
