//
//  LevelIntermission.swift
//  PirateGame
//
//  Created by Student on 5/21/24.
//

import Foundation
import SwiftUI

// travelling merchant
//

enum intermissionID {
    case none, travelling_menu
}

class levelIntermission {
    
    var chance:Double
    var name:String
    var ID:intermissionID
    
    init(chance: Double, name:String, ID:intermissionID) {
        self.chance = chance
        self.name = name
        self.ID = ID
    }
    
    func prepareVStack(vs: inout AnyView) {
        //override in classes
    }
    
    func onStart() -> some View {
        var vs = AnyView(EmptyView())
        prepareVStack(vs:&vs)
        return vs
    }
    
    func onEnd() {
        //override in classes
    }
    
    
    
}

class Merchantintermission : levelIntermission {
    init() {
        super.init(chance:0.2, name:"Travelling Merchant", ID: intermissionID.travelling_menu)
    }
    
    
    override func prepareVStack(vs: inout AnyView) {
        vs = AnyView(VStack {
            Text("H")
            Button("He") {
                print("Hoa")
            }.font(.custom("bob", size: 100000))
        })
    }
    
}

