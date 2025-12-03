import SwiftUI

struct MoviesView: View {
    @State private var movies: [Movie] = []
    @State private var searchText = ""
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var currentPage = 1
    
    var filteredMovies: [Movie] {
        if searchText.isEmpty {
            return movies
        }
        return movies.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                // Search Bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.flixieMediumText)
                    
                    TextField("Search movies...", text: $searchText)
                        .foregroundColor(.flixieLightText)
                        .onChange(of: searchText) { oldValue, newValue in
                            if !newValue.isEmpty {
                                Task {
                                    await searchMovies(query: newValue)
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
                .background(Color.flixiePrimary.opacity(0.2))
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
                            Task { await loadMovies() }
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
                            ForEach(filteredMovies) { movie in
                                MovieGridCard(movie: movie)
                            }
                        }
                        .padding()
                    }
                }
            }
            .background(Color.flixieBackground.ignoresSafeArea())
            .navigationTitle("Movies")
        }
        .task {
            if movies.isEmpty {
                await loadMovies()
            }
        }
    }
    
    private func loadMovies() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let response = try await APIService.shared.getMovies(page: currentPage, pageSize: 20)
            movies = response.items
        } catch {
            errorMessage = "Failed to load movies: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
    
    private func searchMovies(query: String) async {
        guard !query.isEmpty else {
            await loadMovies()
            return
        }
        
        do {
            movies = try await APIService.shared.searchMovies(query: query)
        } catch {
            errorMessage = "Search failed: \(error.localizedDescription)"
        }
    }
}

struct MovieGridCard: View {
    let movie: Movie
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Movie Poster Placeholder
            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [.flixiePrimary.opacity(0.6), .flixieTertiary.opacity(0.6)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(height: 240)
                .cornerRadius(12)
                .overlay(
                    VStack {
                        Image(systemName: "film.fill")
                            .font(.system(size: 40))
                            .foregroundColor(.white.opacity(0.8))
                        Text(String(movie.releaseYear))
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.8))
                    }
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(movie.title)
                    .font(.headline)
                    .foregroundColor(.flixieLightText)
                    .lineLimit(2)
                
                HStack {
                    if let rating = movie.rating {
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
                    
                    if let duration = movie.duration {
                        Text("\(duration) min")
                            .font(.caption)
                            .foregroundColor(.flixieMediumText)
                    }
                }
            }
        }
    }
}

#Preview {
    MoviesView()
}
