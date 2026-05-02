import SwiftUI

// ── Full port of RouteDetail component in BusTrackingScreen.tsx ─────────────
// pulseAnim        →  @State isPulsing + withAnimation repeating
// ScrollView stops →  ForEach over route.stops + campus terminal stop

struct RouteDetailView: View {
    let route:  BusRoute
    let onBack: () -> Void

    @State private var pulseScale: CGFloat = 1.0
    private let timer = Timer.publish(every: 0.7, on: .main, in: .common).autoconnect()

    var body: some View {
        let info      = getBusInfo(route: route)
        let statusHex = info.status == .scheduled ? "#6B7A8D" : "#16A34A"
        let now       = nowMin()

        ZStack(alignment: .top) {
            Color(hex: "#F3F4F6").ignoresSafeArea()

            VStack(spacing: 0) {

                // ── Header — mirrors detailHeader ──────────────────────────
                VStack(alignment: .leading, spacing: 0) {
                    Button(action: onBack) {
                        Text("‹ Back")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(Color(hex: "#16A34A"))
                    }
                    .padding(.bottom, 8)

                    Text("Route \(route.routeNo)")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(Color(hex: "#6B7A8D"))

                    Text(route.routeName)
                        .font(.system(size: 22, weight: .heavy))
                        .foregroundColor(Color(hex: "#111827"))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)
                .padding(.top, 52)
                .padding(.bottom, 16)
                .background(Color.white)
                .overlay(
                    Rectangle()
                        .fill(Color(hex: "#F3F4F6"))
                        .frame(height: 1),
                    alignment: .bottom
                )

                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 0) {

                        // ── Status card — mirrors detailCard ───────────────
                        VStack(alignment: .leading, spacing: 0) {

                            // Pulse dot + status text
                            HStack(spacing: 8) {
                                Circle()
                                    .fill(Color(hex: statusHex))
                                    .frame(width: 10, height: 10)
                                    .scaleEffect(info.status == .enRoute ? pulseScale : 1)

                                Text(info.status.rawValue.uppercased())
                                    .font(.system(size: 12, weight: .bold))
                                    .tracking(1)
                                    .foregroundColor(Color(hex: statusHex))
                            }
                            .padding(.bottom, 8)

                            // Current stop
                            Text(info.status == .arrived ? "🏫 SRM KTR Campus" : "📍 \(info.currentStop)")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(Color(hex: "#111827"))

                            // Next stop
                            if let next = info.nextStop, info.status != .arrived {
                                Text("Next → \(next)")
                                    .font(.system(size: 13))
                                    .foregroundColor(Color(hex: "#6B7A8D"))
                                    .padding(.top, 2)
                            }

                            // Progress bar
                            GeometryReader { geo in
                                ZStack(alignment: .leading) {
                                    Rectangle().fill(Color(hex: "#F3F4F6"))
                                    Rectangle()
                                        .fill(Color(hex: "#16A34A"))
                                        .frame(width: geo.size.width * CGFloat(info.progress))
                                }
                                .clipShape(RoundedRectangle(cornerRadius: 3))
                            }
                            .frame(height: 5)
                            .padding(.vertical, 12)

                            // Time row: Departs | Arrives Campus | ETA
                            HStack(spacing: 0) {
                                timeBox(label: "Departs",        value: fmt(route.stops[0].time),  color: nil)
                                Divider().frame(height: 30)
                                timeBox(label: "Arrives Campus", value: fmt(route.campusArrival),   color: nil)
                                if info.etaMinutes > 0 {
                                    Divider().frame(height: 30)
                                    timeBox(label: "ETA", value: "\(info.etaMinutes) min", color: statusHex)
                                }
                            }
                        }
                        .padding(16)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 2)
                        .padding(16)

                        // ── All Stops label ───────────────────────────────
                        Text("ALL STOPS")
                            .font(.system(size: 11, weight: .bold))
                            .tracking(1.5)
                            .foregroundColor(Color(hex: "#9CA3AF"))
                            .padding(.leading, 20)
                            .padding(.bottom, 4)

                        // ── Stop timeline ─────────────────────────────────
                        ForEach(Array(route.stops.enumerated()), id: \.offset) { idx, stop in
                            let isPast    = now > toMin(stop.time) && info.status != .scheduled
                            let isCurrent = info.currentStop == stop.stop && info.status == .enRoute
                            let isLast    = idx == route.stops.count - 1

                            StopRowView(
                                name:      (isCurrent ? "📍 " : "") + stop.stop,
                                time:      fmt(stop.time),
                                isPast:    isPast && !isCurrent,
                                isCurrent: isCurrent,
                                showLine:  !isLast
                            )
                        }

                        // Terminal: SRM KTR Campus
                        StopRowView(
                            name:      "🏫 SRM KTR Campus",
                            time:      fmt(route.campusArrival),
                            isPast:    false,
                            isCurrent: info.status == .arrived,
                            showLine:  false,
                            isTerminal: true
                        )

                        Spacer(minLength: 40)
                    }
                }
            }
        }
        // Pulse animation — mirrors Animated.loop in useEffect
        .onReceive(timer) { _ in
            guard info.status == .enRoute else { return }
            withAnimation(.easeInOut(duration: 0.7)) {
                pulseScale = pulseScale == 1.0 ? 1.5 : 1.0
            }
        }
    }

    private func timeBox(label: String, value: String, color: String?) -> some View {
        VStack(spacing: 3) {
            Text(label)
                .font(.system(size: 11))
                .foregroundColor(Color(hex: "#9CA3AF"))
            Text(value)
                .font(.system(size: 13, weight: .bold))
                .foregroundColor(color != nil ? Color(hex: color!) : Color(hex: "#111827"))
        }
        .frame(maxWidth: .infinity)
    }
}

