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
    
    init(Material: [any Material], Health: Int){
        
        HP = Health
        
        let BlockModel = ModelEntity(mesh: .generateBox(size: 0.25), materials: Material)
        
        super.init(Entity: BlockModel, ID: ID.SIMPLE_BLOCK)
        
        self.getEntity()?.components.set(InputTargetComponent())
    }
    
    func hit(obj: Object) {
        HP = HP - 1
        if HP <= 0 {
            manager?.unregisterObject(object: self)
        }
    }
    
    func checkSnap(manager: GameManager) {
        
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
            checkSnap(manager: manager!)
        }
        if manager?.findObject(model: event.entityB)?.getID() == ID.ISLAND_FLOOR {
            getEntity()?.components[PhysicsBodyComponent.self]?.mode = .static
        }
    }
}

