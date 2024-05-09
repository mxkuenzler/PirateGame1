//
//  Block.swift
//  PirateGame
//
//  Created by Maxwell Kuenzler on 5/8/24.
//

import Foundation
import RealityKit
import RealityKitContent
import _RealityKit_SwiftUI

class Block: Object {
    
    var HP: Int
    
    init(Material: [any Material], Health: Int){
        
        HP = Health
        
        let BlockModel = ModelEntity(mesh: .generateBox(size: 0.25), materials: Material)
        
        super.init(Model: BlockModel, ID: ID.SIMPLE_BLOCK)
    }
    
}
