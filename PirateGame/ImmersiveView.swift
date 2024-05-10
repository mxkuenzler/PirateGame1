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
var manager: GameManager?

struct ImmersiveView: View {
    
    @State var collisionSubscription:Cancellable?
    
    var body: some View {
        RealityView { content in
            
            //added a comment in Immersive View
            
            rContent = content
            
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
            
            setManager(a:GameManager(rContent: rContent, lighting: lighting))
            manager = getManager()
            
            content.subscribe(to: CollisionEvents.Began.self) { event in
                manager?.handleCollision(event: event)
            }
            
            manager?.registerObject(object: OceanFloor())
            manager?.registerObject(object: IslandFloor())
            
            /*
            for i in 0...0 {
                
                let block = Block(Material: [SimpleMaterial(color:.green, isMetallic: false)], Health: 2)
                manager?.registerObject(object:block)
                block.setPosition(pos: SIMD3<Float>(x:0,y:Float(i+2),z:0))
                
                let cannonBall = Cannonball()
                manager?.registerObject(object: cannonBall)
                cannonBall.setPosition(pos: SIMD3<Float>(x:0,y:1,z:0))
                
            }
           */
        
            
        }.gesture(gestureA)
        
    }
    
    var gestureA : some Gesture {
        DragGesture()
            .targetedToAnyEntity()
            .onChanged { value in
                let entity = manager?.findObject(model: value.entity)
                if let _ = entity {
                    entity?.getEntity()?.components[PhysicsBodyComponent.self]?.mode = .kinematic
                    entity?.getEntity()?.position = value.convert(value.location3D, from:.local, to: value.entity.parent!)
                } else {
                }
                
            }
            .onEnded { value in
                
                value.entity.components[PhysicsBodyComponent.self]?.mode = .dynamic
                
                let entity = manager?.findObject(model: value.entity)
                if let _ = entity {
                    entity?.getEntity()?.components[PhysicsBodyComponent.self]?.mode = .dynamic
                    if entity?.getID() == ID.SIMPLE_BLOCK {
                        (entity! as! Block).checkSnap(manager: manager!)
                    }
                }
            }
    }
}



#Preview(immersionStyle: .full) {
    ImmersiveView()
}
