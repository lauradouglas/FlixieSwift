import Foundation

// MARK: - User Model
struct User: Codable, Identifiable {
    let id: String
    let username: String
    let email: String
    let profileImageURL: String?
    let bio: String?
    let createdAt: Date?
    
    enum CodingKeys: String, CodingKey {
        case id
        case username
        case email
        case profileImageURL = "profileImageUrl"
        case bio
        case createdAt
    }
}

// MARK: - Movie Model
struct Movie: Codable, Identifiable {
    let id: String
    let title: String
    let description: String
    let releaseYear: Int
    let duration: Int?
    let posterURL: String?
    let backdropURL: String?
    let rating: Double?
    let genre: [String]
    let director: String?
    let cast: [String]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case description
        case releaseYear
        case duration
        case posterURL = "posterUrl"
        case backdropURL = "backdropUrl"
        case rating
        case genre
        case director
        case cast
    }
}

// MARK: - Show Model
struct Show: Codable, Identifiable {
    let id: String
    let title: String
    let description: String
    let seasons: Int?
    let episodes: Int?
    let posterURL: String?
    let backdropURL: String?
    let rating: Double?
    let genre: [String]
    let creator: String?
    let cast: [String]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case description
        case seasons
        case episodes
        case posterURL = "posterUrl"
        case backdropURL = "backdropUrl"
        case rating
        case genre
        case creator
        case cast
    }
}

// MARK: - Group Model
struct Group: Codable, Identifiable {
    let id: String
    let name: String
    let description: String?
    let imageURL: String?
    let memberCount: Int
    let createdBy: String
    let createdAt: Date?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case imageURL = "imageUrl"
        case memberCount
        case createdBy
        case createdAt
    }
}

// MARK: - API Response Models
struct APIResponse<T: Codable>: Codable {
    let success: Bool
    let data: T?
    let message: String?
}

struct PaginatedResponse<T: Codable>: Codable {
    let items: [T]
    let total: Int
    let page: Int
    let pageSize: Int
    let hasMore: Bool
}
