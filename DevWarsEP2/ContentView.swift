//
//  ContentView.swift
//  DevWarsEP2
//
//  Created by Patrik Ell on 2024-06-18.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject private var viewModel: CourseViewModel
    
    @State private var isLoggedIn = false
    @AppStorage("LastLoggedInUser") var lastLoggedInUser = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                if isLoggedIn == false {
                    LoginView(isLoggedIn: $isLoggedIn)
                }
                else {
                    CompactUserView()
                    ActiveCoursesView()
                }
            }.toolbar {
                if isLoggedIn == true {
                    NavigationLink("\(Image(systemName: "plus.circle"))", destination: AllCoursesView()).font(.title2)
                }
            }.background(Color("BackgroundColor").gradient)
        }
    }
}

#Preview {
    ContentView()
}
