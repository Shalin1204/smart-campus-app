import Foundation
import Combine

// ── Mirrors React state variables in BusTrackingScreen.tsx ──────────────────
//   from, to, results, selected, routeQuery  →  @Published properties here

@MainActor
final class BusTrackingViewModel: ObservableObject {

    // Search fields
    @Published var fromStop: String = ""
    @Published var toStop:   String = "SRM KTR Campus"

    // Route number / name search (second search bar)
    @Published var routeQuery: String = ""

    // Results from "Find Buses"
    @Published var searchResults: [BusRoute]? = nil   // nil = show all routes

    // Detail view
    @Published var selectedRoute: BusRoute? = nil

    // Modal sheets
    @Published var showFromPicker = false
    @Published var showToPicker   = false

    // ── findBuses() — mirrors the function of same name in BusTrackingScreen.tsx
    func findBuses() {
        guard !fromStop.isEmpty else { return }
        let lower = fromStop.lowercased()
        searchResults = BusRoute.all.filter { route in
            route.stops.contains { $0.stop.lowercased() == lower }
        }
    }

    // ── Route query filter — mirrors routeResults computed value
    var routeQueryResults: [BusRoute] {
        guard !routeQuery.isEmpty else { return [] }
        let q = routeQuery.lowercased()
        return BusRoute.all.filter {
            $0.routeNo.lowercased().contains(q) ||
            $0.routeName.lowercased().contains(q)
        }
    }

    // ── List shown in main scroll view ──────────────────────────────────────
    var displayedRoutes: [BusRoute] {
        if let results = searchResults { return results }
        if !routeQuery.isEmpty { return routeQueryResults }
        return BusRoute.all     // "All Routes" default
    }

    var displayLabel: String {
        if let results = searchResults {
            if results.isEmpty { return "No buses found from this stop" }
            return "\(results.count) bus\(results.count > 1 ? "es" : "") from \(fromStop)"
        }
        if !routeQuery.isEmpty { return "" }   // results shown inline, no label
        return "All Routes"
    }

    // ── Swap button — mirrors swap logic in BusTrackingScreen.tsx ───────────
    func swapStops() {
        let tmp   = fromStop
        fromStop  = toStop == "SRM KTR Campus" ? "" : toStop
        toStop    = tmp.isEmpty ? "SRM KTR Campus" : tmp
        searchResults = nil
    }

    func clearFrom() {
        fromStop      = ""
        searchResults = nil
    }
}