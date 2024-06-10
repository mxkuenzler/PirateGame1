//
//  marketShip.swift
//  PirateGame
//
//  Created by Student on 6/8/24.
//

import Foundation
import RealityKit
import RealityKitContent
import _RealityKit_SwiftUI

class MarketShip: Object {
    
    init() async{
        let MarketShipModel = try? await Entity(named: "MarketShip", in: realityKitContentBundle)
        super.init(Entity: MarketShipModel!, ID: ID.MARKET_SHIP)
    }
    
    override func onRegister() {
        
    }
    
}
