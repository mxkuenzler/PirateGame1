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
    @State private var immersiveSpaceIsShown = false
    
    
    @Environment(\.openImmersiveSpace) var openImmersiveSpace
    @Environment(\.dismissImmersiveSpace) var dismissImmersiveSpace

    var body: some View {
        
        VStack {
            
            Text("Coins: \(getManager()?.getCoins())").font(.largeTitle).foregroundStyle(.white).scaledToFit().bold().accentColor(.red)
            Button("Add Coins") {
                getManager()?.setCoins(a: getManager()!.getCoins() + 100)
            }
        }.glassBackgroundEffect(in: RoundedRectangle(
            cornerRadius: 32,
            style: .continuous
        )).frame(width: 100,height: 100)
        
        Button("Add Block") {
            if getManager()!.getCoins() >= 100 {
                let block = Block(Material: [SimpleMaterial(color:.red, isMetallic: false)], Health: 2)
                block.setPosition(pos: SIMD3<Float>(0,1.5,0))
                getManager()?.setCoins(a: getManager()!.getCoins()-100)
                getManager()?.registerObject(object: block)
            }
        }.font(.custom("billy", size: 400))
        
        RealityView { content in
            
        }
        
        .task {
            await openImmersiveSpace(id: "ImmersiveSpace")
        }
    }
}

#Preview(windowStyle: .volumetric) {
    ContentView()
}
