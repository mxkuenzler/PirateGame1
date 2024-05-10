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
        
        super.init(Model: BlockModel, ID: ID.SIMPLE_BLOCK)
        
        self.getModel()?.components.set(InputTargetComponent())
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
        print("found closest)")
        print(getModel()!.position)
        print(closest?.getModel()!.position)
        let posA = getModel()!.position
        let posB = closest?.getModel()!.position
        let d = distanceBetween(a:posA, b:posB!)
        print(d)
        let distance = Float(d)
        
        if distance < blockSize {
            print("close enough")
            connectBlocks(a:self, b:closest!)
        }
        
    }
    
    func getClosestBlock(objArr: Array<Object>) -> Object? {
        
        if objArr.count < 2 {
            return nil
        }
        let pos = getModel()?.position
        let count = 0...objArr.count-1
        var minDistance:Float = MAXFLOAT
        var index = 0
        
        for i in count {
            
            if distanceBetween(a: pos!, b: objArr[i].getModel()!.position) < minDistance {
                if self == objArr[i] {
                    
                }
                else {
                    if isABlock(obj:objArr[i]) {
                        minDistance = distanceBetween(a: pos!, b: objArr[i].getModel()!.position)
                        index = i
                    }
                }
            }
            
        }
        
        return objArr[index]
    }
}

