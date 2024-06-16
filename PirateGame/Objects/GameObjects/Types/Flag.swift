//
//  Flag.swift
//  PirateGame
//
//  Created by Maxwell Kuenzler on 5/10/24.
//

import Foundation
import RealityKit
import RealityKitContent
import _RealityKit_SwiftUI

class Flag: Object {
    
    
    
    var HP = 50
    
    init() async{
        let FlagModel = try? await Entity(named: "Flag", in: realityKitContentBundle)
                
        super.init(Entity: FlagModel!, ID: ID.FLAG)
        
        self.setPosition(pos: SIMD3<Float>(0, 1, 0))
        
        getManager()?.keeper.flagHealth = HP
    }
    
    func hit(obj: Object) {
        let ball = obj as! Cannonball
        HP -= ball.HP
        if HP <= 0 {
            manager?.unregisterObject(object: self)
            print("You Lost")
            manager?.keeper.isGameActive = false
            manager?.keeper.gameCount += 1

        }
        getManager()?.keeper.flagHealth = HP
    }
    
    
    
}
