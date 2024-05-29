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
var audioController: Entity?
var manager: GameManager?

struct ImmersiveView: View {
    
    @State var collisionSubscription:Cancellable?
    @State var timeTotal:Float?
    @State var timeProgress:Float?
    @State var vec:Vector3D = Vector3D(x: 0,y: 0,z: 0)
    
    var body: some View {
        RealityView { content in
            
            
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
            
            setManager(a:GameManager(rContent: rContent, lighting: lighting, audioController: audioController))
            manager = getManager()
            setLevelManager(a: LevelManager())
            
            content.subscribe(to: CollisionEvents.Began.self) { event in
                manager?.handleCollision(event: event)
            }
            
            await manager?.registerObject(object: OceanFloor())
            await manager?.registerObject(object: IslandFloor())
            await manager?.registerObject(object: Flag())
            let ship = await PirateShip()
            manager?.registerObject(object: ship)
            manager?.setPirateShip(obj: ship)
            ship.setPosition(pos: SIMD3<Float>(0,1,0))
            ship.getEntity()?.components[PhysicsBodyComponent.self]?.mode = .dynamic
            ship.getEntity()?.components[PhysicsBodyComponent.self]?.isAffectedByGravity = false
            var motionComp = ship.getEntity()?.components[PhysicsBodyComponent.self]
            motionComp?.angularDamping = 0
            motionComp?.linearDamping = 0
            ship.getEntity()?.components[PhysicsBodyComponent.self] = motionComp
            ship.getEntity()?.components[PhysicsMotionComponent.self]?.angularVelocity = SIMD3<Float>(0,0.5,0)
            //ship.getEntity()?.components[PhysicsMotionComponent.self]?.linearVelocity = SIMD3<Float>(1,0,0)
            
            await sandRing()
            
            /*DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
             Task.init {
             
             /*
              manager?.registerObject(object: button)
              
              
              button.getEntity()?.position = [0,4,0]
              button.getEntity()?.components[PhysicsBodyComponent.self]?.mode = .static
              print(button)
              */
             for i in -1...1 {
             let shop = await Shop(soldObjectID: (i == -1 ? ID.CARDBOARD_BLOCK : (i == 0 ? ID.WOOD_BLOCK : ID.STONE_BLOCK)), price: i+1, color: i == -1 ? .orange : (i == 0 ? .brown : .darkGray))
             await manager?.registerObject(object:shop)
             shop.setPosition(pos: SIMD3<Float>(7,2.5,1+Float(i*3)))
             shop.setOrientation(angle: -1*Float(i)*3.14159/6 + 3*3.14159/2, axes: SIMD3<Float>(0,0,1))
             }
             }
             }
             DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
             Task.init {
             //print(button.getEntity()?.position)
             }
             }*/
            
            await getManager()?.registerObject(object: DockFloor())
            
            /*for i in 0...3 {
             
             let block = await cardboardBlock()
             manager?.registerObject(object:block)
             block.setPosition(pos: SIMD3<Float>(x:0,y:Float(i+2),z:0))
             
             let cannonBall = await Cannonball()
             manager?.registerObject(object: cannonBall)
             cannonBall.setPosition(pos: SIMD3<Float>(x:0,y:3,z:0))
             
             }*/
            
        }.gesture(gestureA).gesture(gestureB)
        
            .transform3DEffect(AffineTransform3D(translation: vec))
            .task{
                func toggleTimer() async {
                    while true {
                        vec = getManager()?.getTeleportVector() ?? Vector3D(x:0,y:0,z:2000)
                        sleep(1)
                    }
                }
                await toggleTimer()
                
            }
        
        
    }
    
    var gestureA : some Gesture {
        TapGesture()
            .targetedToAnyEntity()
            .onEnded { value in
                
                print("a")
                let scene = value.entity.scene!
                if getManager()?.getSelectedBlock() != ID.NIL {
                    let entity = manager?.findObject(model: value.entity)
                    
                    print("b")
                    
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                        
                        Task.init {
                            
                            let ent = await getObjectFromID(id: getManager()!.getSelectedBlock())
                            print(ent)
                            getManager()?.registerObject(object: ent)
                            ent.setPosition(pos:value.entity.position)
                            (ent as! Block).checkSnap(manager: getManager()!)
                            
                        }
                    }
                    
                }
            }
        
        
    }
    
    var gestureB: some Gesture {
        DragGesture()
            .targetedToAnyEntity()
            .onChanged { value in
                if getManager()?.getSelectedBlock() == ID.NIL {
                    let entity = manager?.findObject(model: value.entity)
                    if let _ = entity {
                        if entity?.getID() == ID.SIMPLE_BLOCK || entity?.getID() == ID.SHIELD {
                            entity?.getEntity()?.components[PhysicsBodyComponent.self]?.mode = .kinematic
                            entity?.getEntity()?.position = value.convert(value.location3D, from:.local, to: value.entity.parent!)
                        }
                        if entity?.getID() == ID.BUTTON {
                            var button = entity as! gameButton
                            button.pressedButton()
                        }
                        
                    } else {
                    }
                }
            }
            .onEnded { value in
                if getManager()?.getSelectedBlock() == ID.NIL {
                    let entity = manager?.findObject(model: value.entity)
                    if let _ = entity {
                        if entity?.getID() == ID.SIMPLE_BLOCK {
                            entity?.getEntity()?.components[PhysicsBodyComponent.self]?.mode = .dynamic
                            (entity! as! Block).checkSnap(manager: manager!)
                        }
                        if entity?.getID() == ID.BUTTON {
                            //DO NOTHING ATM
                        }
                        if entity?.getID() == ID.SHIELD {
                            entity?.getEntity()?.components[PhysicsBodyComponent.self]?.mode = .dynamic
                        }
                    }
                }
                
            }
    }
    
} 
    
    
    
    
    
    
    
    func sandRing() async {
        for i in -2...2 {
            let sand = await sandBlock()
            sand.setPosition(pos: SIMD3<Float>(Float(i)/2, 0, 1))
            manager?.registerObject(object: sand)
            
            let sand2 = await sandBlock()
            sand2.setPosition(pos: SIMD3(Float(i)/2, 0, -1))
            manager?.registerObject(object: sand2)
        }
        
        for i in -1...1 {
            let sand = await sandBlock()
            sand.setPosition(pos: SIMD3<Float>(-1, 0, Float(i)/2))
            manager?.registerObject(object: sand)
            
            let sand2 = await sandBlock()
            sand2.setPosition(pos: SIMD3<Float>(1, 0, Float(i)/2))
            manager?.registerObject(object: sand2)
        }
    }
    
    #Preview(immersionStyle: .full) {
        ImmersiveView()
    }

