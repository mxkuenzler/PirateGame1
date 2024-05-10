//
//  PirateGameApp.swift
//  PirateGame
//
//  Created by Maxwell Kuenzler on 5/8/24.
//

import SwiftUI

var Manager:GameManager?


@main


struct PirateGameApp: App {

    
    var body: some Scene {
        
        ImmersiveSpace(id: "ImmersiveSpace") {
            ImmersiveView()
        }.immersionStyle(selection: .constant(.full), in: .full)
        
        WindowGroup {
            ContentView()
        }.windowStyle(.volumetric)

    }
}

func getManager() -> GameManager? {
    return Manager
}

func setManager(a:GameManager) {
    Manager = a
}
