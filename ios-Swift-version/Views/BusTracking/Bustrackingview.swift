import SwiftUI

// ── Full port of BusTrackingScreen.tsx ──────────────────────────────────────
// React state   →  @StateObject BusTrackingViewModel
// Modal sheets  →  .sheet(isPresented:)
// results list  →  ForEach over vm.displayedRoutes

struct BusTrackingView: View {
    @StateObject private var vm = BusTrackingViewModel()

    var body: some View {
        Group {
            if let selected = vm.selectedRoute {
                // ── Route detail — mirrors RouteDetail component
                RouteDetailView(route: selected) {
                    vm.selectedRoute = nil
                }
                .navigationBarHidden(true)
            } else {
                mainSearchView
            }
        }
        .navigationBarHidden(true)
        // From-stop picker sheet
        .sheet(isPresented: $vm.showFromPicker) {
            StopPickerSheet(title: "Select From Stop") { stop in
                vm.fromStop      = stop
                vm.searchResults = nil
            }
        }
        // To-stop picker sheet
        .sheet(isPresented: $vm.showToPicker) {
            StopPickerSheet(title: "Select To Stop") { stop in
                vm.toStop = stop
            }
        }
    }

    // ── Main scroll content ─────────────────────────────────────────────────
    private var mainSearchView: some View {
        ZStack(alignment: .top) {
            Color(hex: "#F3F4F6").ignoresSafeArea()

            VStack(spacing: 0) {
                topNavBar
                    .background(Color(hex: "#F3F4F6"))

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        fromToCard
                            .padding(.horizontal, 16)
                            .padding(.top, 16)
                            .padding(.bottom, 12)

                        routeSearchBar
                            .padding(.horizontal, 16)
                            .padding(.bottom, 10)

                        // Route search results
                        if !vm.routeQuery.isEmpty {
                            ForEach(vm.routeQueryResults) { route in
                                RouteCardView(route: route) { vm.selectedRoute = route }
                                    .padding(.horizontal, 16)
                                    .padding(.bottom, 10)
                            }
                        }

                        // From/To results label
                        if !vm.displayLabel.isEmpty {
                            Text(vm.displayLabel)
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(Color(hex: "#6B7A8D"))
                                .tracking(1)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal, 16)
                                .padding(.bottom, 8)
                                .padding(.top, 4)
                        }

                        ForEach(vm.displayedRoutes) { route in
                            RouteCardView(route: route) { vm.selectedRoute = route }
                                .padding(.horizontal, 16)
                                .padding(.bottom, 10)
                        }

                        Spacer(minLength: 40)
                    }
                }
            }
        }
    }

    // ── Top nav bar — mirrors topNav in BusTrackingScreen.tsx ───────────────
    private var topNavBar: some View {
        HStack {
            // "‹ Home" back button handled by NavigationStack automatically,
            // but we replicate the styled version here using the environment
            BackButton()
            Spacer()
            Text("Bus Tracker")
                .font(.system(size: 17, weight: .bold))
                .foregroundColor(Color(hex: "#111827"))
            Spacer()
            Color.clear.frame(width: 60)
        }
        .padding(.horizontal, 16)
        .padding(.top, 52)
        .padding(.bottom, 12)
    }

    // ── FROM / TO search card — mirrors searchCard in BusTrackingScreen.tsx ─
    private var fromToCard: some View {
        VStack(spacing: 0) {
            // FROM row
            Button { vm.showFromPicker = true } label: {
                HStack(spacing: 0) {
                    Circle()
                        .strokeBorder(Color(hex: "#6B7A8D"), lineWidth: 2)
                        .frame(width: 14, height: 14)
                        .padding(.trailing, 14)

                    Text(vm.fromStop.isEmpty ? "From Stop" : vm.fromStop)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(vm.fromStop.isEmpty ? Color(hex: "#9CA3AF") : Color(hex: "#111827"))
                        .frame(maxWidth: .infinity, alignment: .leading)

                    if !vm.fromStop.isEmpty {
                        Button { vm.clearFrom() } label: {
                            Text("✕").foregroundColor(Color(hex: "#9CA3AF")).font(.system(size: 18))
                        }
                        .padding(.horizontal, 8)
                    }
                }
                .padding(.vertical, 10)
            }

            // Dotted connector + swap button
            HStack {
                Rectangle()
                    .fill(Color(hex: "#D1D5DB"))
                    .frame(width: 1.5, height: 20)
                    .padding(.leading, 6)

                Spacer()

                Button { vm.swapStops() } label: {
                    ZStack {
                        Circle()
                            .strokeBorder(Color(hex: "#D1D5DB"), lineWidth: 1.5)
                            .frame(width: 40, height: 40)
                            .background(Color.white)
                            .clipShape(Circle())
                        Text("⇅")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(Color(hex: "#16A34A"))
                    }
                }
            }

            // TO row
            Button { vm.showToPicker = true } label: {
                HStack(spacing: 0) {
                    Circle()
                        .strokeBorder(Color(hex: "#6B7A8D"), lineWidth: 2)
                        .frame(width: 14, height: 14)
                        .padding(.trailing, 14)

                    Text(vm.toStop.isEmpty ? "To Stop" : vm.toStop)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(vm.toStop.isEmpty ? Color(hex: "#9CA3AF") : Color(hex: "#111827"))
                        .frame(maxWidth: .infinity, alignment: .leading)

                    if !vm.toStop.isEmpty {
                        Button { vm.toStop = "" } label: {
                            Text("✕").foregroundColor(Color(hex: "#9CA3AF")).font(.system(size: 18))
                        }
                        .padding(.horizontal, 8)
                    }
                }
                .padding(.vertical, 10)
            }

            // Find Buses button
            Button { vm.findBuses() } label: {
                Text("Find Buses")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(Color(hex: "#16A34A"))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            .padding(.top, 12)
        }
        .padding(16)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.07), radius: 8, x: 0, y: 2)
    }

    // ── Route number / name search bar — mirrors altCard ───────────────────
    private var routeSearchBar: some View {
        HStack(spacing: 0) {
            Text("🚌").font(.system(size: 22)).padding(.trailing, 10)

            TextField("Route No. / Route Name", text: $vm.routeQuery)
                .font(.system(size: 15))
                .foregroundColor(Color(hex: "#111827"))

            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(hex: "#16A34A"))
                    .frame(width: 40, height: 40)
                Text("🔍").font(.system(size: 18))
            }
        }
        .padding(14)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.05), radius: 6, x: 0, y: 2)
    }
}

