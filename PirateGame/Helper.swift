//
//  Helper.swift
//  PirateGame
//
//  Created by Student on 5/9/24.
//

import Foundation
import RealityKit
import RealityKitContent

public var blockSize:Float = 1.0

enum ID {
    case FLAG, CANNON_BALL, SIMPLE_BLOCK, OCEAN_FLOOR, ISLAND_FLOOR, PIRATE_SHIP
}

func isABlock(obj:Object) -> Bool {
    if obj.getID() == ID.SIMPLE_BLOCK {
        return true
    }
    return false
}

func connectBlocks(a: Object, b: Object) {
    
    let posA = a.getEntity()!.position
    let posB = b.getEntity()!.position
    
    let dVector = posB - posA
    
    var max:Int = 0
    var maxValue = dVector.x.magnitude
    if dVector.y.magnitude > maxValue {
        max = 1
        maxValue = dVector.y.magnitude
    }
    if dVector.z.magnitude > maxValue {
        max = 2
        maxValue = dVector.z.magnitude
    }
   
    var newPos = SIMD3<Float>(0,0,0)
    
    if max == 0 {
        newPos = posB + SIMD3<Float>(((dVector.x > 0) ? -1*blockSize/2 : 1*blockSize/2),0,0)
    }
    if max == 1 {
        newPos = posB + SIMD3<Float>(0,((dVector.y > 0) ? -1*blockSize/2 : 1*blockSize/2),0)
    }
    if max == 2 {
        newPos = posB + SIMD3<Float>(0,0,((dVector.z > 0) ? -1*blockSize/2 : 1*blockSize/2))
    }
    
    if isEmptySpace(pos:newPos, ignore:a.getEntity()!) {
        
        a.getEntity()?.position = newPos
        a.getEntity()!.orientation = simd_quatf(angle: 0, axis: SIMD3<Float>(0, 1, 0))
        b.getEntity()!.orientation = simd_quatf(angle: 0, axis: SIMD3<Float>(0, 1, 0))
        
    } else {
        a.goToSpawn()
    }
    
    a.getEntity()!.components[PhysicsBodyComponent.self]?.mode = .static
}

func isEmptySpace(pos:SIMD3<Float>, ignore: Entity) -> Bool {
    
    let objList = manager!.getObjects()
    
    for i in 0...objList.count-1 {
        if objList[i].getEntity() != ignore && objList[i].getEntity()!.position == pos {
            return false
        }
    }
    return true
}

func distanceBetween(a: SIMD3<Float>, b: SIMD3<Float>) -> Float {
    return sqrt(pow(a.x-b.x,2) + pow(a.y - b.y, 2) + pow(a.z - b.z, 2))
}

func getTimes(intervals : Int, time:Float) async -> Array<Float> {
    var arr = Array<Float>(repeating: 0, count: intervals)
    var currentTime = time
    while(currentTime > 0) {
        
        let Rand = Float.random(in: 0...0.5)
        if currentTime > Rand {
            arr[Int.random(in: 0...intervals-1)] += Rand
            currentTime = currentTime - Rand
        } else {
            arr[Int.random(in: 0...intervals-1)] += currentTime
            currentTime = 0
        }
        
    }
    
    print(arr)
    
    return arr
}
