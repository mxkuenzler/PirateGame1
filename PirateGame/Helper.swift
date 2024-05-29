//
//  Helper.swift
//  PirateGame
//
//  Created by Student on 5/9/24.
//

import Foundation
import RealityKit
import RealityKitContent
import SwiftUI

public var blockSize:Float = 1.0

enum ID {
    case FLAG, CANNON_BALL, SIMPLE_BLOCK, OCEAN_FLOOR, ISLAND_FLOOR,
         PIRATE_SHIP, EFFECT, SAMPLE_BLOCK, BUTTON, SHOP, NIL, SAND_BLOCK,
         STONE_BLOCK, WOOD_BLOCK, CARDBOARD_BLOCK, DOCK_FLOOR, SHIELD
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
        
        let nop = newPos
        guard let ent = a.getEntity() else { return }
        let xPos = (a.getPosition()?.x)!
        let yPos = (a.getPosition()?.y)!
        let zPos = (a.getPosition()?.z)!

        Task{
            if !isEmptySpace(pos: SIMD3<Float>(xPos - blockSize/2, yPos, zPos), ignore: ent){
                let be = await BlockEffect(pos: nop - SIMD3<Float>(blockSize/4, 0, 0))
                be.setOrientation(angle: 1.571, axes: SIMD3<Float>(0, 0, 1))
                manager?.registerObject(object: be)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    Task.init{
                        manager?.unregisterObject(object: be)
                    }
                }
            }
            if !isEmptySpace(pos: SIMD3<Float>(xPos + blockSize/2 , yPos, zPos), ignore: ent){
                let be = await BlockEffect(pos: nop - SIMD3<Float>(-blockSize/4, 0, 0))
                be.setOrientation(angle: 1.571, axes: SIMD3<Float>(0, 0, 1))
                manager?.registerObject(object: be)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    Task.init{
                        manager?.unregisterObject(object: be)
                    }
                }
                
            }
            if !isEmptySpace(pos: SIMD3<Float>(xPos, yPos - blockSize/2, zPos), ignore: ent){
                let be = await BlockEffect(pos: nop - SIMD3<Float>(0, blockSize/4, 0))
                manager?.registerObject(object: be)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    Task.init{
                        manager?.unregisterObject(object: be)
                    }
                }
                
            }
            if !isEmptySpace(pos: SIMD3<Float>(xPos, yPos + blockSize/2, zPos), ignore: ent){
                let be = await BlockEffect(pos: nop - SIMD3<Float>(0, -blockSize/4, 0))
                manager?.registerObject(object: be)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    Task.init{
                        manager?.unregisterObject(object: be)
                    }
                }
                
            }
            if !isEmptySpace(pos: SIMD3<Float>(xPos, yPos, zPos - blockSize/2), ignore: ent){
                let be = await BlockEffect(pos: nop - SIMD3<Float>(0, 0, blockSize/4))
                be.setOrientation(angle: 1.571, axes: SIMD3<Float>(1, 0, 0))
                manager?.registerObject(object: be)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    Task.init{
                        manager?.unregisterObject(object: be)
                    }
                }
                
            }
            if !isEmptySpace(pos: SIMD3<Float>(xPos, yPos, zPos + blockSize/2), ignore: ent){
                let be = await BlockEffect(pos: nop - SIMD3<Float>(0, 0, -blockSize/4))
                be.setOrientation(angle: 1.571, axes: SIMD3<Float>(1, 0, 0))
                manager?.registerObject(object: be)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    Task.init{
                        manager?.unregisterObject(object: be)
                    }
                }
                
            }
        }
        
        
    } else {
        a.goToSpawn()
    }
    
    a.getEntity()!.components[PhysicsBodyComponent.self]?.mode = .static
}

func playSound(entity: Entity?) async {
    
    guard let entity = await entity!.findEntity(named: "SpatialAudio"),
          let resource = try? await AudioFileResource(named: "Root/Clicker/mixkit_interface_click_1126_wav",
                                   from: "blockParticle.usda",
                                    in: realityKitContentBundle) else { print("nay"); return }
        
    let audioPlaybackController = await entity.prepareAudio(resource)
    await audioPlaybackController.play()
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
        
    return arr
}

func playAudio(fileName: String) async {
    let fileName = "/Root/" + fileName
    let resource = try? await AudioFileResource(named: fileName, from: "AudioController.usda",in:realityKitContentBundle)
    let ac = await audioController?.prepareAudio(resource!)
    await ac?.play()
}

func makeButton(size: Float, color: UIColor) -> ModelEntity {
    
    let ent = ModelEntity(mesh: .generateBox(width: size*1.618, height: size/2*1.618, depth: size/2), materials: [SimpleMaterial(color: color,isMetallic:false)])
    return ent
    
}

func getObjectFromID(id: ID) async -> Object {
    switch id  {
    case .CARDBOARD_BLOCK:
        return await cardboardBlock()
    case .STONE_BLOCK:
        return await stoneBlock()
    case .WOOD_BLOCK:
        return await woodBlock()
    case .SAND_BLOCK:
        return await sandBlock()
    case .SHIELD:
        return await Shield()
    default:
        return await Object(Entity: Entity(), ID: .NIL)
    }
}
