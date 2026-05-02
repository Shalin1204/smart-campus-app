import Foundation

// Direct Swift equivalent of BusStop type in busRoutes.ts
struct BusStop: Identifiable, Codable {
    let id: UUID
    let stop: String
    let time: String   // "HH:mm" 24-hour format — same as TS data

    init(stop: String, time: String) {
        self.id   = UUID()
        self.stop = stop
        self.time = time
    }

    // MARK: Codable (custom, since id is synthesised)
    enum CodingKeys: String, CodingKey { case stop, time }
    init(from decoder: Decoder) throws {
        let c    = try decoder.container(keyedBy: CodingKeys.self)
        stop     = try c.decode(String.self, forKey: .stop)
        time     = try c.decode(String.self, forKey: .time)
        id       = UUID()
    }
}

// Direct Swift equivalent of BusRoute type in busRoutes.ts
struct BusRoute: Identifiable, Codable {
    let id: UUID
    let routeNo: String       // route_no
    let routeName: String     // route_name
    let stops: [BusStop]
    let campusArrival: String // "HH:mm"

    init(routeNo: String, routeName: String, stops: [BusStop], campusArrival: String) {
        self.id            = UUID()
        self.routeNo       = routeNo
        self.routeName     = routeName
        self.stops         = stops
        self.campusArrival = campusArrival
    }

    enum CodingKeys: String, CodingKey { case routeNo, routeName, stops, campusArrival }
    init(from decoder: Decoder) throws {
        let c         = try decoder.container(keyedBy: CodingKeys.self)
        routeNo       = try c.decode(String.self, forKey: .routeNo)
        routeName     = try c.decode(String.self, forKey: .routeName)
        stops         = try c.decode([BusStop].self, forKey: .stops)
        campusArrival = try c.decode(String.self, forKey: .campusArrival)
        id            = UUID()
    }
}

// MARK: - Bus status  (mirrors getBusInfo() in BusTrackingScreen.tsx)

enum BusStatus: String {
    case scheduled = "Scheduled"
    case enRoute   = "En Route"
    case arrived   = "Arrived"

    var color: String {
        switch self {
        case .scheduled: return "#6B7A8D"
        case .enRoute:   return "#16A34A"
        case .arrived:   return "#16A34A"
        }
    }
}

struct BusInfo {
    let status: BusStatus
    let progress: Double        // 0.0 – 1.0
    let currentStop: String
    let nextStop: String?
    let etaMinutes: Int         // minutes to campus; 0 if arrived
    let minsToDepart: Int?      // non-nil only when Scheduled
}