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
    
    //MARK: IMPORTANT VARIABLES
    var onHomescreen = true
    var vec = Vector3D(x:0,y:0,z:0)
    var cards:[GameCard]?
    var progressTime = 0.0
    var coins = 10000
    var shells:Int = getShellsFromKeychain()
    var flagHealth = 0
    var isGameActive:Bool = false
    var gameCount:Int = 0
    var BottomHUDState:menuStates = .STANDARD
    var SideHUDState:infoStates = .STANDARD
    var speech:InteractiveSpeech? = nil
    
    //MARK: settings options
    var musicVolume:Double = 1
    var SFXVolume:Double = 1

    //MARK: MODIFIERS
    var activeCards:[GameCard] = Array()
    var availableCards:[GameCardID] = Array()
    
    //MARK: MULTIPLIERS
    var rewardMultiplier:Float = 0
    var cannonBallAmountFactor:Float = 0
    var cannonBallSizeFactor:Float = 0
    var cannonBallDamageFactor:Float = 0
    var priceFactor:Float = 0
    
    //MARK: ADDITIVES
    var difficulty:Float = 1
    
    //MARK: EFFECT
    var cannonballEffect:CannonballEffect = CannonballEffect()
    var blockEffect:BlockEffect = BlockEffect()
    
    //MARK: HISTORIC OBJECTS
    var historicObjects:[Object] = Array()
}

var keeper = Country()

@main
struct PirateGameApp: App {
    
    @State public var statekeeper = keeper
    
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
        ImmersiveSpace(id: "HotAirBalloon") {
            HotAirBalloon(keeper: statekeeper)
        }.immersionStyle(selection: .constant(.full), in: .full)
        ImmersiveSpace(id: "BlimpView") {
            BlimpView(keeper: statekeeper)
        }.immersionStyle(selection: .constant(.full), in: .full)
        //for testing purposes
        ImmersiveSpace(id: "TestSpace"){
            TestView(keeper: statekeeper)
        }.immersionStyle(selection: .constant(.full), in: .full)
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
