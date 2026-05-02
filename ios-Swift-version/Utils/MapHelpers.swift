import Foundation
import CoreLocation

// ── Port of haversine(), fmtDist(), fmtWalk() from CampusMapScreen.native.tsx ─

/// Haversine distance in metres between two lat/lng pairs.
/// Exact port of the haversine() function in CampusMapScreen.native.tsx.
func haversine(lat1: Double, lon1: Double, lat2: Double, lon2: Double) -> Double {
    let R = 6_371_000.0
    let r = Double.pi / 180.0
    let dLat = (lat2 - lat1) * r
    let dLon = (lon2 - lon1) * r
    let a = sin(dLat / 2) * sin(dLat / 2)
          + cos(lat1 * r) * cos(lat2 * r) * sin(dLon / 2) * sin(dLon / 2)
    return R * 2 * atan2(sqrt(a), sqrt(1 - a))
}

/// "123m" or "1.23km"  — mirrors fmtDist in TS
func fmtDist(_ metres: Double) -> String {
    metres < 1000
        ? "\(Int(metres.rounded()))m"
        : String(format: "%.2fkm", metres / 1000)
}

/// "~3 min" — mirrors fmtWalk in TS (80 m/min walking pace)
func fmtWalk(_ metres: Double) -> String {
    let min = Int((metres / 80).rounded())
    return min < 1 ? "<1 min" : "~\(min) min"
}

/// Convenience overload that accepts CLLocationCoordinate2D
func haversine(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) -> Double {
    haversine(lat1: from.latitude, lon1: from.longitude,
              lat2: to.latitude,  lon2: to.longitude)
}
