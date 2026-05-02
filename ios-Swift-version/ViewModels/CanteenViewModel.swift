import Foundation

// ── useCart() hook → CartViewModel ──────────────────────────────────────────
// Mirrors add(), remove(), qty(), total, count, clear() in CanteenScreen.tsx

@MainActor
final class CartViewModel: ObservableObject {
    @Published private(set) var items: [CartItem] = []

    // Derived — mirrors total and count in useCart()
    var total: Int { items.reduce(0) { $0 + $1.subtotal } }
    var count: Int { items.reduce(0) { $0 + $1.qty } }

    func qty(for id: String) -> Int {
        items.first { $0.id == id }?.qty ?? 0
    }

    func add(_ item: MenuItem) {
        if let idx = items.firstIndex(where: { $0.id == item.id }) {
            items[idx].qty += 1
        } else {
            items.append(CartItem(id: item.id, item: item, qty: 1))
        }
    }

    func remove(id: String) {
        guard let idx = items.firstIndex(where: { $0.id == id }) else { return }
        if items[idx].qty == 1 {
            items.remove(at: idx)
        } else {
            items[idx].qty -= 1
        }
    }

    func clear() { items = [] }
}

// ── CanteenViewModel — screen-level state ────────────────────────────────────
// Mirrors: restaurant, category, vegOnly, search state + filtered/grouped logic

@MainActor
final class CanteenViewModel: ObservableObject {
    @Published var selectedRestaurant: String  = "All"
    @Published var selectedCategory:   String  = "All"
    @Published var vegOnly:            Bool    = false
    @Published var search:             String  = ""

    let cart = CartViewModel()

    // All restaurant tab keys — mirrors RESTAURANTS in CanteenScreen.tsx
    let restaurants = ["All", "HR05 Food Plaza", "Queens Court"]

    // All unique categories derived from menu data
    var allCategories: [String] {
        ["All"] + Array(Set(MenuItem.all.map(\.category))).sorted()
    }

    // Mirrors filtered in CanteenScreen.tsx
    var filteredItems: [MenuItem] {
        MenuItem.all.filter { item in
            let restMatch = selectedRestaurant == "All" || item.restaurant == selectedRestaurant
            let catMatch  = selectedCategory  == "All" || item.category   == selectedCategory
            let vegMatch  = !vegOnly || item.isVeg
            let q         = search.lowercased()
            let srchMatch = q.isEmpty || item.name.lowercased().contains(q)
            return restMatch && catMatch && vegMatch && srchMatch
        }
    }

    // Mirrors grouped = filtered.reduce({}) in CanteenScreen.tsx
    var groupedItems: [(category: String, items: [MenuItem])] {
        var dict: [String: [MenuItem]] = [:]
        for item in filteredItems {
            dict[item.category, default: []].append(item)
        }
        // Preserve a stable order (alphabetical by category name)
        return dict.keys.sorted().map { cat in (category: cat, items: dict[cat]!) }
    }

    var headerTitle: String {
        selectedRestaurant == "All" ? "Food Court" : selectedRestaurant
    }
}
