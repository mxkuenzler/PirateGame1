//
//  Helper.swift
//  PirateGame
//
//  Created by Student on 5/9/24.
//

import Foundation
import RealityKit
import RealityKitContent

public var blockSize:Float = 0.5

enum ID {
    case FLAG, CANNON_BALL, SIMPLE_BLOCK, FLOOR
}

func isABlock(obj:Object) -> Bool {
    if obj.getID() == ID.SIMPLE_BLOCK {
        return true
    }
    return false
}

func connectBlocks(a: Object, b: Object) {
    
    let posA = a.getModel()!.position
    let posB = b.getModel()!.position
    
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
    
    if max == 0 {
        a.getModel()!.position = posB + SIMD3<Float>(((dVector.x > 0) ? -1*blockSize/2 : 1*blockSize/2),0,0)
        a.getModel()!.orientation = simd_quatf(angle: 0, axis: SIMD3<Float>(0, 1, 0))
    }
    if max == 1 {
        a.getModel()!.position = posB + SIMD3<Float>(0,((dVector.y > 0) ? -1*blockSize/2 : 1*blockSize/2),0)
        a.getModel()!.orientation = simd_quatf(angle: 0, axis: SIMD3<Float>(0, 1, 0))
    }
    if max == 2 {
        a.getModel()!.position = posB + SIMD3<Float>(0,0,((dVector.z > 0) ? -1*blockSize/2 : 1*blockSize/2))
        a.getModel()!.orientation = simd_quatf(angle: 0, axis: SIMD3<Float>(0, 1, 0))
    }
    a.getModel()!.components[PhysicsBodyComponent.self]?.mode = .static
}

func distanceBetween(a: SIMD3<Float>, b: SIMD3<Float>) -> Float {
    return sqrt(pow(a.x-b.x,2) + pow(a.y - b.y, 2) + pow(a.z - b.z, 2))
}
