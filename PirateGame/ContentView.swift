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
        
        Button("Add Block") {
            let block = Block(Material: [SimpleMaterial(color:.red, isMetallic: false)], Health: 2)
            let buttonPos = 
            block.setPosition(pos:  )
            getManager()?.registerObject(object: block)
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
