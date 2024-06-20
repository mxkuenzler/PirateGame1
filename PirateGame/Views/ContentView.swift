//
//  ContentView.swift
//  PirateGame
//
//  Created by Maxwell Kuenzler on 5/8/24.
//

import SwiftUI
import RealityKit
import RealityKitContent




struct ContentView: View {
    
    @State private var enlarge = false
    @State private var showImmersiveSpace = false
    @State private var isLevelActive = false
    @State private var temp:Bool = false
    @State private var selectedBlock:ID = ID.NIL
    var keeper: Country
    // VECTORS:
    
    @State private var totalProgressTime = 0
    let timer = Timer.publish(every: deltaT, on: .main, in: .common).autoconnect()
    @Environment(\.openImmersiveSpace) var openImmersiveSpace
    @Environment(\.dismissImmersiveSpace) var dismissImmersiveSpace
    var body: some View {
                
        
        RealityView { content in
            

        }
        .task {
            storage = await blockStorage()
            await openImmersiveSpace(id: "ImmersiveSpace")
            
        }
        // in the VStack under the start level button
        
        
        // in the VStack under the start level button
        
        if (keeper.onHomescreen) {
            //ingame menu
            
            VStack {
                Text("Coins: \(keeper.coins)").glassBackgroundEffect(in: RoundedRectangle(
                    cornerRadius: 32,
                    style: .continuous
                )).frame(width: 500,height: 250)
                    .font(.custom("billy", size: 100))
                
                if !isLevelActive {
                    Button("Start Next Level") {
                        Task.init {
                            isLevelActive = true
                            let level = getLevelManager()!.getLevel(num:getManager()!.getCurrentLevel())
                            gameTask() {
                                await getManager()?.startNextLevel(level:level)
                                await getManager()?.endIntermission()
                            }
                            gameTask(delay:Double(level.getDuration() + 3)) {
                                isLevelActive = false
                                await getManager()?.startIntermission(cards:&keeper.cards)
                                keeper.coins += level.reward
                            }
                        }
                    }.frame(width: 500,height: 250)
                        .font(.custom("billy", size: 100))
                    
                } else {
                    ProgressView(value: keeper.progressTime, total: 1).scaleEffect(x:1.02, y:32).frame(width:1000, height:110).padding(10)
                        .glassBackgroundEffect(in: RoundedRectangle(
                            cornerRadius: 1000000,
                            style: .continuous
                        ))
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
                
                
                HStack{
                    VStack {
                        Button("Right Button") {
                            
                            rightLocation.activateLocation(vec: &keeper.vec)
                    
                        }.font(.custom("bill", size:6)).scaleEffect(1.5).padding().frame(depth:1).glassBackgroundEffect(in:Circle()).scaleEffect(3).padding(100).buttonBorderShape(.circle).scaledToFill()
                        
                        Button("Left Button") {
                            
                            leftLocation.activateLocation(vec: &keeper.vec)

                        }.font(.custom("bill", size:6)).scaleEffect(1.5).padding().frame(depth:1).glassBackgroundEffect(in:Circle()).scaleEffect(3).padding(100).buttonBorderShape(.circle).scaledToFill()
                        
                        
                        Button("Forward Button") {
                            
                            forwardLocation.activateLocation(vec: &keeper.vec)
                            
                        }.font(.custom("bill", size:6)).scaleEffect(1.5).padding().frame(depth:1).glassBackgroundEffect(in:Circle()).scaleEffect(3).padding(100).buttonBorderShape(.circle).scaledToFill()
                        
                        Button("Backward Button") {
                            
                            backwardLocation.activateLocation(vec: &keeper.vec)

                        }.font(.custom("bill", size:6)).scaleEffect(1.5).padding().frame(depth:1).glassBackgroundEffect(in:Circle()).scaleEffect(3).padding(100).buttonBorderShape(.circle).scaledToFill()
                        
                        
                    }
                    
                    
                    
                    
                    VStack{
                        Model3D(named: "basicBlock", bundle: realityKitContentBundle)
                            .scaleEffect(0.4)
                            .rotation3DEffect(Angle(degrees: 45), axis: (x: 1, y: 1, z: 1))
                            .frame(depth: 300)
                        
                        
                        Button("Cardboard") {
                            Task{
                                var block =  storage?.getCardboardBlock()
                                if keeper.coins >= block!.getPrice() {
                                    block = await storage?.takeCardboardBlock()
                                    block!.setPosition(pos: cardboardSpawn)
                                    keeper.coins-=block!.getPrice()
                                    getManager()?.registerObject(object: block!)
                                }
                                
                            }
                        }.font(.custom("billy", size: 100)).scaledToFill()
                            .frame(depth: 300)
                    }
                    .padding(10)
                    .glassBackgroundEffect(in: RoundedRectangle(
                        cornerRadius: 10,
                        style: .continuous
                    ))
                    .padding(10)
                    
                    VStack{
                        Model3D(named: "woodBlock", bundle: realityKitContentBundle)
                            .scaleEffect(0.4)
                            .rotation3DEffect(Angle(degrees: 45), axis: (x: 1, y: 1, z: 1))
                            .frame(depth: 300)
                        
                        
                        Button("Wood") {
                            Task{
                                var block =  storage?.getWoodBlock()
                                if keeper.coins >= block!.getPrice() {
                                    block = await storage?.takeWoodBlock()
                                    block!.setPosition(pos: woodSpawn)
                                    keeper.coins-=block!.getPrice()
                                    getManager()?.registerObject(object: block!)
                                    
                                }
                            }
                        }.font(.custom("billy", size: 100)).scaledToFill()
                            .frame(depth: 300)
                    }
                    .padding(10)
                    .glassBackgroundEffect(in: RoundedRectangle(
                        cornerRadius: 10,
                        style: .continuous
                    ))
                    .padding(10)
                    
                    VStack{
                        Model3D(named: "stoneBlock", bundle: realityKitContentBundle)
                            .scaleEffect(0.4)
                            .rotation3DEffect(Angle(degrees: 45), axis: (x: 1, y: 1, z: 1))
                            .frame(depth: 300)
                        
                        
                        Button("Stone") {
                            Task{
                                var block =  storage?.getStoneBlock()
                                if keeper.coins >= block!.getPrice() {
                                    block = await storage?.takeStoneBlock()
                                    block!.setPosition(pos: stoneSpawn)
                                    keeper.coins-=block!.getPrice()
                                    getManager()?.registerObject(object: block!)
                                    
                                }
                            }
                        }.font(.custom("billy", size: 100)).scaledToFill()
                            .frame(depth: 300)
                    }
                    .padding(10)
                    .glassBackgroundEffect(in: RoundedRectangle(
                        cornerRadius: 10,
                        style: .continuous
                    ))
                    .padding(10)
                    
                    //tp buttons
                    VStack {
                        
                        Button("Settings Button") {
                            
                            print("Settings")
                            
                        }.font(.custom("bill", size:6)).scaleEffect(1.5).padding().frame(depth:1).glassBackgroundEffect(in:Circle()).scaleEffect(3).padding(100).buttonBorderShape(.circle).scaledToFill()
                        
                        Button("Home Button") {
                            
                            homeLocation.activateLocation(vec: &keeper.vec)

                        }.font(.custom("bill", size:6)).scaleEffect(1.5).padding().frame(depth:1).glassBackgroundEffect(in:Circle()).scaleEffect(3).padding(100).buttonBorderShape(.circle).scaledToFill()
                        
                        Button("Center Button") {
                            
                            centerLocation.activateLocation(vec: &keeper.vec)

                        }.font(.custom("bill", size:6)).scaleEffect(1.5).padding().frame(depth:1).glassBackgroundEffect(in:Circle()).scaleEffect(3).padding(100).buttonBorderShape(.circle).scaledToFill()
                        
                        
                        Button("Dock Button") {
                            
                            dockLocation.activateLocation(vec: &keeper.vec)

                        }.font(.custom("bill", size:6)).scaleEffect(1.5).padding().frame(depth:1).glassBackgroundEffect(in:Circle()).scaleEffect(3).padding(100).buttonBorderShape(.circle).scaledToFill()
                    }
                    
                }
                
                Button("Add Cannonball"){
                    gameTask() {
                        var ball = await BasicCannonball()
                        ball.getEntity()?.components.set(InputTargetComponent())
                        ball.getEntity()?.components.set(HoverEffectComponent())
                        ball.setPosition(pos: [0, 4, 0])
                        getManager()?.registerObject(object: ball)
                    }
                    gameTask() {
                        var ball = await HeavyCannonball()
                        ball.getEntity()?.components.set(InputTargetComponent())
                        ball.getEntity()?.components.set(HoverEffectComponent())
                        ball.setPosition(pos: [1, 4, 0])
                        getManager()?.registerObject(object: ball)
                    }
                }.font(.custom("billy", size: 100))
                /*HStack{
                 
                 //adding blocks
                 
                 VStack{
                 Model3D(named: "basicBlock", bundle: realityKitContentBundle)
                 .scaleEffect(0.4)
                 .rotation3DEffect(Angle(degrees: 45), axis: (x: 1, y: 1, z: 1))
                 .frame(depth: 300)
                 
                 
                 Button("Cardboard") {
                 Task{
                 var block =  storage?.getCardboardBlock()
                 if coins >= block!.getPrice() {
                 block = await storage?.takeCardboardBlock()
                 block!.setPosition(pos: cardboardSpawn)
                 coins-=block!.getPrice()
                 getManager()?.registerObject(object: block!)
                 }
                 }
                 }.font(.custom("billy", size: 100))
                 .frame(depth: 300)
                 }
                 .padding(10)
                 .glassBackgroundEffect(in: RoundedRectangle(
                 cornerRadius: 10,
                 style: .continuous
                 ))
                 .padding(10)
                 
                 VStack{
                 Model3D(named: "woodBlock", bundle: realityKitContentBundle)
                 .scaleEffect(0.4)
                 .rotation3DEffect(Angle(degrees: 45), axis: (x: 1, y: 1, z: 1))
                 .frame(depth: 300)
                 
                 
                 Button("Wood") {
                 Task{
                 var block =  storage?.getWoodBlock()
                 if coins >= block!.getPrice() {
                 block = await storage?.takeWoodBlock()
                 block!.setPosition(pos: woodSpawn)
                 coins-=block!.getPrice()
                 getManager()?.registerObject(object: block!)
                 }
                 }
                 }.font(.custom("billy", size: 100))
                 .frame(depth: 300)
                 }
                 .padding(10)
                 .glassBackgroundEffect(in: RoundedRectangle(
                 cornerRadius: 10,
                 style: .continuous
                 ))
                 .padding(10)
                 
                 VStack{
                 Model3D(named: "stoneBlock", bundle: realityKitContentBundle)
                 .scaleEffect(0.4)
                 .rotation3DEffect(Angle(degrees: 45), axis: (x: 1, y: 1, z: 1))
                 .frame(depth: 300)
                 
                 Button("Stone") {
                 Task{
                 var block =  storage?.getStoneBlock()
                 if coins >= block!.getPrice() {
                 block = await storage?.takeStoneBlock()
                 block!.setPosition(pos: stoneSpawn)
                 coins-=block!.getPrice()
                 getManager()?.registerObject(object: block!)
                 }
                 }
                 }.font(.custom("billy", size: 100))
                 .frame(depth: 300)
                 }
                 
                 .padding(10)
                 .glassBackgroundEffect(in: RoundedRectangle(
                 cornerRadius: 10,
                 style: .continuous
                 ))
                 .padding(10)
                 
                 
                 }*/
         
         }
            
            
        }
    }
    
}
    /*
     #Preview(windowStyle: .volumetric) {
     ContentView(keeper: Country())
     }
     
     */

