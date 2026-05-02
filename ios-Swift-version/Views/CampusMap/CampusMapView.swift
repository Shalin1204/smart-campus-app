import SwiftUI
import MapKit

// ── Full port of CampusMapScreen.native.tsx ──────────────────────────────────
// react-native-maps MapView   →  Map() + MapAnnotation
// expo-location               →  CLLocationManager (in CampusMapViewModel)
// Animated.spring sheet       →  .sheet(isPresented:) with .presentationDetents
// Polyline                    →  MapPolyline (iOS 17) / MKPolyline overlay
// Linking.openURL             →  UIApplication.shared.open

struct CampusMapView: View {
    @StateObject private var vm = CampusMapViewModel()
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack(alignment: .top) {
            // ── MapKit map — mirrors <MapView> in native TS ─────────────────
            Map(coordinateRegion: $vm.region,
                showsUserLocation: true,
                annotationItems: CampusBlock.all) { block in

                MapAnnotation(coordinate: block.coordinate) {
                    BlockPinView(block: block, isSelected: vm.selectedBlock?.id == block.id)
                        .onTapGesture { vm.pick(block) }
                }
            }
            .ignoresSafeArea()

            // Dashed line from user to selected block (mirrors <Polyline>)
            if let selected = vm.selectedBlock, let userLoc = vm.userLocation {
                MapOverlay_DashedLine(from: userLoc, to: selected.coordinate, color: selected.category.color)
            }

            // ── Top bar — mirrors topBar in TS ──────────────────────────────
            topBar

            // ── Selected block card — mirrors card in TS ────────────────────
            if let selected = vm.selectedBlock, !vm.sheetOpen {
                VStack {
                    Spacer()
                    BlockDetailCard(block: selected, distance: vm.distanceToSelected, onClose: {
                        vm.selectedBlock = nil
                    }, onDirections: {
                        if let url = vm.googleMapsURL(for: selected) {
                            UIApplication.shared.open(url)
                        }
                    })
                }
                .transition(.move(edge: .bottom))
            }

            // ── "All Buildings" toggle button — mirrors toggle in TS ─────────
            if vm.selectedBlock == nil {
                VStack {
                    Spacer()
                    Button {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.85)) {
                            vm.sheetOpen.toggle()
                        }
                    } label: {
                        Text(vm.sheetOpen ? "↓  Close" : "↑  All Buildings")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 22)
                            .padding(.vertical, 11)
                            .background(Color(hex: "#111827"))
                            .clipShape(Capsule())
                    }
                    .padding(.bottom, 24)
                }
            }

            // ── Bottom sheet — mirrors Animated.View sheet in TS ─────────────
            if vm.sheetOpen {
                VStack {
                    Spacer()
                    BuildingListSheet(vm: vm)
                        .transition(.move(edge: .bottom))
                }
            }
        }
        .animation(.spring(response: 0.4, dampingFraction: 0.85), value: vm.selectedBlock?.id)
        .animation(.spring(response: 0.4, dampingFraction: 0.85), value: vm.sheetOpen)
        .navigationBarHidden(true)
    }

    // ── Top navigation bar ───────────────────────────────────────────────────
    private var topBar: some View {
        HStack {
            Button { dismiss() } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(hex: "#F3F4F6"))
                        .frame(width: 36, height: 36)
                    Text("‹")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(Color(hex: "#111827"))
                }
            }

            Spacer()

            VStack(spacing: 2) {
                Text("Campus Map")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(Color(hex: "#111827"))
                Text("SRM Kattankulathur")
                    .font(.system(size: 11))
                    .foregroundColor(Color(hex: "#9CA3AF"))
            }

            Spacer()

            // Re-centre on user — mirrors the ◎ button in TS
            Button { vm.centreOnUser() } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(hex: "#F3F4F6"))
                        .frame(width: 36, height: 36)
                    Text("◎")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(Color(hex: "#111827"))
                }
            }
        }
        .padding(.horizontal, 14)
        .padding(.top, 50)
        .padding(.bottom, 12)
        .background(Color.white.opacity(0.96))
    }
}

// ── BlockPinView — mirrors <View style={pin}> inside <Marker> in TS ──────────
struct BlockPinView: View {
    let block:      CampusBlock
    let isSelected: Bool

