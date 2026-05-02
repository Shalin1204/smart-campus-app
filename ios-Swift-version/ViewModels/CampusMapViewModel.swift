import Foundation
import CoreLocation
import MapKit
import Combine

// Mirrors all @useState hooks in CampusMapScreen.native.tsx

@MainActor
final class CampusMapViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {

    // ── State mirrors ─────────────────────────────────────────────────────────
    @Published var userLocation: CLLocationCoordinate2D? = nil
    @Published var selectedBlock: CampusBlock?           = nil
    @Published var search:        String                 = ""
    @Published var sheetOpen:     Bool                   = false
    @Published var activeCategory: BlockCategory?        = nil    // nil = "All"

    // Map camera region — mirrors initialRegion in MapView
    @Published var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: CAMPUS_CENTER_LAT, longitude: CAMPUS_CENTER_LNG),
        span:   MKCoordinateSpan(latitudeDelta: 0.010, longitudeDelta: 0.010)
    )

    // ── Location ──────────────────────────────────────────────────────────────
    private let locationManager = CLLocationManager()

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHigh
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locs: [CLLocation]) {
        guard let loc = locs.last else { return }
        userLocation = loc.coordinate
    }

    // ── Computed: filtered list — mirrors filtered in TS ──────────────────────
    var filteredBlocks: [CampusBlock] {
        let base = CampusBlock.all.filter { block in
            let catMatch  = activeCategory == nil || block.category == activeCategory
            let q         = search.lowercased()
            let nameMatch = q.isEmpty || block.name.lowercased().contains(q) || block.short.lowercased().contains(q)
            return catMatch && nameMatch
        }
        // Sort by distance if location available — mirrors .sort() in TS
        guard let loc = userLocation else { return base }
        return base.sorted { a, b in
            haversine(from: loc, to: a.coordinate) < haversine(from: loc, to: b.coordinate)
        }
    }

    // ── pick(block) — mirrors pick() in CampusMapScreen.native.tsx ───────────
    func pick(_ block: CampusBlock) {
        selectedBlock = block
        sheetOpen     = false
        // Animate map to the tapped block
        withAnimation {
            region = MKCoordinateRegion(
                center: block.coordinate,
                span:   MKCoordinateSpan(latitudeDelta: 0.004, longitudeDelta: 0.004)
            )
        }
    }

    // ── Re-centre on user location ────────────────────────────────────────────
    func centreOnUser() {
        guard let loc = userLocation else { return }
        region = MKCoordinateRegion(
            center: loc,
            span:   MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
        )
    }

    // ── Distance to selected block ────────────────────────────────────────────
    var distanceToSelected: Double? {
        guard let block = selectedBlock, let loc = userLocation else { return nil }
        return haversine(from: loc, to: block.coordinate)
    }

    // ── Google Maps directions URL — mirrors Linking.openURL in TS ───────────
    func googleMapsURL(for block: CampusBlock) -> URL? {
        URL(string: "https://www.google.com/maps/dir/?api=1&destination=\(block.lat),\(block.lng)&travelmode=walking")
    }
}
