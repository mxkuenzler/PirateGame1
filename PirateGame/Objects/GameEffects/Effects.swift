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
    var resource:AudioFileResource?
    init(objectName:String ,file:String) {
        self.fileName = file
        self.objectName = objectName
        super.init(EntityName: objectName, ID: ID.EFFECT)
        Task{
            fileName = "/Root/ParticleEmitter/SpatialAudio/" + file
            resource = try! await AudioFileResource(named: fileName, from: "\(objectName).usda",in:realityKitContentBundle)
            
        }
    }
    
    func playEffect(pos:SIMD3<Float>, angle: Float, axes: SIMD3<Float>) {
        
        let ent = self.getEntity()?.clone(recursive: true)
        
        ent?.position = pos
        ent?.setOrientation(simd_quatf(angle: angle, axis: axes), relativeTo: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            Task {
                getManager()?.getContent()?.add(ent!)
                await self.playAudio(pos:pos, controller: ent!)
            }
        }
        gameTask(delay:1) {
            getManager()?.getContent()?.remove(ent!)
        }
        
    }
    
    func playAudio(pos:SIMD3<Float>, controller:Entity) async {
        
        let audioController = await controller.findEntity(named: "SpatialAudio")
        let ac = await audioController!.prepareAudio(resource!)
        await ac.play()
    }

}

class CannonballEffect:Effect {
    init() {
        super.init(objectName: "cannonballParticle",file:"Bison_Roar")
    }
}

class BlockEffect: Effect {
    init() {
        super.init(objectName:"blockParticle",file:"Bison_Roar")
    }
}
