//
//  ActiveCoursesView.swift
//  DevWarsEP2
//
//  Created by Patrik Ell on 2024-06-23.
//

import SwiftUI
import Foundation

struct ActiveCourse: Codable {
    let courseName: String
    var isFinished: Bool
}

struct ActiveUser: Codable {
    let username: String
    var activeCourses: [String: ActiveCourse]
}

class CourseViewModel: ObservableObject {
    @AppStorage("activeUsers") private var activeUsersData: Data = Data()
    @AppStorage("LastLoggedInUser") var lastLoggedInUser = ""
    @Published var activeUsers: [String: ActiveUser] = [:]
    
    init() {
        loadActiveUsers()
    }
    
    func loadActiveUsers() {
        if let loadedUsers = try? JSONDecoder().decode([String: ActiveUser].self, from: activeUsersData) {
            activeUsers = loadedUsers
        }
    }
    
    func saveActiveUsers() {
        if let encodedData = try? JSONEncoder().encode(activeUsers) {
            activeUsersData = encodedData
        }
    }
    
    func addCourseForCurrentUser(courseName: String, isFinished: Bool = false) {
        guard var currentUser = activeUsers[lastLoggedInUser] else {
            // Create a new user if not found
            activeUsers[lastLoggedInUser] = ActiveUser(username: lastLoggedInUser, activeCourses: [courseName: ActiveCourse(courseName: courseName, isFinished: isFinished)])
            saveActiveUsers()
            return
        }
        
        // Update existing user
        currentUser.activeCourses[courseName] = ActiveCourse(courseName: courseName, isFinished: isFinished)
        activeUsers[lastLoggedInUser] = currentUser
        saveActiveUsers()
    }
    
    func updateCourseForCurrentUser(courseName: String, isFinished: Bool) {
        guard var currentUser = activeUsers[lastLoggedInUser] else {
            // Handle scenario where user isn't found (optional)
            return
        }
        
        if var activeCourse = currentUser.activeCourses[courseName] {
            activeCourse.isFinished = isFinished
            currentUser.activeCourses[courseName] = activeCourse
            activeUsers[lastLoggedInUser] = currentUser
            saveActiveUsers()
        }
    }
    func countFinishedCoursesForCurrentUser() -> Int {
            guard let currentUser = activeUsers[lastLoggedInUser] else {
                return 0
            }

            return currentUser.activeCourses.values.filter { $0.isFinished }.count
        }
}



struct ActiveCoursesView: View {
    
    @EnvironmentObject private var viewModel: CourseViewModel
    @AppStorage("LastLoggedInUser") var lastLoggedInUser = ""
    
    var body: some View {
        List {
            ForEach(viewModel.activeUsers[lastLoggedInUser]?.activeCourses.sorted(by: { $0.key < $1.key }) ?? [], id: \.key) { courseName, course in
                CourseRow(courseName: courseName, isFinished: course.isFinished) { isFinished in
                    viewModel.updateCourseForCurrentUser(courseName: courseName, isFinished: isFinished)
                }
            }
        }.scrollContentBackground(.hidden)
    }
}

struct CourseRow: View {
    let courseName: String
    let isFinished: Bool
    let toggleFinished: (Bool) -> Void
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(courseName).font(.title2)
            HStack {
                Text("Finished:")
                Spacer()
                Toggle("", isOn: Binding<Bool>(
                    get: { isFinished },
                    set: { newValue in
                        toggleFinished(newValue)
                    }
                ))
            }
        }
    }
}

#Preview {
    ActiveCoursesView()
}
