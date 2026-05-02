import SwiftUI

// ── Full port of CanteenScreen.tsx ───────────────────────────────────────────

struct CanteenView: View {
    @StateObject private var vm = CanteenViewModel()
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack(alignment: .bottom) {
            Color(hex: "#F8F9FB").ignoresSafeArea()

            VStack(spacing: 0) {
                header
                searchBar
                restaurantTabs
                menuScrollView
            }

            // Cart bar — shows when items in cart (equivalent of a future CartScreen push)
            if vm.cart.count > 0 {
                cartBar
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .animation(.spring(response: 0.3), value: vm.cart.count)
        .navigationBarHidden(true)
    }

    // ── Header — mirrors header in CanteenScreen.tsx ─────────────────────────
    private var header: some View {
        HStack(spacing: 0) {
            Button { dismiss() } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(hex: "#EFEFEF"))
                        .frame(width: 36, height: 36)
                    Text("‹")
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundColor(Color(hex: "#111827"))
                }
            }
            .padding(.trailing, 12)

            VStack(alignment: .leading, spacing: 2) {
                Text(vm.headerTitle)
                    .font(.system(size: 24, weight: .heavy))
                    .foregroundColor(Color(hex: "#111827"))
                Text("SRM KTR · \(MenuItem.all.count) items")
                    .font(.system(size: 12))
                    .foregroundColor(Color(hex: "#9CA3AF"))
            }

            Spacer()
            Text("🛒").font(.system(size: 26))
        }
        .padding(.top, 54)
        .padding(.horizontal, 16)
        .padding(.bottom, 10)
    }

    // ── Search bar — mirrors <TextInput style={search}> ───────────────────────
    private var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass").foregroundColor(Color(hex: "#9CA3AF"))
            TextField("Search dishes...", text: $vm.search)
                .font(.system(size: 15))
                .foregroundColor(Color(hex: "#111827"))
        }
        .padding(12)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(RoundedRectangle(cornerRadius: 12).strokeBorder(Color(hex: "#E5E7EB"), lineWidth: 1))
        .padding(.horizontal, 16)
        .padding(.bottom, 10)
    }

    // ── Restaurant tabs + Veg toggle — mirrors tabsScroll ────────────────────
    private var restaurantTabs: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(vm.restaurants, id: \.self) { rest in
                    Button {
                        vm.selectedRestaurant = rest
                    } label: {
                        Text(rest == "HR05 Food Plaza" ? "HR05" : rest)
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(vm.selectedRestaurant == rest ? .white : Color(hex: "#374151"))
                            .padding(.horizontal, 18)
                            .padding(.vertical, 8)
                            .background(vm.selectedRestaurant == rest ? Color(hex: "#111827") : Color.white)
                            .clipShape(Capsule())
                            .overlay(Capsule().strokeBorder(
                                vm.selectedRestaurant == rest ? Color.clear : Color(hex: "#E5E7EB"), lineWidth: 1))
                    }
                }

                // Veg-only toggle — mirrors vegToggle in TS
                Button { vm.vegOnly.toggle() } label: {
                    HStack(spacing: 4) {
                        Circle()
                            .fill(vm.vegOnly ? Color(hex: "#16A34A") : Color(hex: "#9CA3AF"))
                            .frame(width: 8, height: 8)
                        Text("Veg Only")
                            .font(.system(size: 13))
                            .foregroundColor(Color(hex: "#374151"))
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 7)
                    .background(vm.vegOnly ? Color(hex: "#F0FDF4") : Color.white)
                    .clipShape(Capsule())
                    .overlay(Capsule().strokeBorder(
                        vm.vegOnly ? Color(hex: "#16A34A") : Color(hex: "#E5E7EB"), lineWidth: 1))
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 5)
        }
        .frame(height: 55)
        .padding(.bottom, 10)
    }

    // ── Menu grouped scroll — mirrors Object.entries(grouped).map ─────────────
    private var menuScrollView: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(alignment: .leading, spacing: 0, pinnedViews: [.sectionHeaders]) {
                ForEach(vm.groupedItems, id: \.category) { group in
                    Section(header: categoryHeader(group.category, count: group.items.count)) {
                        ForEach(group.items) { item in
                            MenuItemCard(
                                item:     item,
                                qty:      vm.cart.qty(for: item.id),
                                onAdd:    { vm.cart.add(item) },
                                onRemove: { vm.cart.remove(id: item.id) }
                            )
                        }
                    }
                }
                Spacer(minLength: 100)
            }
            .padding(.horizontal, 16)
        }
    }

    private func categoryHeader(_ cat: String, count: Int) -> some View {
        HStack {
            Text(cat)
                .font(.system(size: 15, weight: .bold))
                .foregroundColor(Color(hex: "#111827"))
            Spacer()
            Text("\(count) items")
                .font(.system(size: 12))
                .foregroundColor(Color(hex: "#9CA3AF"))
        }
        .padding(.vertical, 10)
        .background(Color(hex: "#F8F9FB"))
    }

    // ── Cart bar at bottom ────────────────────────────────────────────────────
    private var cartBar: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text("\(vm.cart.count) item\(vm.cart.count > 1 ? "s" : "")")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(.white.opacity(0.8))
                Text("₹\(vm.cart.total)")
                    .font(.system(size: 18, weight: .heavy))
                    .foregroundColor(.white)
            }
            Spacer()
            Text("View Cart →")
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(.white)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 14)
        .background(Color(hex: "#FF6B35"))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .padding(.horizontal, 16)
        .padding(.bottom, 20)
        .shadow(color: Color(hex: "#FF6B35").opacity(0.4), radius: 12, x: 0, y: 4)
    }
}

