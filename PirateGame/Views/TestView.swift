//
//  TestView.swift
//  PirateGame
//
//  Created by Maxwell Kuenzler on 6/14/24.
//

import Foundation
import SwiftUI
import RealityKit
import RealityKitContent
import Combine

struct TestView: View {
    @State var collisionSubscription:Cancellable?
    var keeper: Country

    var body: some View {
            
            RealityView { content in
                keeper.isGameActive = true
                keeper.gameCount += 1
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
                
                let entity = try? await Entity(named: "AudioController", in: realityKitContentBundle)
                audioController = entity?.findEntity(named: "AmbientAudio")
                content.add(entity!)
                
                await setManager(a:GameManager(rContent: rContent, lighting: lighting, audioController: audioController, keeper: keeper))
                manager = getManager()
                setLevelManager(a: LevelManager())
                
                content.subscribe(to: CollisionEvents.Began.self) { event in
                    manager?.handleCollision(event: event)
                }

                
                await manager?.registerObject(object: IslandFloor())
                
                await manager?.registerObject(object: Flag())
                
                await sandRing()
                
               
                
            }.gesture(gestureA).gesture(gestureB)
        
        
    }
        
        
    
        
    var gestureA : some Gesture {
        TapGesture()
            .targetedToAnyEntity()
            .onEnded { value in
                    
                let entity = manager?.findObject(model: value.entity)
                
                if entity?.getID() == ID.BUTTON {
                    let button = entity as! gameButton
                    button.pressedButton()
                }
                
            }
    }

    
    
    var gestureB: some Gesture {
        DragGesture()
            .targetedToAnyEntity()
            .onChanged { value in
                let entity = manager?.findObject(model: value.entity)
                if let _ = entity {
                    if entity?.getID() == ID.SIMPLE_BLOCK {
                        entity?.getEntity()?.components[PhysicsBodyComponent.self]?.mode = .kinematic
                        entity?.getEntity()?.position = value.convert(value.location3D, from:.local, to: value.entity.parent!)
                    }
                    if entity?.getID() == ID.CANNON_BALL {
                        entity?.getEntity()?.components[PhysicsBodyComponent.self]?.mode = .kinematic
                        entity?.getEntity()?.position = value.convert(value.location3D, from:.local, to: value.entity.parent!)
                    }
                    
                }
            }
            .onEnded { value in
                let entity = manager?.findObject(model: value.entity)
                if let _ = entity {
                    if entity?.getID() == ID.SIMPLE_BLOCK {
                        entity?.getEntity()?.components[PhysicsBodyComponent.self]?.mode = .dynamic
                        (entity! as! Block).checkSnap(manager: manager!)
                    }
                    if entity?.getID() == ID.BUTTON {
                        //DO NOTHING ATM
                    }
                    if entity?.getID() == ID.CANNON_BALL {
                        entity?.getEntity()?.components[PhysicsBodyComponent.self]?.mode = .dynamic
                    }
                }
            }
        
    }
}
