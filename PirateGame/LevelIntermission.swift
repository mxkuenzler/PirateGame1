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
    var intID:intermissionID
    
    init(chance: Double, name:String, ID:intermissionID) {
        self.chance = chance
        self.name = name
        self.intID = ID
    }
    
    func onStart() async {
        //override in classes
    }
    
    func onEnd() async {
        //override in classes
    }
    
    
    
}

class Merchantintermission : levelIntermission {
    init() {
        super.init(chance:0.2, name:"Travelling Merchant", ID: intermissionID.travelling_menu)
    }
    
    override func onStart() async {
        print("Starting")
        for i in -1...1 {
            let shop:Shop = await Shop(soldObjectID: (i == -1 ? ID.CARDBOARD_BLOCK : (i == 0 ? ID.WOOD_BLOCK: ID.STONE_BLOCK)), price: i+1, color: i == -1 ? .blue : (i == 0 ? .brown : .darkGray))
            print("let")
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                Task.init {
                    manager?.registerObject(object:shop)
                    print("reg")
                    shop.setPosition(pos: SIMD3<Float>(-10,2.5,Float(i*3)))
                    shop.setOrientation(angle: Float.pi + Float(i)*Float.pi/6 + 3*Float.pi/2, axes: SIMD3<Float>(0,0,1))
                }
            }
        }
        
    }
    
}

