//
//  LoginView.swift
//  DevWarsEP2
//
//  Created by Patrik Ell on 2024-06-23.
//

import SwiftUI
import Foundation

func encodeUsers(_ users: [User]) -> String? {
    let encoder = JSONEncoder()
    if let data = try? encoder.encode(users) {
        return String(data: data, encoding: .utf8)
    }
    return nil
}

func decodeUsers(_ usersString: String) -> [User]? {
    let decoder = JSONDecoder()
    if let data = usersString.data(using: .utf8) {
        return try? decoder.decode([User].self, from: data)
    }
    return nil
}

struct User: Codable, Hashable {
    let username: String
    let password: String
}

struct LoginView: View {
    @AppStorage("savedUsers") private var savedUsersData: String = ""
    @State private var users: [User] = []
    
    @AppStorage("LastLoggedInUser") var lastLoggedInUser = ""
    @State private var newUsername = ""
    @State private var newPassword = ""
    @State private var errorMessage = ""
    
    @Binding var isLoggedIn: Bool
    
    var body: some View {
        VStack {
            VStack {
                Text("The").fontDesign(.serif).font(.largeTitle)
                Text("Procrastinator").fontDesign(.serif).font(.largeTitle)
                Text("Eliminator").fontDesign(.serif).font(.largeTitle)
            }.padding(8).overlay(
                RoundedRectangle(cornerRadius: 80) // Adjust corner radius as needed
                    .stroke(.primary, lineWidth: 2) // Adjust color and line width
            )
            Text("Makes learning fun and exciting!").fontDesign(.serif).font(.caption)
            Spacer()
            VStack(alignment: .leading) {
                Text("Username:")
                TextField("Enter username", text: $newUsername).textFieldStyle(.roundedBorder)
                Text("Password:")
                TextField("Enter password", text: $newPassword).textFieldStyle(.roundedBorder)
            }
            if users.contains(where: { $0.username == newUsername }) {
                Button("Log in", action: {
                    authenticateUser()
                }).buttonStyle(.borderedProminent)
            }
            else {
                Button("Sign up", action: {
                    authenticateUser()
                }).buttonStyle(.borderedProminent)
            }
            Text("\(errorMessage)").foregroundStyle(.red)
            Spacer()
        }.background(Color("BackgroundColor").gradient).padding().onAppear {
            newUsername = lastLoggedInUser
            loadUsers()
        }
    }
    
    func loadUsers() {
        if let decodedUsers = decodeUsers(savedUsersData) {
            users = decodedUsers
        }
    }
    func saveUsers() {
        if let encodedUsers = encodeUsers(users) {
            savedUsersData = encodedUsers
        }
    }
    
    func authenticateUser() {
        let newUser = User(username: newUsername, password: newPassword)
        if !users.contains(where: { $0.username == newUser.username }) {
            users.append(newUser)
            saveUsers()
            isLoggedIn = true
            lastLoggedInUser = newUsername
        } else if users.contains(where: { $0.username == newUsername && $0.password == newPassword}) {
            isLoggedIn = true
            lastLoggedInUser = newUsername
        } else {
            errorMessage = "User \(newUser.username) already exists or the password is wrong."
        }
    }
}

#Preview {
    LoginView(isLoggedIn: .constant(true))
}