// ── StopRowView — mirrors the stop row rendering inside RouteDetail ──────────
struct StopRowView: View {
    let name:       String
    let time:       String
    let isPast:     Bool
    let isCurrent:  Bool
    let showLine:   Bool
    var isTerminal: Bool = false

    var circleColor: Color {
        if isTerminal || isCurrent { return Color(hex: "#16A34A") }
        if isPast { return Color(hex: "#D1D5DB") }
        return Color.white
    }

    var circleBorderColor: Color {
        if isTerminal || isCurrent { return Color(hex: "#16A34A") }
        if isPast { return Color(hex: "#D1D5DB") }
        return Color(hex: "#9CA3AF")
    }

    var nameColor: Color {
        if isCurrent || isTerminal { return Color(hex: "#16A34A") }
        if isPast { return Color(hex: "#9CA3AF") }
        return Color(hex: "#374151")
    }

    var body: some View {
        HStack(alignment: .top, spacing: 0) {
            // Timeline column
            VStack(spacing: 0) {
                ZStack {
                    Circle()
                        .fill(circleColor)
                        .frame(width: 12, height: 12)
                    Circle()
                        .strokeBorder(circleBorderColor, lineWidth: 2)
                        .frame(width: 12, height: 12)
                }
                .padding(.top, 6)

                if showLine {
                    Rectangle()
                        .fill(isPast ? Color(hex: "#D1D5DB") : Color(hex: "#E5E7EB"))
                        .frame(width: 2)
                        .frame(maxHeight: .infinity)
                        .padding(.top, 2)
                }
            }
            .frame(width: 28)

            // Stop name + time
            HStack {
                Text(name)
                    .font(.system(size: 14, weight: isCurrent || isTerminal ? .bold : .regular))
                    .foregroundColor(nameColor)
                    .fixedSize(horizontal: false, vertical: true)
                Spacer()
                Text(time)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(isPast && !isCurrent ? Color(hex: "#D1D5DB") : Color(hex: "#6B7A8D"))
            }
            .padding(.top, 2)
            .padding(.bottom, 10)
        }
        .padding(.horizontal, 20)
        .frame(minHeight: 50, alignment: .top)
    }
}