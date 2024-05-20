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
    case FLAG, CANNON_BALL, SIMPLE_BLOCK, OCEAN_FLOOR, ISLAND_FLOOR, PIRATE_SHIP, EFFECT, SAMPLE_BLOCK
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
        let m = max // use to change oreantation of the effect
        Task {
            let be: BlockEffect
            if m == 0 {
                be = await BlockEffect(pos: nop - SIMD3(((dVector.x > 0) ? -1*blockSize/4 : 1*blockSize/4), 0, 0))
                await be.getEntity()?.setOrientation(simd_quatf(angle: 1.571, axis: SIMD3<Float>(0, 0, 1)), relativeTo: be.getEntity())
            }
            else if m == 1 {
                be = await BlockEffect(pos: nop - SIMD3(0, ((dVector.y > 0) ? -1*blockSize/4 : 1*blockSize/4), 0))
            }
            else if m == 2 {
                be = await BlockEffect(pos: nop - SIMD3(0, 0, ((dVector.z > 0) ? -1*blockSize/4 : 1*blockSize/4)))
                await be.getEntity()?.setOrientation(simd_quatf(angle: 1.571, axis: SIMD3<Float>(1, 0, 0)), relativeTo: be.getEntity())
            }
            else {
                be = await BlockEffect(pos: nop - SIMD3(0, 0, 0))
            }
            manager?.registerObject(object: be)
//            await playSound(entity: be.getEntity())
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                Task.init {
                    manager?.unregisterObject(object: be)
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
    
    print(arr)
    
    return arr
}

func playAudio(fileName: String) async {
    let fileName = "/Root/" + fileName
    print("a")
    print(fileName)
    let resource = try? await AudioFileResource(named: fileName, from: "AudioController.usda",in:realityKitContentBundle)
    print("b")
    print(resource)
    let ac = await audioController?.prepareAudio(resource!)
    print(ac)
    print(audioController)
    print("c")
    await ac?.play()
    print("d")
}
