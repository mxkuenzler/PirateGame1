//
//  BlockTypes.swift
//  PirateGame
//
//  Created by Maxwell Kuenzler on 5/13/24.
//

import Foundation
import RealityKit
import RealityKitContent
import _RealityKit_SwiftUI

class cardboardBlock: Block {
    
    init() async {
        let blockModel = try? await Entity(named: "basicBlock", in: realityKitContentBundle)
        super.init(Entity: blockModel!, Health: 1, cost: 5, blockID: ID.CARDBOARD_BLOCK)
    }
    
    override func goToSpawn() {
        getEntity()?.position = cardboardSpawn
    }
}

class woodBlock: Block {
    init() async {
        let blockModel = try? await Entity(named: "woodBlock", in: realityKitContentBundle)
            
        super.init(Entity: blockModel!, Health: 2, cost: 10, blockID: ID.WOOD_BLOCK)
    }
    override func goToSpawn() {
        getEntity()?.position = woodSpawn
    }
}

class stoneBlock: Block {
    init() async {
        let blockModel = try? await Entity(named: "stoneBlock", in: realityKitContentBundle)
            
        super.init(Entity: blockModel!, Health: 5, cost: 25, blockID: ID.STONE_BLOCK)
    }
    override func goToSpawn() {
        getEntity()?.position = stoneSpawn
    }
}

class sandBlock: Block {
    init() async {
        let blockModel = try? await Entity(named: "sandBlock", in: realityKitContentBundle)
            
        super.init(Entity: blockModel!, Health: 2, cost: 0, blockID: ID.SAND_BLOCK)
        
        await self.getEntity()?.components.remove(InputTargetComponent.self)
    }
    
    override func hit(obj: Object) {
        return
    }
}

class refinedWoodBlock: Block {
    init() async {
        let blockModel = try? await Entity(named: "refinedWoodBlock", in: realityKitContentBundle)
            
        super.init(Entity: blockModel!, Health: 10, cost: 50, blockID: ID.REFINED_WOOD_BLOCK)
        }
    
    override func goToSpawn() {
        getEntity()?.position = woodSpawn
    }
}
