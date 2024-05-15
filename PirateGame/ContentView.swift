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
    @State private var coins = getManager()?.getCoins()
    
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
        
        
        HStack{
            
            VStack{
                Model3D(named: "basicBlock", bundle: realityKitContentBundle)
                    .scaleEffect(0.6)
                    .rotation3DEffect(Angle(degrees: 45), axis: (x: 1, y: 1, z: 1))
                
                Button("Cardboard") {
                    Task{
                        var block =  storage?.getCardboardBlock()
                        if getManager()!.getCoins() >= block!.getPrice() {
                            block = await storage?.takeCardboardBlock()
                            block!.setPosition(pos: SIMD3<Float>(0,1.5,0))
                            getManager()?.giveCoins(a: 0-block!.getPrice())
                            getManager()?.registerObject(object: block!)
                        }
                    }
                }.font(.custom("billy", size: 100))
                    .frame(depth: 350)
            }
            .padding(10)
            .glassBackgroundEffect(in: RoundedRectangle(
                cornerRadius: 10,
                style: .continuous
            ))
            .padding(10)
            
            VStack{
                Model3D(named: "woodBlock", bundle: realityKitContentBundle)
                    .scaleEffect(0.6)
                    .rotation3DEffect(Angle(degrees: 45), axis: (x: 1, y: 1, z: 1))
                
                Button("Wood") {
                    Task{
                        var block =  storage?.getWoodBlock()
                        if getManager()!.getCoins() >= block!.getPrice() {
                            block = await storage?.takeWoodBlock()
                            block!.setPosition(pos: SIMD3<Float>(0,1.5,0))
                            getManager()?.giveCoins(a: 0-block!.getPrice())
                            getManager()?.registerObject(object: block!)
                        }
                    }
                }.font(.custom("billy", size: 100))
                    .frame(depth: 350)
            }
            .padding(10)
            .glassBackgroundEffect(in: RoundedRectangle(
                cornerRadius: 10,
                style: .continuous
            ))
            .padding(10)
            
            VStack{
                Model3D(named: "stoneBlock", bundle: realityKitContentBundle)
                    .scaleEffect(0.6)
                    .rotation3DEffect(Angle(degrees: 45), axis: (x: 1, y: 1, z: 1))
                
                Button("Stone") {
                    Task{
                        var block =  storage?.getStoneBlock()
                        if getManager()!.getCoins() >= block!.getPrice() {
                            block = await storage?.takeStoneBlock()
                            block!.setPosition(pos: SIMD3<Float>(0,1.5,0))
                            getManager()?.giveCoins(a: 0-block!.getPrice())
                            getManager()?.registerObject(object: block!)
                        }
                    }
                }.font(.custom("billy", size: 100))
                    .frame(depth: 350)
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
