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
}

class BlockEffect: Effect {
    init(pos: SIMD3<Float>) async {
        let effect = try? await Entity(named: "blockParticle", in: realityKitContentBundle)
        super.init(entity: effect)
        self.setPosition(pos: pos)
    }
}
