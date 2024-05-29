//
//  PirateGameApp.swift
//  PirateGame
//
//  Created by Maxwell Kuenzler on 5/8/24.
//

import SwiftUI

var Manager:GameManager?
var levelManager:LevelManager?

let cardboardSpawn = SIMD3<Float>(-1, 3, -1)
let woodSpawn = SIMD3<Float>(0, 3, -1)
let stoneSpawn = SIMD3<Float>(1, 3, -1)

var coins = 10000



@main


struct PirateGameApp: App {
    
    

    var body: some Scene {
        ImmersiveSpace(id: "ImmersiveSpace") {
            ImmersiveView()
        }.immersionStyle(selection: .constant(.full), in: .full)
        WindowGroup {
            ContentView()
        }.windowStyle(.volumetric).defaultSize(width: 3000, height: 3000, depth: 500)
        
    

    }
    
}

func getManager() -> GameManager? {
    return Manager
}

func setManager(a:GameManager) {
    Manager = a
}

func getLevelManager() -> LevelManager? {
    return levelManager
}

func setLevelManager(a:LevelManager) {
    levelManager = a
}
