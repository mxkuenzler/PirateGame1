//
//  GameLocation.swift
//  PirateGame
//
//  Created by Student on 6/4/24.
//

import SwiftUI
import Foundation
import RealityKit
import RealityKitContent
import _RealityKit_SwiftUI

class gameLocation {
    
    var vector3D:Vector3D
    
    init(vector3D:Vector3D) {
        self.vector3D = vector3D
    }
    
    func activateLocation(vec: inout Vector3D) {
                
        getManager()?.setGameLocation(a:self, vec: &vec)
    
        vec = self.vector3D
        
    }
    
}
