import SwiftUI

struct ShowsView: View {
    @State private var shows: [Show] = []
    @State private var searchText = ""
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var currentPage = 1
    
    var filteredShows: [Show] {
        if searchText.isEmpty {
            return shows
        }
        return shows.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                // Search Bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.flixieMediumText)
                    
                    TextField("Search shows...", text: $searchText)
                        .foregroundColor(.flixieLightText)
                        .onChange(of: searchText) { oldValue, newValue in
                            if !newValue.isEmpty {
                                Task {
                                    await searchShows(query: newValue)
                                }
                            }
                        }
                    
                    if !searchText.isEmpty {
                        Button(action: { searchText = "" }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.flixieMediumText)
                        }
                    }
                }
                .padding()
                .background(Color.flixieSecondary.opacity(0.2))
                .cornerRadius(12)
                .padding()
                
                if isLoading {
                    ProgressView()
                        .padding()
                } else if let error = errorMessage {
                    VStack(spacing: 16) {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.system(size: 50))
                            .foregroundColor(.flixieDanger)
                        Text(error)
                            .foregroundColor(.flixieDanger)
                            .multilineTextAlignment(.center)
                        Button("Retry") {
                            Task { await loadShows() }
                        }
                        .buttonStyle(PrimaryButtonStyle())
                        .padding(.horizontal, 40)
                    }
                    .padding()
                } else {
                    ScrollView {
                        LazyVGrid(columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ], spacing: 16) {
                            ForEach(filteredShows) { show in
                                ShowGridCard(show: show)
                            }
                        }
                        .padding()
                    }
                }
            }
            .background(Color.flixieBackground.ignoresSafeArea())
            .navigationTitle("TV Shows")
        }
        .task {
            if shows.isEmpty {
                await loadShows()
            }
        }
    }
    
    private func loadShows() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let response = try await APIService.shared.getShows(page: currentPage, pageSize: 20)
            shows = response.items
        } catch {
            errorMessage = "Failed to load shows: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
    
    private func searchShows(query: String) async {
        guard !query.isEmpty else {
            await loadShows()
            return
        }
        
        do {
            shows = try await APIService.shared.searchShows(query: query)
        } catch {
            errorMessage = "Search failed: \(error.localizedDescription)"
        }
    }
}

struct ShowGridCard: View {
    let show: Show
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Show Poster Placeholder
            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [.flixieSecondary.opacity(0.6), .flixieSuccess.opacity(0.6)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(height: 240)
                .cornerRadius(12)
                .overlay(
                    VStack {
                        Image(systemName: "tv.fill")
                            .font(.system(size: 40))
                            .foregroundColor(.white.opacity(0.8))
                        if let seasons = show.seasons {
                            Text("\(seasons) Season\(seasons > 1 ? "s" : "")")
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.8))
                        }
                    }
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(show.title)
                    .font(.headline)
                    .foregroundColor(.flixieLightText)
                    .lineLimit(2)
                
                HStack {
                    if let rating = show.rating {
                        HStack(spacing: 4) {
                            Image(systemName: "star.fill")
                                .font(.caption)
                                .foregroundColor(.flixieWarning)
                            Text(String(format: "%.1f", rating))
                                .font(.caption)
                                .foregroundColor(.flixieMediumText)
                        }
                    }
                    
                    Spacer()
                    
                    if let episodes = show.episodes {
                        Text("\(episodes) eps")
                            .font(.caption)
                            .foregroundColor(.flixieMediumText)
                    }
                }
            }
        }
    }
}

#Preview {
    ShowsView()
}
