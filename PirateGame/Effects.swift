//
//  Effects.swift
//  PirateGame
//
//  Created by Maxwell Kuenzler on 5/17/24.
//

import Foundation
import RealityKit
import RealityKitContent
import _RealityKit_SwiftUI

class Effect: Object {
    
    var fileName:String
    var objectName:String
    init(entity: Entity?, objectName:String ,fileName:String) {
        self.fileName = fileName
        self.objectName = objectName
        super.init(Entity: entity!, ID: ID.EFFECT)
    }
    init(entity:Entity?, objectName:String ,fileName:String, pos:SIMD3<Float>, angle:Float, axes: SIMD3<Float>) {
        self.fileName = fileName
        self.objectName = objectName
        super.init(Entity: entity!, ID: ID.EFFECT)
        setPosition(pos:pos)
        setOrientation(angle:angle, axes: axes)
    }
    func playAudio() async {
        let fileName = "/Root/ParticleEmitter/SpatialAudio/" + fileName
        let resource = try? await AudioFileResource(named: fileName, from: "\(objectName).usda",in:realityKitContentBundle)
        
        let controller = try? await Entity(named: self.objectName, in: realityKitContentBundle)
        let audioController = await controller?.findEntity(named: "SpatialAudio")
        rContent?.add(controller!)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            Task.init{
                rContent?.remove(controller!)
            }
        }
        let ac = await audioController?.prepareAudio(resource!)
        await ac?.play()
    }
}

class CannonballEffect:Effect {
    init(pos:SIMD3<Float>, angle: Float) async {
        let effect = try? await Entity(named: "cannonballParticle", in: realityKitContentBundle)
        super.init(entity: effect,objectName: "cannonballParticle",fileName:"Bison_Roar", pos: pos, angle: angle, axes: SIMD3<Float>(0,1,0))
    }
}

class BlockEffect: Effect {
    init(pos: SIMD3<Float>) async {
        let effect = try? await Entity(named: "blockParticle", in: realityKitContentBundle)
        super.init(entity: effect, objectName:"blockParticle",fileName:"Bison_Roar")
        self.setPosition(pos: pos)
    }
}
