//
//  Block.swift
//  PirateGame
//
//  Created by Maxwell Kuenzler on 5/8/24.
//

import Foundation
import RealityKit
import RealityKitContent
import _RealityKit_SwiftUI

class Block: Object {
    
    var HP: Int
    
    var price: Int
    
    var blockID:ID
    
    init(Entity: Entity, Health: Int, cost: Int, blockID:ID){
        
        HP = Health
        
        price = cost
        
        self.blockID = blockID
        
        super.init(Entity: Entity, ID: ID.SIMPLE_BLOCK)
        
        self.getEntity()?.components.set(InputTargetComponent())
        
        self.getEntity()?.components.set(HoverEffectComponent())
    }
    
    func getPrice() -> Int{
        return price
    }
    
    func hit(obj: Object) {
        let ball = obj as! Cannonball
        HP -= ball.HP
        if HP <= 0 {
            manager?.unregisterObject(object: self)
        }
        print("Block Health: \(HP)")
    }
    
    func checkSnap(manager: GameManager){
        
        let objArr = manager.getObjects()
        
        let closest = getClosestBlock(objArr:objArr)
        let posA = getEntity()!.position
        let posB = closest?.getEntity()!.position
        let d = distanceBetween(a:posA, b:posB!)
        let distance = Float(d)
        
        if distance < blockSize {
            connectBlocks(a:self, b:closest!)
        }
        
    }
    
    func getClosestBlock(objArr: Array<Object>) -> Object? {
        
        if objArr.count < 2 {
            return nil
        }
        let pos = getEntity()?.position
        let count = 0...objArr.count-1
        var minDistance:Float = MAXFLOAT
        var index = 0
        
        for i in count {
            
            if distanceBetween(a: pos!, b: objArr[i].getEntity()!.position) < minDistance {
                if self == objArr[i] {
                    
                }
                else {
                    if isABlock(obj:objArr[i]) {
                        minDistance = distanceBetween(a: pos!, b: objArr[i].getEntity()!.position)
                        index = i
                    }
                }
            }
            
        }
        
        return objArr[index]
    }
    
    override func handleCollision(event: CollisionEvents.Began) {
        if manager?.findObject(model:event.entityB)?.getID() == ID.SIMPLE_BLOCK {
            if self.getEntity()?.components[PhysicsBodyComponent.self]?.mode != .static {
                checkSnap(manager: manager!)
            }
        }
        if manager?.findObject(model: event.entityB)?.getID() == ID.ISLAND_FLOOR {
            getEntity()?.components[PhysicsBodyComponent.self]?.mode = .static
        }
        if manager?.findObject(model: event.entityB)?.getID() == ID.SECOND_OCEAN_FLOOR {
            getManager()?.unregisterObject(object: self)
        }
    }
    
    func getBlockID() -> ID {
        return blockID
    }
}

class PlacerBlock: Object {
    var blockID:ID
    override init(Entity: Entity, ID: ID) {
        blockID = ID
        super.init(Entity: Entity, ID: .PLACER_BLOCK)
        self.getEntity()?.components.set(InputTargetComponent())
        self.getEntity()?.components.set(HoverEffectComponent())
    }
}

class blockStorage {
    
    var CB: cardboardBlock
    var WB: woodBlock
    var SB: stoneBlock
    
    init() async {
        CB = await cardboardBlock()
        WB = await woodBlock()
        SB = await stoneBlock()
    }
    
    func getCardboardBlock() -> cardboardBlock{
        return CB
    }
    
    func takeCardboardBlock() async -> cardboardBlock {
        let holdBlock = CB
        CB = await cardboardBlock()
        return holdBlock
    }
    
    func getWoodBlock() -> woodBlock {
        return WB
    }
    
    func takeWoodBlock() async -> woodBlock {
        let holdBlock = WB
        WB = await woodBlock()
        return holdBlock
    }
    
    func getStoneBlock() -> stoneBlock {
        return SB
    }
    
    func takeStoneBlock() async -> stoneBlock {
        let holdBlock = SB
        SB = await stoneBlock()
        return holdBlock
    }
}

var storage: blockStorage?