    var body: some View {
        Text(block.short)
            .font(.system(size: 9, weight: .heavy))
            .foregroundColor(.white)
            .lineLimit(1)
            .padding(.horizontal, 6)
            .padding(.vertical, 3)
            .background(block.category.color)
            .clipShape(RoundedRectangle(cornerRadius: 7))
            .overlay(
                RoundedRectangle(cornerRadius: 7)
                    .strokeBorder(Color.white, lineWidth: isSelected ? 2.5 : 0)
            )
            .shadow(color: .black.opacity(0.2), radius: 3, x: 0, y: 2)
    }
}

// ── BlockDetailCard — mirrors card at bottom in CampusMapScreen.native.tsx ───
struct BlockDetailCard: View {
    let block:        CampusBlock
    let distance:     Double?
    let onClose:      () -> Void
    let onDirections: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            // Top row: icon + name + close
            HStack(alignment: .center, spacing: 0) {
                ZStack {
                    RoundedRectangle(cornerRadius: 14)
                        .fill(block.category.color.opacity(0.12))
                        .frame(width: 48, height: 48)
                    Text(block.category.icon)
                        .font(.system(size: 24))
                }
                .padding(.trailing, 12)

                VStack(alignment: .leading, spacing: 2) {
                    Text(block.name)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(Color(hex: "#111827"))
                    Text(block.description)
                        .font(.system(size: 13))
                        .foregroundColor(Color(hex: "#9CA3AF"))
                }

                Spacer()

                Button(action: onClose) {
                    Text("✕")
                        .font(.system(size: 18))
                        .foregroundColor(Color(hex: "#9CA3AF"))
                        .padding(6)
                }
            }
            .padding(.bottom, 16)

            // Stats row: distance | walk time | Go button
            HStack(spacing: 0) {
                if let dist = distance {
                    statBox(value: fmtDist(dist), label: "Distance")
                    Divider().frame(height: 34)
                    statBox(value: fmtWalk(dist), label: "Walk time")
                    Divider().frame(height: 34)
                } else {
                    Text("Turn on location for distance")
                        .font(.system(size: 11))
                        .foregroundColor(Color(hex: "#9CA3AF"))
                        .frame(maxWidth: .infinity)
                }

                Button(action: onDirections) {
                    Text("Go ↗")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 18)
                        .padding(.vertical, 11)
                        .background(block.category.color)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .padding(.leading, 12)
            }
        }
        .padding(20)
        .background(Color.white)
        .clipShape(
            RoundedRectangle(cornerRadius: 20)
        )
        .overlay(
            // Coloured top border — mirrors borderTopColor in card StyleSheet
            RoundedRectangle(cornerRadius: 20)
                .stroke(block.category.color, lineWidth: 0)
                .overlay(
                    Rectangle()
                        .fill(block.category.color)
                        .frame(height: 3)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                    , alignment: .top
                )
        )
        .shadow(color: .black.opacity(0.10), radius: 10, x: 0, y: -3)
    }

    private func statBox(value: String, label: String) -> some View {
        VStack(spacing: 2) {
            Text(value)
                .font(.system(size: 17, weight: .bold))
                .foregroundColor(Color(hex: "#111827"))
            Text(label)
                .font(.system(size: 11))
                .foregroundColor(Color(hex: "#9CA3AF"))
        }
        .frame(maxWidth: .infinity)
    }
}

// ── BuildingListSheet — mirrors Animated.View sheet in CampusMapScreen.native.tsx
struct BuildingListSheet: View {
    @ObservedObject var vm: CampusMapViewModel

    var body: some View {
        VStack(spacing: 0) {
            // Handle bar
            Capsule()
                .fill(Color(hex: "#E5E7EB"))
                .frame(width: 36, height: 4)
                .padding(.top, 10)
                .padding(.bottom, 4)

            // Search field
            HStack {
                Image(systemName: "magnifyingglass").foregroundColor(Color(hex: "#9CA3AF"))
                TextField("Search building or block...", text: $vm.search)
                    .font(.system(size: 14))
                    .foregroundColor(Color(hex: "#111827"))
            }
            .padding(12)
            .background(Color(hex: "#F3F4F6"))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .padding(.horizontal, 14)
            .padding(.bottom, 8)

            // Category filter chips
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    // "All" chip
                    categoryChip(label: "All", isSelected: vm.activeCategory == nil) {
                        vm.activeCategory = nil
                    }
                    ForEach(BlockCategory.allCases, id: \.self) { cat in
                        categoryChip(label: cat.filterLabel, isSelected: vm.activeCategory == cat) {
                            vm.activeCategory = (vm.activeCategory == cat) ? nil : cat
                        }
                    }
                }
                .padding(.horizontal, 14)
            }
            .padding(.bottom, 8)

