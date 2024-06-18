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
            
        }
        attachments: {
        Attachment(id: "startAttach") {
            Button("Start Game"){
                
                Task{
                    await dismissImmersiveSpace()
                    keeper.isGameActive = true
                    await openImmersiveSpace(id: "HotAirBalloon")
                }
            }
        }
        
        }
    }
}
