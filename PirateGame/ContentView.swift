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


struct ContentView: View {

    @State private var enlarge = false
    @State private var showImmersiveSpace = false
    @State private var immersiveSpaceIsShown = false
    @State private var coins:Int = 10000
    @State private var isLevelActive = false
    
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
            
        Text("Coins: \(String(describing: coins))").font(.largeTitle).foregroundStyle(.white).bold().accentColor(.red)
            /*Button("Add Coins") {
                getManager()?.setCoins(a: getManager()!.getCoins() + 100)
            }*/
        }.glassBackgroundEffect(in: RoundedRectangle(
            cornerRadius: 32,
            style: .continuous
        )).frame(width: 500,height: 250)
        
        Button("Cannonball"){
            Task{
                let c = await Cannonball()
                c.setPosition(pos: SIMD3(0, 3, 0))
                getManager()?.registerObject(object: c)
            }
        }
        
        VStack {
            if !isLevelActive {
                 Button("Start Next Level") {
                    Task.init {
                        isLevelActive = true
                        var level = getLevelManager()!.getLevel(num:getManager()!.getCurrentLevel())
                        await getManager()?.startNextLevel(level:level)
                        DispatchQueue.main.asyncAfter(deadline: .now() + Double(level.getDuration() + 3)) {
                            isLevelActive = false
                            coins += level.reward
                        }
                    }
                }.glassBackgroundEffect(in: RoundedRectangle(
                    cornerRadius: 32,
                    style: .continuous
                )).frame(width: 500,height: 250)
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
