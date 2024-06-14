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
    
    func onStart(cards:inout [GameCard]?) async {
        //override in classes
    }
    
    func onEnd(cards:inout [GameCard]?) async {
        //override in classes
    }
    
    
    
}

class Merchantintermission : levelIntermission {
    
    var marketShip:MarketShip?
    
    init() {
        super.init(chance:0.2, name:"Travelling Merchant", ID: intermissionID.travelling_menu)
    }
    
    override func onStart(cards:inout [GameCard]?) async {
        
        marketShip = await MarketShip()
        gameTask(delay:0.01){
            getManager()?.registerObject(object: self.marketShip!)
            self.marketShip!.setPosition(pos: SIMD3<Float>(x:-10,y:0.2,z:0))
        }
        getManager()?.pickCards(cards: &cards)
    }
    
    override func onEnd(cards:inout [GameCard]?) async {
        if let _ = marketShip {
            getManager()?.unregisterObject(object: marketShip!)}
    }
    
}

