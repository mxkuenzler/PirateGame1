//
//  Shield.swift
//  PirateGame
//
//  Created by Student on 5/23/24.
//

import Foundation
import RealityKit
import RealityKitContent
import _RealityKit_SwiftUI

class Shield:Object {
    
    init() async {
        
        var ent = try? await Entity(named:"shield", in:realityKitContentBundle)
        
        super.init(Entity: ent!, ID: .SHIELD)
                
        setupShield()
        
    }
    
    func setupShield() {
        
        getEntity()?.components.set(InputTargetComponent())
        getEntity()?.components.set(HoverEffectComponent())
        
    }
    
    
    
    
}
