import SwiftUI

// NavigationStack replaces Expo Router.
// AppRoute enum (in CampusModule.swift) is the typed equivalent of href strings.
struct ContentView: View {
    var body: some View {
        NavigationStack {
            DashboardView()
                .navigationBarHidden(true)
        }
    }
}