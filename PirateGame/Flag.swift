//
//  Flag.swift
//  PirateGame
//
//  Created by Maxwell Kuenzler on 5/10/24.
//

import Foundation
import RealityKit
import RealityKitContent
import _RealityKit_SwiftUI

class Flag: Object {
    
    var HP = 2
    
    init() async{
        let FlagModel = try? await Entity(named: "Flag", in: realityKitContentBundle)
                
        super.init(Entity: FlagModel!, ID: ID.FLAG)
    }
    
    func fixCollisionShapes(){
        self.getEntity()?.components[CollisionComponent.self] = CollisionComponent(shapes: [ShapeResource.generateBox(width: 0.1, height: 2, depth: 0.1)])
    }
    
    func hit(obj: Object) {
        HP = HP - 1
        if HP <= 0 {
            manager?.unregisterObject(object: self)
        }
    }
    
    
    
}
