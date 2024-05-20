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
    init(entity: Entity?) {
        super.init(Entity: entity!, ID: ID.EFFECT)
    }
    init(entity:Entity?, pos:SIMD3<Float>, angle:Float, axes: SIMD3<Float>) {
        super.init(Entity: entity!, ID: ID.EFFECT)
        setPosition(pos:pos)
        setOrientation(angle:angle, axes: axes)
    }
}

class CannonballEffect:Effect {
    init(pos:SIMD3<Float>, angle: Float) async {
        let effect = try? await Entity(named: "CannonballParticle", in: realityKitContentBundle)
        super.init(entity: effect, pos: pos, angle: angle, axes: SIMD3<Float>(0,1,0))
    }
}

class BlockEffect: Effect {
    init(pos: SIMD3<Float>) async {
        let effect = try? await Entity(named: "blockParticle", in: realityKitContentBundle)
        super.init(entity: effect)
        self.setPosition(pos: pos)
    }
}
