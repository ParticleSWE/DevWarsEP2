//
//  CompactUserView.swift
//  DevWarsEP2
//
//  Created by Patrik Ell on 2024-06-23.
//

import SwiftUI

struct CompactUserView: View {
    
    @EnvironmentObject private var viewModel: CourseViewModel
    
    @State private var clearedCourses = 0.0
    @State private var totalCourses = 10.0
    
    @AppStorage("LastLoggedInUser") var lastLoggedInUser = ""
    
    @State private var showAlert = false
    
    var body: some View {
        VStack {
            HStack {
                if lastLoggedInUser == "Dragon" {
                    Image("Dino_Icon").resizable().scaledToFit().frame(height: 100).clipShape(Circle())
                }
                else if lastLoggedInUser == "Jake" {
                    Image("Jake").resizable().scaledToFit().frame(height: 100).clipShape(Circle())
                }
                else if lastLoggedInUser == "Santa" {
                    Image("Santa").resizable().scaledToFit().frame(height: 100).clipShape(Circle())
                }
                else {
                    Button("\(Image(systemName: "person.circle"))", action: {
                        showAlert.toggle()
                    }).font(.system(size: 78))
                }
                
                VStack(alignment: .leading) {
                    Text("\(lastLoggedInUser)").font(.title)
                    Text("Cleared courses: \(viewModel.countFinishedCoursesForCurrentUser())/\(totalCourses, specifier: "%.0f")")
                    ProgressView(value: Double(viewModel.countFinishedCoursesForCurrentUser()), total: totalCourses).scaleEffect(x: 1, y: 4, anchor: .center)
                }
            }.alert("Feature not available in BETA version of the app.", isPresented: $showAlert) {
                
            }
        }.padding()
    }
}

#Preview {
    CompactUserView()
}
