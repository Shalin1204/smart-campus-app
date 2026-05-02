import Foundation
import SwiftUI

// ── Time helpers — direct port of toMin(), fmt(), nowMin() in BusTrackingScreen.tsx ──

/// "06:15" → total minutes since midnight  (toMin in TS)
func toMin(_ timeStr: String) -> Int {
    let parts = timeStr.split(separator: ":").map { Int($0) ?? 0 }
    guard parts.count == 2 else { return 0 }
    return parts[0] * 60 + parts[1]
}

/// Current time in minutes since midnight  (nowMin in TS)
func nowMin() -> Int {
    let c = Calendar.current
    let now = Date()
    return c.component(.hour, from: now) * 60 + c.component(.minute, from: now)
}

/// "06:15" → "6:15 AM"  (fmt in TS)
func fmt(_ timeStr: String) -> String {
    let parts = timeStr.split(separator: ":").map { Int($0) ?? 0 }
    guard parts.count == 2 else { return timeStr }
    let h = parts[0], m = parts[1]
    let hour12 = h % 12 == 0 ? 12 : h % 12
    let period = h >= 12 ? "PM" : "AM"
    return String(format: "%d:%02d %@", hour12, m, period)
}

// ── getBusInfo() — exact port of the same function in BusTrackingScreen.tsx ──

func getBusInfo(route: BusRoute) -> BusInfo {
    let now     = nowMin()
    let first   = toMin(route.stops[0].time)
    let arrival = toMin(route.campusArrival)

    // SCHEDULED — bus hasn't departed yet
    if now < first {
        return BusInfo(
            status:        .scheduled,
            progress:      0,
            currentStop:   route.stops[0].stop,
            nextStop:      route.stops.count > 1 ? route.stops[1].stop : "SRM KTR Campus",
            etaMinutes:    arrival - now,
            minsToDepart:  first - now
        )
    }

    // ARRIVED — already at campus
    if now >= arrival {
        return BusInfo(
            status:       .arrived,
            progress:     1,
            currentStop:  "SRM KTR Campus",
            nextStop:     nil,
            etaMinutes:   0,
            minsToDepart: nil
        )
    }

    // EN ROUTE — interpolate between stops
    for i in 0 ..< route.stops.count - 1 {
        let a = toMin(route.stops[i].time)
        let b = toMin(route.stops[i + 1].time)
        if now >= a && now < b {
            let seg      = Double(now - a) / Double(b - a)
            let progress = (Double(i) + seg) / Double(route.stops.count)
            return BusInfo(
                status:       .enRoute,
                progress:     progress,
                currentStop:  route.stops[i].stop,
                nextStop:     route.stops[i + 1].stop,
                etaMinutes:   arrival - now,
                minsToDepart: nil
            )
        }
    }

    // Past last stop, still before campus arrival
    return BusInfo(
        status:       .enRoute,
        progress:     0.9,
        currentStop:  route.stops[route.stops.count - 1].stop,
        nextStop:     "SRM KTR Campus",
        etaMinutes:   arrival - now,
        minsToDepart: nil
    )
}

// ── Color hex initializer ────────────────────────────────────────────────────

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r, g, b, a: UInt64
        switch hex.count {
        case 6: (r, g, b, a) = (int >> 16, int >> 8 & 0xFF, int & 0xFF, 255)
        case 8: (r, g, b, a) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:(r, g, b, a) = (1, 1, 1, 255)
        }
        self.init(
            .sRGB,
            red:     Double(r) / 255,
            green:   Double(g) / 255,
            blue:    Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// ── All unique stop names (mirrors ALL_STOPS in BusTrackingScreen.tsx) ──────

let ALL_STOPS: [String] = {
    let raw = BusRoute.all.flatMap { $0.stops.map(\.stop) }
    return Array(Set(raw)).sorted()
}()