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
    var keeper: Country
    @State var isDraggingBlock:Bool = false
    @State var currentlyDraggingID:ID = ID.NIL
    @State var draggingObj:Object?
    var cards:[GameCard]?
    @Environment(\.openImmersiveSpace) var openImmersiveSpace
    @Environment(\.dismissImmersiveSpace) var dismissImmersiveSpace
    
    var body: some View {
            
            RealityView { content, attachments in
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
                
                setManager(a:GameManager(rContent: rContent, lighting: lighting, audioController: audioController, keeper: keeper))
                manager = getManager()
                setLevelManager(a: LevelManager())
                
                content.subscribe(to: CollisionEvents.Began.self) { event in
                    manager?.handleCollision(event: event)
                }

                
                await manager?.registerObject(object: OceanFloor())
                await manager?.registerObject(object: secondOceanFloor())
                await manager?.registerObject(object: IslandFloor())
                await manager?.registerObject(object: Flag())
                let ship = await PirateShip()
                manager?.registerObject(object: ship)
                gameTask() {
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
                }
                await sandRing()
                
                
                let anchorEnt = AnchorEntity(.head)
                content.add(anchorEnt)
                
                /*
                var cube = await cardboardBlock()
                cube.getEntity()?.setParent(anchorEnt)
                cube.getEntity()?.position = SIMD3(x:0,y:0,z:-1)
                */
                if let attachment = attachments.entity(for: "bHUD") {
                    attachment.setParent(anchorEnt)
                    attachment.position = [0,-0.1,-0.2]
                    
                }
                if let attachment = attachments.entity(for: "rHUD") {
                    attachment.setParent(anchorEnt)
                    attachment.position = [0.15,0,-0.2]
                    
                }
                
                anchorEnt.anchoring.trackingMode = .continuous
                
                keeper.cards = Array()
                for i in 0...2 {
                    keeper.cards!.append(GameCard())
                }
                getManager()?.setCards(cards: &keeper.cards)
                
                let card0 = await PhysicalCard()
                let card1 = await PhysicalCard()
                let card2 = await PhysicalCard()

                let scale:Float = 0.01
                
                card0.getEntity()?.scale = SIMD3<Float>(scale,scale,scale)
                card1.getEntity()?.scale = SIMD3<Float>(scale,scale,scale)
                card2.getEntity()?.scale = SIMD3<Float>(scale,scale,scale)

                getManager()?.registerObject(object: card0)
                getManager()?.registerObject(object: card1)
                getManager()?.registerObject(object: card2)
                                
                card0.getEntity()?.scale = SIMD3<Float>(0,0,0)
                card1.getEntity()?.scale = SIMD3<Float>(0,0,0)
                card2.getEntity()?.scale = SIMD3<Float>(0,0,0)
                
                card0.setPosition(pos: SIMD3<Float>(x:-8.2,y:0.5,z:-0.5))
                card1.setPosition(pos: SIMD3<Float>(x:-8.2,y:0.5,z:0))
                card2.setPosition(pos: SIMD3<Float>(x:-8.2,y:0.5,z:0.5))
                
                if let attachment = attachments.entity(for: "card0") {
                    attachment.setParent(card0.getEntity())
                    attachment.position = [0,0,0]
                }
                if let attachment = attachments.entity(for: "card1") {
                    attachment.setParent(card1.getEntity())
                    attachment.position = [0,0,0]
                }
                if let attachment = attachments.entity(for: "card2") {
                    attachment.setParent(card2.getEntity())
                    attachment.position = [0,0,0]
                }
                
               
                
            }
        attachments: {
            
            var bHUD = BottomHUD(keeper: keeper).glassBackgroundEffect()
            
            var rHUD = RightHud(keeper: keeper).glassBackgroundEffect()
                
            
            
            Attachment(id: "bHUD") {
                bHUD
            }
            Attachment(id: "rHUD") {
                rHUD
            }
            
            Attachment(id: "card0") {
                keeper.cards?[0].getView()
            }
            Attachment(id: "card1") {
                keeper.cards?[1].getView()
            }
            Attachment(id: "card2") {
                keeper.cards?[2].getView()
            }
            
            }
            .gesture(gestureA).gesture(gestureB)
                .transform3DEffect(AffineTransform3D(translation: keeper.vec))
        
        
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
                
                if isDraggingBlock && currentlyDraggingID != ID.NIL {
                    gameTask() {
                        
                        let ent = await getObjectFromID(id: currentlyDraggingID)
                        getManager()?.registerObject(object: ent)
                        await ent.setPosition(pos:value.entity.position)
                        await ent.setPosition(pos:value.entity.position)
                        (ent as! Block).checkSnap(manager: getManager()!)
                        
                        
                    }
                    
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
                        isDraggingBlock = true
                        currentlyDraggingID = (entity as! Block).blockID
                    }
                    if entity?.getID() == ID.SHIELD {
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
                        isDraggingBlock = false
                        currentlyDraggingID = ID.NIL
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
    
    

