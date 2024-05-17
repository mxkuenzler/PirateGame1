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

let deltaT = 0.01

struct ContentView: View {

    @State private var enlarge = false
    @State private var showImmersiveSpace = false
    @State private var immersiveSpaceIsShown = false
    @State private var coins:Int = 10000
    @State private var isLevelActive = false
    @State private var progressTime = 0.0
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
        
        VStack {
            
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
                        let level = getLevelManager()!.getLevel(num:getManager()!.getCurrentLevel())
                        await getManager()?.startNextLevel(level:level)
                        DispatchQueue.main.asyncAfter(deadline: .now() + Double(level.getDuration() + 3)) {
                            isLevelActive = false
                            coins += level.reward
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
                        let diff = deltaT * 1 / Double(getLevelManager()!.getLevel(num:manager!.getCurrentLevel()).getDuration()+3)
                        if progressTime + diff < 1 {
                            progressTime += diff
                        }
                    }
            }
            
        }
        
        
        HStack{
            
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
        }
    }
}

#Preview(windowStyle: .volumetric) {
    ContentView()
}
