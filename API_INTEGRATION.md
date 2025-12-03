# API Integration Guide

This document provides detailed information about integrating the FlixieSwift iOS app with your Node.js/TypeScript/Prisma backend.

## Overview

The FlixieSwift app uses a RESTful API architecture to communicate with your backend. All network requests are handled through the `APIService` class, which uses async/await for clean, modern Swift code.

## Base URL Configuration

### Development
For local development, set the environment variable in Xcode:
```
FLIXIE_API_URL=http://localhost:3000/api
```

### Production
For production builds, update the environment variable to your production URL:
```
FLIXIE_API_URL=https://api.flixie.com/api
```

### Alternative: Info.plist
You can also configure the base URL in your Info.plist:

1. Add to FlixieApp/Info.plist:
```xml
<key>FlixieAPIURL</key>
<string>$(FLIXIE_API_URL)</string>
```

2. Modify APIService.swift to read from Info.plist:
```swift
private init() {
    if let url = Bundle.main.object(forInfoDictionaryKey: "FlixieAPIURL") as? String {
        self.baseURL = url
    } else {
        self.baseURL = "http://localhost:3000/api"
    }
}
```

## Authentication

### Adding Token-Based Authentication

The current implementation doesn't include authentication. To add JWT or token-based auth:

1. **Store Token Securely**
   ```swift
   import Security
   
   class KeychainManager {
       static func saveToken(_ token: String) {
           // Save to keychain
       }
       
       static func getToken() -> String? {
           // Retrieve from keychain
       }
   }
   ```

2. **Update NetworkManager**
   
   Modify `NetworkManager.request()` to include auth headers:
   ```swift
   if let token = KeychainManager.getToken() {
       request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
   }
   ```

3. **Add Login/Logout**
   
   Create authentication views and API endpoints:
   ```swift
   // In APIService.swift
   func login(email: String, password: String) async throws -> AuthResponse {
       // Implement login
   }
   
   func logout() async throws {
       // Implement logout
   }
   ```

## Backend API Specification

### Response Format

All endpoints should return consistent JSON responses:

**Success Response:**
```json
{
  "success": true,
  "data": { /* resource or array */ },
  "message": "Optional success message"
}
```

**Error Response:**
```json
{
  "success": false,
  "data": null,
  "message": "Error description"
}
```

### Endpoints

#### User Endpoints

**Get User Profile**
```
GET /api/users/:userId
Response: APIResponse<User>
```

Example response:
```json
{
  "success": true,
  "data": {
    "id": "user123",
    "username": "johndoe",
    "email": "john@example.com",
    "profileImageUrl": "https://...",
    "bio": "Movie enthusiast",
    "createdAt": "2024-01-01T00:00:00.000Z"
  }
}
```

**Update User Profile**
```
PATCH /api/users/:userId
Body: { "bio": "new bio", "username": "newname" }
Response: APIResponse<User>
```

#### Movie Endpoints

**List Movies (Paginated)**
```
GET /api/movies?page=1&pageSize=20
Response: PaginatedResponse<Movie>
```

Example response:
```json
{
  "items": [
    {
      "id": "movie123",
      "title": "The Matrix",
      "description": "A computer hacker learns...",
      "releaseYear": 1999,
      "duration": 136,
      "posterUrl": "https://...",
      "backdropUrl": "https://...",
      "rating": 8.7,
      "genre": ["Sci-Fi", "Action"],
      "director": "Wachowski Brothers",
      "cast": ["Keanu Reeves", "Laurence Fishburne"]
    }
  ],
  "total": 100,
  "page": 1,
  "pageSize": 20,
  "hasMore": true
}
```

**Get Single Movie**
```
GET /api/movies/:movieId
Response: APIResponse<Movie>
```

**Search Movies**
```
GET /api/movies/search?q=matrix
Response: APIResponse<[Movie]>
```

#### Show Endpoints

**List Shows (Paginated)**
```
GET /api/shows?page=1&pageSize=20
Response: PaginatedResponse<Show>
```

Example response:
```json
{
  "items": [
    {
      "id": "show123",
      "title": "Breaking Bad",
      "description": "A high school chemistry teacher...",
      "seasons": 5,
      "episodes": 62,
      "posterUrl": "https://...",
      "backdropUrl": "https://...",
      "rating": 9.5,
      "genre": ["Drama", "Crime"],
      "creator": "Vince Gilligan",
      "cast": ["Bryan Cranston", "Aaron Paul"]
    }
  ],
  "total": 50,
  "page": 1,
  "pageSize": 20,
  "hasMore": true
}
```

**Get Single Show**
```
GET /api/shows/:showId
Response: APIResponse<Show>
```

**Search Shows**
```
GET /api/shows/search?q=breaking
Response: APIResponse<[Show]>
```

#### Group Endpoints

**List Groups (Paginated)**
```
GET /api/groups?page=1&pageSize=20
Response: PaginatedResponse<Group>
```

Example response:
```json
{
  "items": [
    {
      "id": "group123",
      "name": "Movie Night Crew",
      "description": "Weekly movie watching group",
      "imageUrl": "https://...",
      "memberCount": 15,
      "createdBy": "user123",
      "createdAt": "2024-01-01T00:00:00.000Z"
    }
  ],
  "total": 10,
  "page": 1,
  "pageSize": 20,
  "hasMore": false
}
```

