//
//  BlimpView.swift
//  PirateGame
//
//  Created by Student on 6/18/24.
//

import Foundation
import SwiftUI
import RealityKit
import RealityKitContent
import Combine

struct BlimpView : View {
    
    @Environment(\.openImmersiveSpace) var openImmersiveSpace
    @Environment(\.dismissImmersiveSpace) var dismissImmersiveSpace
    var keeper:Country
    @State var factor:Float = 100
    @State var tpCube:ModelEntity?
    @State var vector:Vector3D = Vector3D(x:1,y:1,z:1)
    
    var body : some View {
        RealityView { content, attachments in
            
            
            var worldView:ModelEntity = ModelEntity(mesh:.generatePlane(width: 10, depth: 10),materials: [SimpleMaterial(color:.white,isMetallic: false)]) //REPLACE WITH REAL WORLD VIEW
            
            guard let ImageBasedLight = try? await EnvironmentResource(named: "ImageBasedLight") else { return }

            worldView.components[ImageBasedLightComponent.self] = .init(source: .single(ImageBasedLight))
            worldView.components[ImageBasedLightReceiverComponent.self] = .init(imageBasedLight: worldView)
            
            content.add(worldView)
            
            let anchorEnt = AnchorEntity(.head)
            
            content.add(anchorEnt)
            
            if let attachment = attachments.entity(for: "startAttach") {
                attachment.setParent(anchorEnt)
                attachment.position = [0,-0.1,-0.2]
                
            }
            
            tpCube = ModelEntity(mesh:.generateBox(width: 0.1, height: 100, depth: 0.1), materials:[SimpleMaterial(color:.red, isMetallic: false)])
            
            tpCube!.generateCollisionShapes(recursive: false)
            tpCube!.components.set(InputTargetComponent())
            tpCube!.components.set(HoverEffectComponent())
            
            tpCube!.components[ImageBasedLightComponent.self] = .init(source: .single(ImageBasedLight))
            tpCube!.components[ImageBasedLightReceiverComponent.self] = .init(imageBasedLight: tpCube!)
            
            tpCube!.position = [0,0,-10]
            
            content.add(tpCube!)
            
        }
        attachments: {
        Attachment(id: "startAttach") {
            Button("Up"){
                
                factor += 10
                print(factor)
            }
            Button("Down") {
                
                factor -= 10
                print(factor)
                
            }
            Button("Reset") {
                vector = Vector3D(x:0,y:0,z:0)
            }
            Text("\(factor)")
        }
        
        }.gesture(tapGesture).transform3DEffect(AffineTransform3D(translation: vector))
        
        
        
    }
    var tapGesture : some Gesture {
        TapGesture()
            .targetedToAnyEntity()
            .onEnded { value in
                
                if value.entity == tpCube {
                    
                    print(tpCube)
                    
                    let pos = tpCube!.position
                    vector = Vector3D(x:-pos.x*factor,y:-pos.y*factor,z:-pos.z*factor)
                    print(vector)
                }
                
            }
    }
}
