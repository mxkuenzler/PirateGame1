//
//  Cannonball.swift
//  PirateGame
//
//  Created by Maxwell Kuenzler on 5/8/24.
//

import Foundation
import RealityKit
import RealityKitContent
import _RealityKit_SwiftUI

class Cannonball: Object {
    
    init(){
        
        let CannonballModel = ModelEntity(mesh: .generateSphere(radius: 0.25), materials: [SimpleMaterial(color: .black, roughness: 0.8, isMetallic: false)])
        
        super.init(Model: CannonballModel, ID: ID.CANNON_BALL)
        
    }
}
