import SwiftUI

struct GroupView: View {
    @State private var groups: [Group] = []
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var showCreateGroup = false
    
    var body: some View {
        NavigationView {
            VStack {
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
                            Task { await loadGroups() }
                        }
                        .buttonStyle(PrimaryButtonStyle())
                        .padding(.horizontal, 40)
                    }
                    .padding()
                } else if groups.isEmpty {
                    VStack(spacing: 20) {
                        Image(systemName: "person.3")
                            .font(.system(size: 70))
                            .foregroundColor(.flixieMediumText)
                        
                        Text("No Groups Yet")
                            .font(.title3)
                            .foregroundColor(.flixieLightText)
                        
                        Text("Create or join a group to start watching together")
                            .font(.subheadline)
                            .foregroundColor(.flixieMediumText)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                        
                        Button("Create Group") {
                            showCreateGroup = true
                        }
                        .buttonStyle(PrimaryButtonStyle())
                        .padding(.horizontal, 40)
                    }
                } else {
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(groups) { group in
                                GroupCard(group: group)
                            }
                        }
                        .padding()
                    }
                }
            }
            .background(Color.flixieBackground.ignoresSafeArea())
            .navigationTitle("Groups")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showCreateGroup = true }) {
                        Image(systemName: "plus")
                            .foregroundColor(.flixiePrimary)
                    }
                }
            }
            .sheet(isPresented: $showCreateGroup) {
                CreateGroupView(isPresented: $showCreateGroup) {
                    Task { await loadGroups() }
                }
            }
        }
        .task {
            await loadGroups()
        }
    }
    
    private func loadGroups() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let response = try await APIService.shared.getGroups(page: 1, pageSize: 20)
            groups = response.items
        } catch {
            errorMessage = "Failed to load groups: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
}

struct GroupCard: View {
    let group: Group
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 12) {
                // Group Icon
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [.flixiePrimary, .flixieSecondary],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 60, height: 60)
                    .overlay(
                        Image(systemName: "person.3.fill")
                            .foregroundColor(.white)
                    )
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(group.name)
                        .font(.headline)
                        .foregroundColor(.flixieLightText)
                    
                    if let description = group.description {
                        Text(description)
                            .font(.subheadline)
                            .foregroundColor(.flixieMediumText)
                            .lineLimit(2)
                    }
                    
                    HStack(spacing: 12) {
                        Label("\(group.memberCount)", systemImage: "person.fill")
                            .font(.caption)
                            .foregroundColor(.flixieMediumText)
                    }
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.flixieMediumText)
            }
        }
        .padding()
        .background(Color.flixiePrimary.opacity(0.1))
        .cornerRadius(12)
    }
}

struct CreateGroupView: View {
    @Binding var isPresented: Bool
    var onGroupCreated: () -> Void
    
    @State private var groupName = ""
    @State private var groupDescription = ""
    @State private var isCreating = false
    @State private var errorMessage: String?
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Group Details").foregroundColor(.flixieLightText)) {
                    TextField("Group Name", text: $groupName)
                        .foregroundColor(.flixieLightText)
                    
                    TextField("Description (optional)", text: $groupDescription, axis: .vertical)
                        .foregroundColor(.flixieLightText)
                        .lineLimit(3...6)
                }
                
                if let error = errorMessage {
                    Section {
                        Text(error)
                            .foregroundColor(.flixieDanger)
                            .font(.caption)
                    }
                }
                
                Section {
                    Button(action: createGroup) {
                        if isCreating {
                            ProgressView()
                        } else {
                            Text("Create Group")
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                        }
                    }
                    .listRowBackground(Color.flixiePrimary)
                    .disabled(groupName.isEmpty || isCreating)
                }
            }
            .scrollContentBackground(.hidden)
            .background(Color.flixieBackground.ignoresSafeArea())
            .navigationTitle("New Group")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        isPresented = false
                    }
                    .foregroundColor(.flixiePrimary)
                }
            }
        }
    }
    
    private func createGroup() {
        Task {
            isCreating = true
            errorMessage = nil
            
            do {
                _ = try await APIService.shared.createGroup(
                    name: groupName,
                    description: groupDescription.isEmpty ? nil : groupDescription
                )
                isPresented = false
                onGroupCreated()
            } catch {
                errorMessage = "Failed to create group: \(error.localizedDescription)"
            }
            
            isCreating = false
        }
    }
}

#Preview {
    GroupView()
}
