//
//  LayoverExplorerApp.swift
//  LayoverExplorer
//
//  Created by Luis Castillo on 6/13/23.
//

import SwiftUI

@main
struct LayoverExplorerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(Network())
        }
    }
}
