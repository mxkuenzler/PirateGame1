//
//  PirateShip.swift
//  PirateGame
//
//  Created by Student on 5/14/24.
//


import Foundation
import RealityKit
import RealityKitContent
import _RealityKit_SwiftUI

class PirateShip: Object {
    
    
    init() async{
        let PirateShipModel = try? await Entity(named: "PirateShip", in: realityKitContentBundle)
        
        super.init(Entity: PirateShipModel!, ID: ID.PIRATE_SHIP)
        
        
    }
}
    
    
    
    
    
