//
//  ImmersiveView.swift
//  PirateGame
//
//  Created by Maxwell Kuenzler on 5/8/24.
//

import SwiftUI
import RealityKit
import RealityKitContent
import Combine


var rContent: RealityViewContent?
var lighting: EnvironmentResource?


struct ImmersiveView: View {
    
    @State var collisionSubscription:Cancellable?
    
    var body: some View {
        RealityView { content in
            
            rContent = content
            
            content.subscribe(
                       to: CollisionEvents.Began.self
                   ) { event in
                       //call manager handler
                   }
            
            // Add the initial RealityKit content
            if let immersiveContentEntity = try? await Entity(named: "Immersive", in: realityKitContentBundle) {
                content.add(immersiveContentEntity)

                // Add an ImageBasedLight for the immersive content
                guard let ImageBasedLight = try? await EnvironmentResource(named: "ImageBasedLight") else { return }
                lighting = ImageBasedLight
                let iblComponent = ImageBasedLightComponent(source: .single(lighting!), intensityExponent: 0.25)
                immersiveContentEntity.components.set(iblComponent)
                immersiveContentEntity.components.set(ImageBasedLightReceiverComponent(imageBasedLight: immersiveContentEntity))

                // Put skybox here.  See example in World project available at
                // https://developer.apple.com/
            }
        }
    }
}

#Preview(immersionStyle: .full) {
    ImmersiveView()
}
