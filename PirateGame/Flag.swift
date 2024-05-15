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
    
    var HP = 200
    
    init() async{
        let FlagModel = try? await Entity(named: "Flag", in: realityKitContentBundle)
                
        super.init(Entity: FlagModel!, ID: ID.FLAG)
        
        self.setPosition(pos: SIMD3<Float>(0, 1, 0))
    }
    
    func hit(obj: Object) {
        HP = HP - 1
        if HP <= 0 {
            manager?.unregisterObject(object: self)
        }
    }
    
    
    
}
