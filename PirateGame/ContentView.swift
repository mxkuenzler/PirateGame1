//
//  ContentView.swift
//  PirateGame
//
//  Created by Maxwell Kuenzler on 5/8/24.
//

import SwiftUI
import RealityKit
import RealityKitContent

class blockStorage {
    
    var CB: cardboardBlock
    var WB: woodBlock
    var SB: stoneBlock
    
    init() async {
        CB = await cardboardBlock()
        WB = await woodBlock()
        SB = await stoneBlock()
    }
    
    func getCardboardBlock() -> cardboardBlock{
        return CB
    }
    
    func takeCardboardBlock() async -> cardboardBlock {
        let holdBlock = CB
        CB = await cardboardBlock()
        return holdBlock
    }
    
    func getWoodBlock() -> woodBlock {
        return WB
    }
    
    func takeWoodBlock() async -> woodBlock {
        let holdBlock = WB
        WB = await woodBlock()
        return holdBlock
    }
    
    func getStoneBlock() -> stoneBlock {
        return SB
    }
    
    func takeStoneBlock() async -> stoneBlock {
        let holdBlock = SB
        SB = await stoneBlock()
        return holdBlock
    }
}

var storage: blockStorage?

let deltaT = Double(0.01)

struct ContentView: View {
    
    @State private var enlarge = false
    @State private var showImmersiveSpace = false
    @State private var isLevelActive = false
    @State private var progressTime = 0.0
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
            await openImmersiveSpace(id: "ImmersiveHomescreen")
            
        }
        // in the VStack under the start level button
        
        
        VStack {
            Text("\(temp)").opacity(0).task {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) { [self] in
                    Task.init {
                        
                        /* func toggleTimer() async {
                         while true {
                         temp = !temp
                         sleep(1)
                         }
                         }
                         
                         await toggleTimer()*/
                    }
                }
            }
            /*Button("Add Coins") {
             getManager()?.setCoins(a: getManager()!.getCoins() + 100)
             }*/
        }
        // in the VStack under the start level button
        
        if !(keeper.onHomescreen) {
            //ingame menu
            
            VStack {
                Text("Coins: \(String(describing: coins))").glassBackgroundEffect(in: RoundedRectangle(
                    cornerRadius: 32,
                    style: .continuous
                )).frame(width: 500,height: 250)
                    .font(.custom("billy", size: 100))
                
                if !isLevelActive {
                    Button("Start Next Level") {
                        Task.init {
                            isLevelActive = true
                            let level = getLevelManager()!.getLevel(num:getManager()!.getCurrentLevel())
                            await getManager()?.startNextLevel(level:level)
                            DispatchQueue.main.asyncAfter(deadline: .now() + Double(level.getDuration() + 3)) {
                                Task.init {
                                    isLevelActive = false
                                    await getManager()?.startIntermission()
                                    coins += level.reward
                                }
                            }
                        }
                    }.frame(width: 500,height: 250)
                        .font(.custom("billy", size: 100))
                    
                } else {
                    ProgressView(value: progressTime, total: 1).scaleEffect(x:1.02, y:32).frame(width:1000, height:110).padding(10)
                        .glassBackgroundEffect(in: RoundedRectangle(
                            cornerRadius: 1000000,
                            style: .continuous
                        ))
                        .padding(10)
                        .onAppear {
                            progressTime = 0
                        }
                        .onReceive(timer) {_ in
                            let diff = deltaT * 1 / Double(getLevelManager()!.getLevel(num:manager!.getCurrentLevel()-1).getDuration()+3)
                            if progressTime + diff < 1 {
                                progressTime += diff
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
                                if coins >= block!.getPrice() {
                                    block = await storage?.takeCardboardBlock()
                                    block!.setPosition(pos: cardboardSpawn)
                                    coins-=block!.getPrice()
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
                                if coins >= block!.getPrice() {
                                    block = await storage?.takeWoodBlock()
                                    block!.setPosition(pos: woodSpawn)
                                    coins-=block!.getPrice()
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
                                if coins >= block!.getPrice() {
                                    block = await storage?.takeStoneBlock()
                                    block!.setPosition(pos: stoneSpawn)
                                    coins-=block!.getPrice()
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

