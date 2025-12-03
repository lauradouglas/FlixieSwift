import SwiftUI

struct HomeView: View {
    @State private var featuredMovies: [Movie] = []
    @State private var featuredShows: [Show] = []
    @State private var isLoading = false
    @State private var errorMessage: String?
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    if isLoading {
                        ProgressView()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .padding()
                    } else {
                        // Hero Section
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Welcome to Flixie")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(.flixieLightText)
                            
                            Text("Discover amazing movies and shows")
                                .font(.subheadline)
                                .foregroundColor(.flixieMediumText)
                        }
                        .padding(.horizontal)
                        .padding(.top)
                        
                        // Featured Movies Section
                        if !featuredMovies.isEmpty {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Featured Movies")
                                    .font(.title2)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.flixieLightText)
                                    .padding(.horizontal)
                                
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 16) {
                                        ForEach(featuredMovies) { movie in
                                            MovieCard(movie: movie)
                                        }
                                    }
                                    .padding(.horizontal)
                                }
                            }
                        }
                        
                        // Featured Shows Section
                        if !featuredShows.isEmpty {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Featured Shows")
                                    .font(.title2)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.flixieLightText)
                                    .padding(.horizontal)
                                
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 16) {
                                        ForEach(featuredShows) { show in
                                            ShowCard(show: show)
                                        }
                                    }
                                    .padding(.horizontal)
                                }
                            }
                        }
                        
                        if let error = errorMessage {
                            Text(error)
                                .foregroundColor(.flixieDanger)
                                .padding()
                        }
                    }
                }
            }
            .background(Color.flixieBackground.ignoresSafeArea())
            .navigationTitle("Flixie")
            .navigationBarTitleDisplayMode(.inline)
        }
        .task {
            await loadContent()
        }
    }
    
    private func loadContent() async {
        isLoading = true
        errorMessage = nil
        
        do {
            async let movies = APIService.shared.getMovies(page: 1, pageSize: 5)
            async let shows = APIService.shared.getShows(page: 1, pageSize: 5)
            
            let (movieResponse, showResponse) = try await (movies, shows)
            featuredMovies = movieResponse.items
            featuredShows = showResponse.items
        } catch {
            errorMessage = "Failed to load content: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
}

struct MovieCard: View {
    let movie: Movie
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Placeholder for movie poster
            Rectangle()
                .fill(Color.flixiePrimary.opacity(0.3))
                .frame(width: 140, height: 210)
                .cornerRadius(12)
                .overlay(
                    VStack {
                        Image(systemName: "film.fill")
                            .font(.largeTitle)
                            .foregroundColor(.flixieMediumText)
                        Text(movie.title)
                            .font(.caption)
                            .foregroundColor(.flixieLightText)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 8)
                    }
                )
            
            Text(movie.title)
                .font(.headline)
                .foregroundColor(.flixieLightText)
                .lineLimit(1)
                .frame(width: 140)
            
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
        }
    }
}

struct ShowCard: View {
    let show: Show
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Placeholder for show poster
            Rectangle()
                .fill(Color.flixieSecondary.opacity(0.3))
                .frame(width: 140, height: 210)
                .cornerRadius(12)
                .overlay(
                    VStack {
                        Image(systemName: "tv.fill")
                            .font(.largeTitle)
                            .foregroundColor(.flixieMediumText)
                        Text(show.title)
                            .font(.caption)
                            .foregroundColor(.flixieLightText)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 8)
                    }
                )
            
            Text(show.title)
                .font(.headline)
                .foregroundColor(.flixieLightText)
                .lineLimit(1)
                .frame(width: 140)
            
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
        }
    }
}

#Preview {
    HomeView()
}
