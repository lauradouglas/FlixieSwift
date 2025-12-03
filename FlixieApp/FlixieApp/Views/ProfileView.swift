import SwiftUI

struct ProfileView: View {
    @State private var user: User?
    @State private var isLoading = false
    @State private var errorMessage: String?
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    if isLoading {
                        ProgressView()
                            .padding()
                    } else if let user = user {
                        // Profile Header
                        VStack(spacing: 16) {
                            // Profile Image
                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: [.flixiePrimary, .flixieSecondary],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 120, height: 120)
                                .overlay(
                                    Image(systemName: "person.fill")
                                        .font(.system(size: 50))
                                        .foregroundColor(.white)
                                )
                            
                            VStack(spacing: 4) {
                                Text(user.username)
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.flixieLightText)
                                
                                Text(user.email)
                                    .font(.subheadline)
                                    .foregroundColor(.flixieMediumText)
                            }
                            
                            if let bio = user.bio {
                                Text(bio)
                                    .font(.body)
                                    .foregroundColor(.flixieLightText)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal)
                            }
                        }
                        .padding()
                        
                        // Profile Actions
                        VStack(spacing: 12) {
                            ProfileActionButton(
                                icon: "square.and.pencil",
                                title: "Edit Profile",
                                color: .flixiePrimary
                            ) {
                                // Edit profile action
                            }
                            
                            ProfileActionButton(
                                icon: "heart.fill",
                                title: "My Favorites",
                                color: .flixieDanger
                            ) {
                                // View favorites
                            }
                            
                            ProfileActionButton(
                                icon: "clock.fill",
                                title: "Watch History",
                                color: .flixieSecondary
                            ) {
                                // View history
                            }
                            
                            ProfileActionButton(
                                icon: "gearshape.fill",
                                title: "Settings",
                                color: .flixieMediumText
                            ) {
                                // Open settings
                            }
                        }
                        .padding()
                        
                    } else {
                        VStack(spacing: 16) {
                            Image(systemName: "person.circle")
                                .font(.system(size: 80))
                                .foregroundColor(.flixieMediumText)
                            
                            Text("No Profile Found")
                                .font(.title3)
                                .foregroundColor(.flixieLightText)
                            
                            if let error = errorMessage {
                                Text(error)
                                    .font(.caption)
                                    .foregroundColor(.flixieDanger)
                                    .multilineTextAlignment(.center)
                                    .padding()
                            }
                            
                            Button("Sign In") {
                                // Sign in action
                            }
                            .buttonStyle(PrimaryButtonStyle())
                        }
                        .padding()
                    }
                }
            }
            .background(Color.flixieBackground.ignoresSafeArea())
            .navigationTitle("Profile")
        }
        .task {
            await loadProfile()
        }
    }
    
    private func loadProfile() async {
        isLoading = true
        errorMessage = nil
        
        // TODO: Replace with actual user ID from authentication system
        // This is a demo implementation - integrate with your auth flow
        let userId = "demo-user-id"
        
        do {
            user = try await APIService.shared.getProfile(userId: userId)
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
}

struct ProfileActionButton: View {
    let icon: String
    let title: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(color)
                    .frame(width: 30)
                
                Text(title)
                    .font(.body)
                    .foregroundColor(.flixieLightText)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.flixieMediumText)
            }
            .padding()
            .background(Color.flixiePrimary.opacity(0.1))
            .cornerRadius(12)
        }
    }
}

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(.white)
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.flixiePrimary)
            .cornerRadius(12)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}

#Preview {
    ProfileView()
}
