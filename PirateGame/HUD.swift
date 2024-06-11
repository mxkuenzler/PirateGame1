//
//  HUD.swift
//  PirateGame
//
//  Created by Maxwell Kuenzler on 6/11/24.
//

import Foundation
import SwiftUI
import RealityKit
import RealityKitContent

struct BottomHUD: View {
    
    var keeper: Country
    @State var HUDState = menuStates.STANDARD
    
    var body: some View {
        VStack{
            switch HUDState {
            case .STANDARD:
                HStack{
                    Button("Teleports"){
                        HUDState = .TELEPORT
                    }
                    Button("Blocks"){
                        HUDState = .BLOCK
                    }
                    Button("⚙️"){
                        HUDState = .SETTINGS
                    }
                }
            case .TELEPORT:
                ZStack{
                    Button("Forward") {
                        forwardLocation.activateLocation(vec: &keeper.vec)
                    }.position(CGPoint(x: 200, y: 25))
                    
                    Button("Dock") {
                        dockLocation.activateLocation(vec: &keeper.vec)
                    }.position(CGPoint(x: 70, y: 25))
                    
                    Button("Left") {
                        leftLocation.activateLocation(vec: &keeper.vec)
                    }.position(CGPoint(x: 300, y: 75))
                    
                    Button("⛳") {
                        centerLocation.activateLocation(vec: &keeper.vec)
                    }.position(CGPoint(x: 200, y: 75))
                    
                    Button("Right") {
                        rightLocation.activateLocation(vec: &keeper.vec)
                    }.position(CGPoint(x: 100, y: 75))
                    
                    Button("🏠") {
                        homeLocation.activateLocation(vec: &keeper.vec)
                    }.position(CGPoint(x: 325, y: 25))
                    
                    Button("Backward") {
                        backwardLocation.activateLocation(vec: &keeper.vec)
                    }.position(CGPoint(x: 200, y: 125))
                    
                    Button("Close"){
                        HUDState = .STANDARD
                    }.position(CGPoint(x: 350, y: 125))
                }.frame(width: 400, height: 150)
            case .BLOCK:
                HStack{
                    ZStack{
                        RealityView{ cheese in
                            let block = await cardboardBlock()
                            manager?.partialRegisterObject(object: block)
                            block.initiateLighting(IBL: lighting!)
                            block.initiatePhysicsBody()
                            block.getEntity()?.components[CollisionComponent.self]?.isStatic = true
                            block.setOrientation(angle: -Float.pi/5, axes: [0, 1, 0])
                            
                            cheese.add(block.getEntity()!)
                        }.frame(depth: 50)
                            .gesture(HUDtap)
                        
                        Text("Price: 5")
                            .position(CGPoint(x: 350, y: -500))
                            .font(.custom("green", size: 200))
//                            .colorMultiply(Color(red: 1, green: 1, blue: 0))
                            .frame(width: 700, height: 200)
                            
                    }
                    .position(CGPoint(x: -1500, y: 0))
                    
                    ZStack{
                        RealityView{ cheese in
                            let block = await woodBlock()
                            manager?.partialRegisterObject(object: block)
                            block.initiateLighting(IBL: lighting!)
                            block.initiatePhysicsBody()
                            block.getEntity()?.components[CollisionComponent.self]?.isStatic = true
                            block.setOrientation(angle: Float.pi/4, axes: [0, 1, 0])
                            
                            cheese.add(block.getEntity()!)
                        }.frame(depth: 50)
                            .gesture(HUDtap)
                        
                        Text("Price: 10")
                            .position(CGPoint(x: 350, y: -500))
                            .font(.custom("green", size: 200))
//                            .colorMultiply(Color(red: 1, green: 1, blue: 0))
                            .frame(width: 800, height: 200)
                            
                    }
                    .position(CGPoint(x: 0, y: 0))
                    
                    ZStack{
                        RealityView{ cheese in
                            let block = await stoneBlock()
                            manager?.partialRegisterObject(object: block)
                            block.initiateLighting(IBL: lighting!)
                            block.initiatePhysicsBody()
                            block.getEntity()?.components[CollisionComponent.self]?.isStatic = true
                            block.setOrientation(angle: Float.pi/5, axes: [0, 1, 0])
                            
                            cheese.add(block.getEntity()!)
                        }.frame(depth: 50)
                            .gesture(HUDtap)
                        
                        Text("Price: 25")
                            .position(CGPoint(x: 350, y: -500))
                            .font(.custom("green", size: 200))
//                            .colorMultiply(Color(red: 1, green: 1, blue: 0))
                            .frame(width: 800, height: 200)
                            
                    }
                    .position(CGPoint(x: 1500, y: 0))
                    
                }
                .frame(width: 300, height: 100)
                .scaleEffect(0.05)
                
                Button("Close"){
                    HUDState = .STANDARD
                }
                
            case .SETTINGS:
                Text("Nothing here yet")
                Button("Close"){
                    HUDState = .STANDARD
                }
            }
        }
        
    }
    
