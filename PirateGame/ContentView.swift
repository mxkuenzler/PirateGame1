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
    @State private var immersiveSpaceIsShown = false
    @State private var isLevelActive = false
    @State private var progressTime = 0.0
    @State private var gameMode:GameMode = .mode1
    @State private var temp:Bool = false
    @State private var selectedBlock:ID = ID.NIL
    // VECTORS:
    
    let leftVector:Vector3D = Vector3D(x:2000,y:0,z:0)
    let rightVector:Vector3D = Vector3D(x:-2000,y:0,z:0)
    let backwardVector:Vector3D = Vector3D(x:0,y:0,z:-2000)
    let forwardVector:Vector3D = Vector3D(x:0,y:0,z:2000)
    let centerVector:Vector3D = Vector3D(x:0,y:0,z:0)
    let dockVector:Vector3D = Vector3D(x:10000,y:0,z:0)

    
    enum GameMode: String, CaseIterable, Identifiable
    {
        case mode1, mode2
        var id: Self { self }
    }
    
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
        
        Picker("Game Mode", selection: $gameMode)
                        {
                            ForEach(GameMode.allCases)
                            {
                                gameMode in
                                Text(gameMode.rawValue)
                            }
                        }.pickerStyle(.segmented)
                            .frame(width: 500, height: 250)
                            .scaleEffect(x: 3, y: 3)
                            .opacity(1.0)
        Button("Change Mode") {
            if gameMode == .mode2 {
                gameMode = .mode1
                selectedBlock = .NIL
            } else {
                gameMode = .mode2
                selectedBlock = .CARDBOARD_BLOCK
            }
        }
        .task {
            func toggleTimer() async {
                while true {
                    getManager()?.setSelectedBlock(block:(selectedBlock))
                    sleep(1)
                }
            }
            
            await toggleTimer()
        }
        
        VStack {
            Text("\(temp)").opacity(0).task {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) { [self] in
                    Task.init {
                        
                        func toggleTimer() async {
                            while true {
                                temp = !temp
                                sleep(1)
                            }
                        }
                        
                        await toggleTimer()
                    }
                }
            }
            Text("Coins: \(String(describing: coins))").glassBackgroundEffect(in: RoundedRectangle(
            cornerRadius: 32,
            style: .continuous
        )).frame(width: 500,height: 250)
            .font(.custom("billy", size: 100))
            /*Button("Add Coins") {
                getManager()?.setCoins(a: getManager()!.getCoins() + 100)
            }*/
        }
        
        VStack {
            if !isLevelActive {
                Button("Start Next Level") {
                    Task.init {
                        isLevelActive = true
                        let level = getLevelManager()!.getLevel(num:getManager()!.getCurrentLevel()+1)
                        DispatchQueue.main.asyncAfter(deadline: .now() + Double(level.getDuration() + 3)) {
                            Task.init {
                                isLevelActive = false
                                await getManager()?.startIntermission()
                                coins += level.reward
                            }
                        }
                        await getManager()?.startNextLevel(level:level)
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
                        let diff = deltaT * 1 / Double(getLevelManager()!.getLevel(num:manager!.getCurrentLevel()).getDuration()+3)
                        if progressTime + diff < 1 {
                            progressTime += diff
                        }
                    }
                    
            }
            
        }
        
        
        HStack{
            
            
            VStack {
                
                Button("Left Button") {
                    
                    getManager()?.setTeleportVector(a: leftVector)
                    
                }.font(.custom("bill", size:6)).scaleEffect(1.5).padding().frame(depth:1).glassBackgroundEffect(in:Circle()).scaleEffect(3).padding(100).buttonBorderShape(.circle).scaledToFill()
                
                Button("Right Button") {
                    
                    getManager()?.setTeleportVector(a: rightVector)

                }.font(.custom("bill", size:6)).scaleEffect(1.5).padding().frame(depth:1).glassBackgroundEffect(in:Circle()).scaleEffect(3).padding(100).buttonBorderShape(.circle).scaledToFill()
                
                Button("Forward Button") {
                    
                    getManager()?.setTeleportVector(a: forwardVector)

                }.font(.custom("bill", size:6)).scaleEffect(1.5).padding().frame(depth:1).glassBackgroundEffect(in:Circle()).scaleEffect(3).padding(100).buttonBorderShape(.circle).scaledToFill()
                
                Button("Backward Button") {
                    
                    getManager()?.setTeleportVector(a: backwardVector)

                }.font(.custom("bill", size:6)).scaleEffect(1.5).padding().frame(depth:1).glassBackgroundEffect(in:Circle()).scaleEffect(3).padding(100).buttonBorderShape(.circle).scaledToFill()
                
                
            }
            
                
            
            
            VStack{
                Model3D(named: "basicBlock", bundle: realityKitContentBundle)
                    .scaleEffect(0.4)
                    .rotation3DEffect(Angle(degrees: 45), axis: (x: 1, y: 1, z: 1))
                    .frame(depth: 300)


                Button(gameMode == .mode1 ? "Cardboard" : "Select") {
                    Task{
                        if gameMode == .mode1 {
                            var block =  storage?.getCardboardBlock()
                            if coins >= block!.getPrice() {
                                block = await storage?.takeCardboardBlock()
                                block!.setPosition(pos: cardboardSpawn)
                                coins-=block!.getPrice()
                                getManager()?.registerObject(object: block!)
                            }
                        }
                        if gameMode == .mode2 {
                            selectedBlock = ID.CARDBOARD_BLOCK
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

                
                Button(gameMode == .mode1 ? "Wood" : "Select") {
                    Task{
                        if gameMode == .mode1 {
                            var block =  storage?.getWoodBlock()
                            if coins >= block!.getPrice() {
                                block = await storage?.takeWoodBlock()
                                block!.setPosition(pos: woodSpawn)
                                coins-=block!.getPrice()
                                getManager()?.registerObject(object: block!)
                            }
                        }
                        if gameMode == .mode2 {
                            selectedBlock = ID.WOOD_BLOCK
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

                Button(gameMode == .mode1 ? "Stone" : "Select") {
                    Task{
                        if gameMode == .mode1 {
                            var block =  storage?.getStoneBlock()
                            if coins >= block!.getPrice() {
                                block = await storage?.takeStoneBlock()
                                block!.setPosition(pos: stoneSpawn)
                                coins-=block!.getPrice()
                                getManager()?.registerObject(object: block!)
                            }
                        }
                        if gameMode == .mode2 {
                            selectedBlock = ID.STONE_BLOCK
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
            
            VStack {
                
                Button("Home Button") {
                    
                    print("Home")
                    
                }.font(.custom("bill", size:6)).scaleEffect(1.5).padding().frame(depth:1).glassBackgroundEffect(in:Circle()).scaleEffect(3).padding(100).buttonBorderShape(.circle).scaledToFill()
                
                Button("Settings Button") {
                    
                    print("Settings")
                    
                }.font(.custom("bill", size:6)).scaleEffect(1.5).padding().frame(depth:1).glassBackgroundEffect(in:Circle()).scaleEffect(3).padding(100).buttonBorderShape(.circle).scaledToFill()
                
                Button("Center Button") {
                    
                    getManager()?.setTeleportVector(a: centerVector)

                }.font(.custom("bill", size:6)).scaleEffect(1.5).padding().frame(depth:1).glassBackgroundEffect(in:Circle()).scaleEffect(3).padding(100).buttonBorderShape(.circle).scaledToFill()
                
                
                Button("Dock Button") {
                    
                    getManager()?.setTeleportVector(a: dockVector)

                }.font(.custom("bill", size:6)).scaleEffect(1.5).padding().frame(depth:1).glassBackgroundEffect(in:Circle()).scaleEffect(3).padding(100).buttonBorderShape(.circle).scaledToFill()
                    
            }
            
        }
        
        
        
    }
    
    

}


#Preview(windowStyle: .volumetric) {
    ContentView()
}

