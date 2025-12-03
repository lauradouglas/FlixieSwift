import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
                .tag(0)
            
            MoviesView()
                .tabItem {
                    Label("Movies", systemImage: "film.fill")
                }
                .tag(1)
            
            ShowsView()
                .tabItem {
                    Label("Shows", systemImage: "tv.fill")
                }
                .tag(2)
            
            GroupView()
                .tabItem {
                    Label("Groups", systemImage: "person.3.fill")
                }
                .tag(3)
            
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
                .tag(4)
        }
        .accentColor(.flixiePrimary)
    }
}

#Preview {
    ContentView()
}