    var HUDtap : some Gesture {
        TapGesture()
            .targetedToAnyEntity()
            .onEnded { value in
                let block = manager?.findObject(model: value.entity) as! Block
                
                switch block.blockID {
                    case .CARDBOARD_BLOCK:
                    Task{
                        var block =  storage?.getCardboardBlock()
                        if keeper.coins >= block!.getPrice() {
                            block = await storage?.takeCardboardBlock()
                            block!.setPosition(pos: cardboardSpawn)
                            keeper.coins-=block!.getPrice()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                                Task.init {
                                    getManager()?.registerObject(object: block!)
                                }
                            }
                        }
                    }
                        break
                    case .WOOD_BLOCK:
                    Task{
                        var block =  storage?.getWoodBlock()
                        if keeper.coins >= block!.getPrice() {
                            block = await storage?.takeWoodBlock()
                            block!.setPosition(pos: woodSpawn)
                            keeper.coins-=block!.getPrice()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                                Task.init {
                                    getManager()?.registerObject(object: block!)
                                }
                            }
                        }
                    }
                        break
                    case .STONE_BLOCK:
                    Task{
                        var block =  storage?.getStoneBlock()
                        if keeper.coins >= block!.getPrice() {
                            block = await storage?.takeStoneBlock()
                            block!.setPosition(pos: stoneSpawn)
                            keeper.coins-=block!.getPrice()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                                Task.init {
                                    getManager()?.registerObject(object: block!)
                                }
                            }
                        }
                    }
                        
                        break
                    default:
                        print("Nothing here")
                        
                    }
               
                
            }
    }
    
}

let deltaT = Double(0.01)

struct RightHud: View {
    
    @State private var isLevelActive = false
    var keeper: Country
    
    let timer = Timer.publish(every: deltaT, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack{
            Text("Coins: \(keeper.coins)")
            
            if !isLevelActive {
                Button("Start Next Level") {
                    Task.init {
                        isLevelActive = true
                        let level = getLevelManager()!.getLevel(num:getManager()!.getCurrentLevel())
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                            Task.init {
                                await getManager()?.startNextLevel(level:level)
                                await getManager()?.endIntermission(cards:&keeper.cards)
                            }
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + Double(level.getDuration() + 3)) {
                            Task.init {
                                isLevelActive = false
                                await getManager()?.startIntermission(cards:&keeper.cards)
                                keeper.coins += level.reward
                            }
                        }
                    }
                }
                
            } else {
                ProgressView(value: keeper.progressTime, total: 1).scaleEffect(x:1.02, y:3.2).frame(width:100, height:11)
                    .padding(10)
                    .onAppear {
                        keeper.progressTime = 0
                    }
                    .onReceive(timer) {_ in
                        let diff = deltaT * 1 / Double(getLevelManager()!.getLevel(num:manager!.getCurrentLevel()-1).getDuration()+3)
                        if keeper.progressTime + diff < 1 {
                            keeper.progressTime += diff
                        }
                    }
            }
            
        }
        
    }
}
