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
    
    var posA = a.getModel()!.position
    var posB = b.getModel()!.position
    
    var dVector = posB - posA
    
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
        print("x")
        a.getModel()!.position = posB + SIMD3<Float>(((dVector.x > 0) ? -1*blockSize/2 : 1*blockSize/2),0,0)
    }
    if max == 1 {
        print("y")
        a.getModel()!.position = posB + SIMD3<Float>(0,((dVector.y > 0) ? -1*blockSize/2 : 1*blockSize/2),0)
    }
    if max == 2 {
        print("z")
        a.getModel()!.position = posB + SIMD3<Float>(0,0,((dVector.z > 0) ? -1*blockSize/2 : 1*blockSize/2))
    }
    print("snapped")
}

func distanceBetween(a: SIMD3<Float>, b: SIMD3<Float>) -> Float {
    return sqrt(pow(a.x-b.x,2) + pow(a.y - b.y, 2) + pow(a.z - b.z, 2))
}