// ── Back button helper ────────────────────────────────────────────────────────
private struct BackButton: View {
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        Button { dismiss() } label: {
            Text("‹ Home")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(Color(hex: "#16A34A"))
                .frame(width: 60, alignment: .leading)
        }
    }
}

// ── RouteCardView — mirrors RouteCard component in BusTrackingScreen.tsx ─────
struct RouteCardView: View {
    let route:   BusRoute
    let onPress: () -> Void

    var body: some View {
        let info      = getBusInfo(route: route)
        let statusHex = info.status == .scheduled ? "#6B7A8D" : "#16A34A"

        Button(action: onPress) {
            VStack(spacing: 0) {
                // Top row: badge + name + status pill
                HStack(alignment: .center, spacing: 0) {
                    // Route number badge
                    Text(route.routeNo)
                        .font(.system(size: 13, weight: .heavy))
                        .foregroundColor(Color(hex: "#16A34A"))
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(Color(hex: "#DCFCE7"))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .padding(.trailing, 10)

                    // Name + meta
                    VStack(alignment: .leading, spacing: 1) {
                        Text(route.routeName)
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(Color(hex: "#111827"))
                        Text("\(route.stops.count) stops · arrives \(fmt(route.campusArrival))")
                            .font(.system(size: 12))
                            .foregroundColor(Color(hex: "#6B7A8D"))
                    }

                    Spacer()

                    // Status pill
                    HStack(spacing: 4) {
                        Circle()
                            .fill(Color(hex: statusHex))
                            .frame(width: 6, height: 6)
                        Text(info.status.rawValue)
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundColor(Color(hex: statusHex))
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(Color(hex: statusHex).opacity(0.13))
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .strokeBorder(Color(hex: statusHex).opacity(0.33), lineWidth: 1)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .padding(.leading, 8)
                }
                .padding(.bottom, 10)

                // Progress bar
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        Rectangle()
                            .fill(Color(hex: "#F3F4F6"))
                        Rectangle()
                            .fill(Color(hex: "#16A34A"))
                            .frame(width: geo.size.width * CGFloat(info.progress))
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 3))
                }
                .frame(height: 5)
                .padding(.bottom, 8)

                // Bottom row: current stop + ETA
                HStack {
                    Text("📍 \(info.currentStop)")
                        .font(.system(size: 12))
                        .foregroundColor(Color(hex: "#6B7A8D"))
                    Spacer()
                    if info.etaMinutes > 0 {
                        Text("\(info.etaMinutes) min to campus")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(Color(hex: "#16A34A"))
                    }
                }
            }
            .padding(14)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .shadow(color: .black.opacity(0.05), radius: 6, x: 0, y: 2)
        }
        .buttonStyle(.plain)
    }
}

// ── StopPickerSheet — mirrors StopPicker modal in BusTrackingScreen.tsx ──────
struct StopPickerSheet: View {
    let title:    String
    let onSelect: (String) -> Void

    @Environment(\.dismiss) private var dismiss
    @State private var query = ""

    var filtered: [String] {
        query.isEmpty ? ALL_STOPS : ALL_STOPS.filter { $0.localizedCaseInsensitiveContains(query) }
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Search field
                HStack {
                    Image(systemName: "magnifyingglass").foregroundColor(Color(hex: "#9CA3AF"))
                    TextField("Search stop...", text: $query)
                        .font(.system(size: 15))
                        .foregroundColor(Color(hex: "#111827"))
                }
                .padding(12)
                .background(Color(hex: "#F3F4F6"))
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding(.horizontal, 16)
                .padding(.vertical, 8)

                List(filtered, id: \.self) { stop in
                    Button {
                        onSelect(stop)
                        dismiss()
                    } label: {
                        HStack {
                            Text("○").foregroundColor(Color(hex: "#9CA3AF"))
                            Text(stop)
                                .font(.system(size: 15))
                                .foregroundColor(Color(hex: "#111827"))
                        }
                    }
                    .listRowSeparatorTint(Color(hex: "#F3F4F6"))
                }
                .listStyle(.plain)
            }
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("✕") { dismiss() }
                        .foregroundColor(Color(hex: "#6B7A8D"))
                }
            }
        }
    }
}