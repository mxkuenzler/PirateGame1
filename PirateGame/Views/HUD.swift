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
enum menuStates {
    case STANDARD, TELEPORT, BLOCK, SETTINGS, CUSTOM
}
enum infoStates {
    case STANDARD, CUSTOM
}
struct BottomHUD: View {
    
    var keeper: Country
    @State var placementArr: [PlacerBlock] = []
    @Environment(\.openImmersiveSpace) var openImmersiveSpace
    @Environment(\.dismissImmersiveSpace) var dismissImmersiveSpace
    
    var body: some View {
        VStack{
            switch keeper.BottomHUDState {
            case .STANDARD:
                HStack{
                    Button("Teleports"){
                        keeper.BottomHUDState = .TELEPORT
                    }
                    Button("Blocks"){
                        keeper.BottomHUDState = .BLOCK
                    }
                    Button("⚙️"){
                        keeper.BottomHUDState = .SETTINGS
                    }
                }
            case .TELEPORT:
                ZStack{
                    Button("↓") {
                        forwardLocation.activateLocation(vec: &keeper.vec)
                    }.position(CGPoint(x: 200, y: 25))
                    
                    Button("Dock") {
                        dockLocation.activateLocation(vec: &keeper.vec)
                    }.position(CGPoint(x: 70, y: 25))
                    
                    Button("→") {
                        leftLocation.activateLocation(vec: &keeper.vec)
                    }.position(CGPoint(x: 100, y: 75))
                    
                    Button("⛳") {
                        centerLocation.activateLocation(vec: &keeper.vec)
                    }.position(CGPoint(x: 200, y: 75))
                    
                    Button("←") {
                        rightLocation.activateLocation(vec: &keeper.vec)
                    }.position(CGPoint(x: 300, y: 75))
                    
                    Button("🏠") {
                        homeLocation.activateLocation(vec: &keeper.vec)
                    }.position(CGPoint(x: 325, y: 25))
                    
                    Button("↑") {
                        backwardLocation.activateLocation(vec: &keeper.vec)
                    }.position(CGPoint(x: 200, y: 125))
                    
                    Button("Close"){
                        keeper.BottomHUDState = .STANDARD
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
                    keeper.BottomHUDState = .STANDARD
                }
                
            case .SETTINGS:
                Text("Nothing here yet")
                Button("Close"){
                    keeper.BottomHUDState = .STANDARD
                }
            case .CUSTOM:
                keeper.speech!.getInteractives()
            }
            if !keeper.isGameActive {
                
                Button("LEAVE") {
                    Task.init {
                        await dismissImmersiveSpace()
                        await openImmersiveSpace(id: "HotAirBalloon")
                    }
                }
                
                
            }
        }.task {
            if let model = try? await Entity(named: "basicBlockPlacer", in: realityKitContentBundle){
                model.generateCollisionShapes(recursive: true)
                let cardboard = cardboardBlockPlacer(model: model)
                cardboard.initiateLighting(IBL: lighting!)
                manager?.partialRegisterObject(object: cardboard)
                placementArr.append(cardboard)
            }
            if let model = try? await Entity(named: "woodBlockPlacer", in: realityKitContentBundle){
                model.generateCollisionShapes(recursive: true)
                let wood = woodBlockPlacer(model: model)
                wood.initiateLighting(IBL: lighting!)
                manager?.partialRegisterObject(object: wood)
                placementArr.append(wood)
            }
            if let model = try? await Entity(named: "stoneBlockPlacer", in: realityKitContentBundle){
                model.generateCollisionShapes(recursive: true)
                let stone = stoneBlockPlacer(model: model)
                stone.initiateLighting(IBL: lighting!)
                manager!.partialRegisterObject(object: stone)
                placementArr.append(stone)
            }
        }


        
    }
    
    var HUDtap : some Gesture {
        TapGesture()
            .targetedToAnyEntity()
            .onEnded { value in
                let block = manager?.findObject(model: value.entity) as! Block
                let tapToAdd = true
                
                switch block.blockID {
                    case .CARDBOARD_BLOCK:
                    Task{
                        if tapToAdd{
                            var block =  storage?.getCardboardBlock()
                            if keeper.coins >= block!.getPrice() {
                                block = await storage?.takeCardboardBlock()
                                block!.setPosition(pos: cardboardSpawn)
                                keeper.coins-=block!.getPrice()
                                gameTask() {
                                    getManager()?.registerObject(object: block!)
                                }
                            }
                        }
                        else {
                            for i in placementArr {
                                await i.getEntity()!.setPosition([0, 1, 0], relativeTo: nil)
                                rContent?.remove(i.getEntity()!)
                            }
                            rContent?.add(placementArr[0].getEntity()!)
                        }
                    }
                        break
                    case .WOOD_BLOCK:
                    Task{
                        if tapToAdd {
                            var block =  storage?.getWoodBlock()
                            if keeper.coins >= block!.getPrice() {
                                block = await storage?.takeWoodBlock()
                                block!.setPosition(pos: woodSpawn)
                                keeper.coins-=block!.getPrice()
                                gameTask() {
                                    getManager()?.registerObject(object: block!)
                                }
                            }
                        }
                        else {
                            for i in placementArr {
                                await i.getEntity()!.setPosition([0, 1, 0], relativeTo: nil)
                                rContent?.remove(i.getEntity()!)
                            }
                            rContent?.add(placementArr[1].getEntity()!)
                        }
                    }
                        break
                    case .STONE_BLOCK:
                    Task{
                        if tapToAdd {
                            var block =  storage?.getStoneBlock()
                            if keeper.coins >= block!.getPrice() {
                                block = await storage?.takeStoneBlock()
                                block!.setPosition(pos: stoneSpawn)
                                keeper.coins-=block!.getPrice()
                                gameTask() {
                                    getManager()?.registerObject(object: block!)
                                }
                            }
                        }
                        else {
                            for i in placementArr {
                                await i.getEntity()!.setPosition([0, 1, 0], relativeTo: nil)
                                rContent?.remove(i.getEntity()!)
                            }
                            rContent?.add(placementArr[2].getEntity()!)
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
        switch keeper.SideHUDState {
            case .STANDARD:
            VStack{
                Text("Coins: \(keeper.coins)")
                Text("⛳️ Health: \(keeper.flagHealth)")
                Text("Shells: \(keeper.shells)")
                Button("Add Shells!") {
                    addShells(amount:1)
                }
                if !isLevelActive {
                    Button("Start Next Level") {
                        Task.init {
                            isLevelActive = true
                            let level = getLevelManager()!.getLevel(num:getManager()!.getCurrentLevel())
                            gameTask() {
                                await getManager()?.startNextLevel(level:level)
                                await getManager()?.endIntermission()
                            }
                            gameTask(delay: Double(level.getDuration() + 3)) {
                                isLevelActive = false
                                await getManager()?.startIntermission(cards:&keeper.cards)
                                keeper.coins += level.reward
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
                
            }.padding(10)
            
            
            case .CUSTOM:
            VStack {
                keeper.speech!.getInformatives()
            }

        }
    }
}