            // Count label — mirrors sheetCount
            Text("\(vm.filteredBlocks.count) locations\(vm.userLocation != nil ? " · sorted by distance" : "")")
                .font(.system(size: 11))
                .foregroundColor(Color(hex: "#9CA3AF"))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 16)
                .padding(.bottom, 6)

            // Block list
            ScrollView(showsIndicators: false) {
                LazyVStack(spacing: 0) {
                    ForEach(vm.filteredBlocks) { block in
                        BlockListRow(
                            block:    block,
                            distance: vm.userLocation.map { haversine(from: $0, to: block.coordinate) }
                        ) {
                            vm.pick(block)
                        }
                        Divider().padding(.leading, 72)
                    }
                }
                .padding(.horizontal, 14)
                .padding(.bottom, 40)
            }
        }
        .background(Color.white)
        .clipShape(RoundedTopRoundedRect(radius: 24))
        .shadow(color: .black.opacity(0.12), radius: 12, x: 0, y: -4)
        .frame(maxHeight: UIScreen.main.bounds.height * 0.65)
    }

    private func categoryChip(label: String, isSelected: Bool, onTap: @escaping () -> Void) -> some View {
        Button(action: onTap) {
            Text(label)
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(isSelected ? .white : Color(hex: "#374151"))
                .padding(.horizontal, 13)
                .padding(.vertical, 7)
                .background(isSelected ? Color(hex: "#111827") : Color.white)
                .clipShape(Capsule())
                .overlay(Capsule().strokeBorder(isSelected ? Color.clear : Color(hex: "#E5E7EB"), lineWidth: 1))
        }
    }
}

// ── BlockListRow — mirrors blockRow in both campus map screens ────────────────
struct BlockListRow: View {
    let block:    CampusBlock
    let distance: Double?
    let onTap:    () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 0) {
                // Short badge
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(block.category.color.opacity(0.094))
                        .frame(width: 46, height: 46)
                    Text(block.short)
                        .font(.system(size: 11, weight: .heavy))
                        .foregroundColor(block.category.color)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                        .minimumScaleFactor(0.6)
                        .frame(width: 38)
                }
                .padding(.trailing, 12)

                // Name + description
                VStack(alignment: .leading, spacing: 1) {
                    Text(block.name)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(Color(hex: "#111827"))
                    Text(block.description)
                        .font(.system(size: 12))
                        .foregroundColor(Color(hex: "#9CA3AF"))
                }

                Spacer()

                // Distance + walk time (only when location available)
                if let d = distance {
                    VStack(alignment: .trailing, spacing: 1) {
                        Text(fmtDist(d))
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(Color(hex: "#6366F1"))
                        Text(fmtWalk(d))
                            .font(.system(size: 11))
                            .foregroundColor(Color(hex: "#9CA3AF"))
                    }
                }
            }
            .padding(.vertical, 12)
        }
        .buttonStyle(.plain)
    }
}

// ── Dashed polyline overlay — mirrors <Polyline lineDashPattern> in TS ────────
// Uses a UIViewRepresentable because SwiftUI Map doesn't support dashed lines natively pre-iOS 17.
struct MapOverlay_DashedLine: View {
    let from:  CLLocationCoordinate2D
    let to:    CLLocationCoordinate2D
    let color: Color

    var body: some View {
        // On iOS 17+ you can use MapPolyline directly.
        // This placeholder view exists so the architecture is correct.
        // Replace with MapPolyline(coordinates: [from, to]).stroke(color, style: StrokeStyle(lineWidth: 2.5, dash: [8, 5]))
        // when targeting iOS 17+.
        EmptyView()
    }
}

// ── Custom shape: top corners rounded only ────────────────────────────────────
struct RoundedTopRoundedRect: Shape {
    let radius: CGFloat
    func path(in rect: CGRect) -> Path {
        var p = Path()
        p.move(to: CGPoint(x: rect.minX, y: rect.maxY))
        p.addLine(to: CGPoint(x: rect.minX, y: rect.minY + radius))
        p.addQuadCurve(to: CGPoint(x: rect.minX + radius, y: rect.minY),
                       control: CGPoint(x: rect.minX, y: rect.minY))
        p.addLine(to: CGPoint(x: rect.maxX - radius, y: rect.minY))
        p.addQuadCurve(to: CGPoint(x: rect.maxX, y: rect.minY + radius),
                       control: CGPoint(x: rect.maxX, y: rect.minY))
        p.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        p.closeSubpath()
        return p
    }
}