// ── MenuItemCard — mirrors MenuCard component in CanteenScreen.tsx ────────────
struct MenuItemCard: View {
    let item:     MenuItem
    let qty:      Int
    let onAdd:    () -> Void
    let onRemove: () -> Void

    var body: some View {
        HStack(spacing: 0) {
            VegBadgeView(isVeg: item.isVeg)

            VStack(alignment: .leading, spacing: 2) {
                Text(item.name)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(Color(hex: "#111827"))
                Text("₹\(item.price)")
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(Color(hex: "#FF6B35"))
            }
            .padding(.leading, 10)

            Spacer()

            // ADD button or qty stepper
            if qty == 0 {
                Button(action: onAdd) {
                    Text("ADD")
                        .font(.system(size: 13, weight: .heavy))
                        .foregroundColor(Color(hex: "#FF6B35"))
                        .padding(.horizontal, 16)
                        .padding(.vertical, 7)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .strokeBorder(Color(hex: "#FF6B35"), lineWidth: 1.5)
                        )
                }
            } else {
                HStack(spacing: 0) {
                    Button(action: onRemove) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color(hex: "#FF6B35"))
                                .frame(width: 28, height: 28)
                            Text("−")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.white)
                        }
                    }
                    Text("\(qty)")
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(Color(hex: "#111827"))
                        .frame(width: 32)
                    Button(action: onAdd) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color(hex: "#FF6B35"))
                                .frame(width: 28, height: 28)
                            Text("+")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.white)
                        }
                    }
                }
            }
        }
        .padding(12)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .padding(.bottom, 6)
    }
}

// ── VegBadgeView — mirrors VegBadge component in CanteenScreen.tsx ───────────
struct VegBadgeView: View {
    let isVeg: Bool

    var color: Color { isVeg ? Color(hex: "#16A34A") : Color(hex: "#DC2626") }

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 3)
                .strokeBorder(color, lineWidth: 1.5)
                .frame(width: 16, height: 16)
            Circle()
                .fill(color)
                .frame(width: 7, height: 7)
        }
    }
}
