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


@Observable class Country{
    var onHomescreen = true
    var vec = Vector3D(x:0,y:0,z:0)
    var cards:[GameCard]? 
    var progressTime = 0.0
    var coins = 10000

}


@main
struct PirateGameApp: App {
    
    @State public var statekeeper = Country()
    
    var body: some Scene {
        
        
        ImmersiveSpace(id: "ImmersiveHomescreen") {
            Homescreen()
        }.immersionStyle(selection: .constant(.mixed), in: .mixed)
        
        ImmersiveSpace(id: "ImmersiveSpace") {
            ImmersiveView(keeper: statekeeper)
        }.immersionStyle(selection: .constant(.full), in: .full)
        WindowGroup {
            ContentView(keeper: statekeeper)
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
