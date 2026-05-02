import Foundation

// Direct port of MenuItem type from CanteenScreen.tsx
struct MenuItem: Identifiable {
    let id: String
    let name: String
    let price: Int
    let isVeg: Bool        // veg in TS
    let category: String
    let restaurant: String
}

// Direct port of CartItem type (MenuItem + qty)
struct CartItem: Identifiable {
    let id: String
    let item: MenuItem
    var qty: Int

    var subtotal: Int { item.price * qty }
}

// mirrors makeId() helper from CanteenScreen.tsx
func makeMenuId(_ restaurant: String, _ name: String) -> String {
    let combined = "\(restaurant)_\(name)"
    return combined
        .lowercased()
        .replacingOccurrences(of: " ", with: "_")
}
