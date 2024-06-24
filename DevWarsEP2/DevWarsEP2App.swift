//
//  DevWarsEP2App.swift
//  DevWarsEP2
//
//  Created by Patrik Ell on 2024-06-18.
//

import SwiftUI

@main
struct DevWarsEP2App: App {
    
    @StateObject private var viewModel = CourseViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(viewModel)
        }
    }
}
