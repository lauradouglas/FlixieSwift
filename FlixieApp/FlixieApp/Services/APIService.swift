import Foundation

class APIService: ObservableObject {
    static let shared = APIService()
    
    // Configure your backend base URL here
    private let baseURL: String
    
    private init() {
        // Configure via FLIXIE_API_URL environment variable in Xcode scheme
        // Default to localhost for local development
        self.baseURL = ProcessInfo.processInfo.environment["FLIXIE_API_URL"] ?? "http://localhost:3000/api"
    }
    
    // MARK: - User Endpoints
    
    func getProfile(userId: String) async throws -> User {
        guard let url = URL(string: "\(baseURL)/users/\(userId)") else {
            throw NetworkError.invalidURL
        }
        let response: APIResponse<User> = try await NetworkManager.shared.request(url: url)
        guard let user = response.data else {
            throw NetworkError.noData
        }
        return user
    }
    
    func updateProfile(userId: String, updates: [String: Any]) async throws -> User {
        guard let url = URL(string: "\(baseURL)/users/\(userId)") else {
            throw NetworkError.invalidURL
        }
        let jsonData = try JSONSerialization.data(withJSONObject: updates)
        let response: APIResponse<User> = try await NetworkManager.shared.request(
            url: url,
            method: "PATCH",
            body: jsonData
        )
        guard let user = response.data else {
            throw NetworkError.noData
        }
        return user
    }
    
    // MARK: - Movie Endpoints
    
    func getMovies(page: Int = 1, pageSize: Int = 20) async throws -> PaginatedResponse<Movie> {
        guard let url = URL(string: "\(baseURL)/movies?page=\(page)&pageSize=\(pageSize)") else {
            throw NetworkError.invalidURL
        }
        return try await NetworkManager.shared.request(url: url)
    }
    
    func getMovie(id: String) async throws -> Movie {
        guard let url = URL(string: "\(baseURL)/movies/\(id)") else {
            throw NetworkError.invalidURL
        }
        let response: APIResponse<Movie> = try await NetworkManager.shared.request(url: url)
        guard let movie = response.data else {
            throw NetworkError.noData
        }
        return movie
    }
    
    func searchMovies(query: String) async throws -> [Movie] {
        guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "\(baseURL)/movies/search?q=\(encodedQuery)") else {
            throw NetworkError.invalidURL
        }
        let response: APIResponse<[Movie]> = try await NetworkManager.shared.request(url: url)
        return response.data ?? []
    }
    
    // MARK: - Show Endpoints
    
    func getShows(page: Int = 1, pageSize: Int = 20) async throws -> PaginatedResponse<Show> {
        guard let url = URL(string: "\(baseURL)/shows?page=\(page)&pageSize=\(pageSize)") else {
            throw NetworkError.invalidURL
        }
        return try await NetworkManager.shared.request(url: url)
    }
    
    func getShow(id: String) async throws -> Show {
        guard let url = URL(string: "\(baseURL)/shows/\(id)") else {
            throw NetworkError.invalidURL
        }
        let response: APIResponse<Show> = try await NetworkManager.shared.request(url: url)
        guard let show = response.data else {
            throw NetworkError.noData
        }
        return show
    }
    
    func searchShows(query: String) async throws -> [Show] {
        guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "\(baseURL)/shows/search?q=\(encodedQuery)") else {
            throw NetworkError.invalidURL
        }
        let response: APIResponse<[Show]> = try await NetworkManager.shared.request(url: url)
        return response.data ?? []
    }
    
    // MARK: - Group Endpoints
    
    func getGroups(page: Int = 1, pageSize: Int = 20) async throws -> PaginatedResponse<Group> {
        guard let url = URL(string: "\(baseURL)/groups?page=\(page)&pageSize=\(pageSize)") else {
            throw NetworkError.invalidURL
        }
        return try await NetworkManager.shared.request(url: url)
    }
    
    func getGroup(id: String) async throws -> Group {
        guard let url = URL(string: "\(baseURL)/groups/\(id)") else {
            throw NetworkError.invalidURL
        }
        let response: APIResponse<Group> = try await NetworkManager.shared.request(url: url)
        guard let group = response.data else {
            throw NetworkError.noData
        }
        return group
    }
    
    func createGroup(name: String, description: String?) async throws -> Group {
        guard let url = URL(string: "\(baseURL)/groups") else {
            throw NetworkError.invalidURL
        }
        var body: [String: Any] = ["name": name]
        if let description = description {
            body["description"] = description
        }
        let jsonData = try JSONSerialization.data(withJSONObject: body)
        let response: APIResponse<Group> = try await NetworkManager.shared.request(
            url: url,
            method: "POST",
            body: jsonData
        )
        guard let group = response.data else {
            throw NetworkError.noData
        }
        return group
    }
    
    func joinGroup(groupId: String) async throws -> Bool {
        guard let url = URL(string: "\(baseURL)/groups/\(groupId)/join") else {
            throw NetworkError.invalidURL
        }
        let response: APIResponse<Bool> = try await NetworkManager.shared.request(
            url: url,
            method: "POST"
        )
        return response.success
    }
}