**Get Single Group**
```
GET /api/groups/:groupId
Response: APIResponse<Group>
```

**Create Group**
```
POST /api/groups
Body: { "name": "New Group", "description": "Optional description" }
Response: APIResponse<Group>
```

**Join Group**
```
POST /api/groups/:groupId/join
Response: APIResponse<Boolean>
```

## Prisma Schema Example

Here's a suggested Prisma schema that matches the iOS app models:

```prisma
model User {
  id              String   @id @default(cuid())
  username        String   @unique
  email           String   @unique
  profileImageUrl String?
  bio             String?
  createdAt       DateTime @default(now())
  updatedAt       DateTime @updatedAt
  
  groups          GroupMember[]
  createdGroups   Group[]
}

model Movie {
  id          String   @id @default(cuid())
  title       String
  description String
  releaseYear Int
  duration    Int?
  posterUrl   String?
  backdropUrl String?
  rating      Float?
  genre       String[]
  director    String?
  cast        String[]
  createdAt   DateTime @default(now())
  updatedAt   DateTime @updatedAt
}

model Show {
  id          String   @id @default(cuid())
  title       String
  description String
  seasons     Int?
  episodes    Int?
  posterUrl   String?
  backdropUrl String?
  rating      Float?
  genre       String[]
  creator     String?
  cast        String[]
  createdAt   DateTime @default(now())
  updatedAt   DateTime @updatedAt
}

model Group {
  id          String   @id @default(cuid())
  name        String
  description String?
  imageUrl    String?
  createdBy   String
  creator     User     @relation(fields: [createdBy], references: [id])
  members     GroupMember[]
  createdAt   DateTime @default(now())
  updatedAt   DateTime @updatedAt
}

model GroupMember {
  id        String   @id @default(cuid())
  userId    String
  groupId   String
  user      User     @relation(fields: [userId], references: [id])
  group     Group    @relation(fields: [groupId], references: [id])
  joinedAt  DateTime @default(now())
  
  @@unique([userId, groupId])
}
```

## Example Backend Routes (Express + TypeScript)

```typescript
// users.routes.ts
router.get('/users/:id', async (req, res) => {
  const user = await prisma.user.findUnique({
    where: { id: req.params.id }
  });
  res.json({ success: true, data: user });
});

router.patch('/users/:id', async (req, res) => {
  const user = await prisma.user.update({
    where: { id: req.params.id },
    data: req.body
  });
  res.json({ success: true, data: user });
});

// movies.routes.ts
router.get('/movies', async (req, res) => {
  const page = parseInt(req.query.page as string) || 1;
  const pageSize = parseInt(req.query.pageSize as string) || 20;
  
  const [items, total] = await Promise.all([
    prisma.movie.findMany({
      skip: (page - 1) * pageSize,
      take: pageSize
    }),
    prisma.movie.count()
  ]);
  
  res.json({
    items,
    total,
    page,
    pageSize,
    hasMore: page * pageSize < total
  });
});

router.get('/movies/search', async (req, res) => {
  const movies = await prisma.movie.findMany({
    where: {
      title: {
        contains: req.query.q as string,
        mode: 'insensitive'
      }
    }
  });
  res.json({ success: true, data: movies });
});

// Similar patterns for shows and groups
```

## Error Handling

The app handles errors gracefully. Ensure your backend returns appropriate HTTP status codes:

- `200` - Success
- `201` - Created
- `400` - Bad Request (validation errors)
- `401` - Unauthorized
- `403` - Forbidden
- `404` - Not Found
- `500` - Internal Server Error

Error responses should include descriptive messages:
```json
{
  "success": false,
  "message": "Movie not found"
}
```

## CORS Configuration

For development, configure CORS in your backend:

```typescript
import cors from 'cors';

app.use(cors({
  origin: ['http://localhost:3000', 'capacitor://localhost'],
  credentials: true
}));
```

## Image URLs

When providing image URLs (posters, backdrops, profile images):
- Use absolute URLs (e.g., `https://cdn.flixie.com/posters/movie123.jpg`)
- Ensure images are accessible via HTTPS
- Consider using a CDN for better performance
- Recommended image sizes:
  - Poster: 300x450px
  - Backdrop: 1920x1080px
  - Profile: 300x300px

## Testing the Integration

Use tools like:
- **Postman** - Test API endpoints
- **cURL** - Quick command-line testing
- **Charles Proxy** - Monitor iOS app network traffic

Example cURL test:
```bash
curl -X GET "http://localhost:3000/api/movies?page=1&pageSize=5" \
  -H "Content-Type: application/json"
```

## Performance Considerations

1. **Pagination**: Always use pagination for list endpoints
2. **Caching**: Implement caching headers for static content
3. **Compression**: Enable gzip compression
4. **Rate Limiting**: Protect your API with rate limits

## Next Steps

1. Implement authentication (JWT recommended)
2. Add real-time features with WebSockets
3. Implement push notifications
4. Add video streaming capabilities
5. Implement offline support with local caching
