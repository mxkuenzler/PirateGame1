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
    
    static var k:Int = 0
    
    @State var collisionSubscription:Cancellable?
    @State var timeTotal:Float?
    @State var timeProgress:Float?
    var keeper: Country
    @State var isDraggingBlock:Bool = false
    @State var currentlyDraggingID:ID = ID.NIL
    @State var draggingObj:Object?
    var cards:[GameCard]?
    
    var body: some View {
        
        if (keeper.onHomescreen) {
            ZStack{
                
                RealityView{ content in
                    guard let ImageBasedLight = try? await EnvironmentResource(named: "ImageBasedLight") else { return }
                    
                    let world = makeWorld(light: ImageBasedLight)
                    let portal = makePortal(world: world)
                    
                    content.add(world)
                    content.add(portal)
                }
                
                Button("Start"){
                    Task{
                        keeper.onHomescreen = false
                    }
                }.scaleEffect(10)
            }.transform3DEffect(AffineTransform3D(translation: Vector3D(x: 0, y: -1500, z: -4000)))
        }
        
        else {
            RealityView { content, attachments in
                if ImmersiveView.k > 0{
                    return
                }
                ImmersiveView.k = ImmersiveView.k + 1
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
                await manager?.registerObject(object: secondOceanFloor())
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
                
                
                var anchorEnt = AnchorEntity(.head)
                content.add(anchorEnt)
                
                /*
                var cube = await cardboardBlock()
                cube.getEntity()?.setParent(anchorEnt)
                cube.getEntity()?.position = SIMD3(x:0,y:0,z:-1)
                */
                if let attachment = attachments.entity(for: "earthLabel") {
                    attachment.setParent(anchorEnt)
                    attachment.position = [0,0,-4]
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
                
                //await getManager()?.registerObject(object: DockFloor())
                
                /*for i in 0...3 {
                 
                 let block = await cardboardBlock()
                 manager?.registerObject(object:block)
                 block.setPosition(pos: SIMD3<Float>(x:0,y:Float(i+2),z:0))
                 
                 let cannonBall = await Cannonball()
                 manager?.registerObject(object: cannonBall)
                 cannonBall.setPosition(pos: SIMD3<Float>(x:0,y:3,z:0))
                 }*/
            }
        attachments: {
            
            
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
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                        
                        Task.init {
                            
                            let ent = await getObjectFromID(id: currentlyDraggingID)
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
    
    

