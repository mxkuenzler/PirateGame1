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

enum menuStates {
    case STANDARD, TELEPORT, BLOCK, SETTINGS
}

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
    
    @State var HUDState = menuStates.STANDARD
    
    var body: some View {
        
        
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
                
                
                let anchorEnt = AnchorEntity(.head)
                content.add(anchorEnt)
                
                /*
                var cube = await cardboardBlock()
                cube.getEntity()?.setParent(anchorEnt)
                cube.getEntity()?.position = SIMD3(x:0,y:0,z:-1)
                */
                if let attachment = attachments.entity(for: "earthLabel") {
                    attachment.setParent(anchorEnt)
                    attachment.position = [0,-0.1,-0.2]
                    
                }
                
                anchorEnt.anchoring.trackingMode = .continuous
                
                
            
                
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
            
            var ent = VStack{
                switch HUDState {
                case .STANDARD:
                    Button("Hiole"){
                        HUDState = .BLOCK
                    }
                case .TELEPORT:
                    Button("blind") {
                        print("I can see")
                    }
                case .BLOCK:
                    HStack{
                        VStack{
                            /*Model3D(named: "basicBlock", bundle: realityKitContentBundle)
                                .frame(depth: 100)
                                .rotation3DEffect(Angle(degrees: 45), axis: (x: 1, y: 1, z: 1))
                                .onTapGesture {
                                    Task{
                                        var block =  storage?.getCardboardBlock()
                                        if coins >= block!.getPrice() {
                                            block = await storage?.takeCardboardBlock()
                                            block!.setPosition(pos: cardboardSpawn)
                                            coins-=block!.getPrice()
                                            getManager()?.registerObject(object: block!)
                                        }
                                    }
                                }
                                .brightness(8)*/
                            RealityView{ cheese in
                                /*if let block = try? await Entity(named: "basicBlock", in: realityKitContentBundle){
                                    cheese.add(block)
                                    let iblComponent = ImageBasedLightComponent(source: .single(lighting!), intensityExponent: 0.25)
                                    block.components.set(iblComponent)
                                    block.components.set(ImageBasedLightReceiverComponent(imageBasedLight: block))
                                    
                                    block.setOrientation(simd_quatf(angle: -Float.pi/5, axis: [0, 1, 0]), relativeTo: block)
                                }
                                let ex = await cardboardBlock()
                                manager?.registerObject(object: ex)
                                ex.setPosition(pos: [0, -10, 0])*/
                                
                                let block = await cardboardBlock()
                                manager?.partialRegisterObject(object: block)
                                block.initiateLighting(IBL: lighting!)
                                block.initiatePhysicsBody()
                                block.getEntity()?.components[CollisionComponent.self]?.isStatic = true
                                
                                cheese.add(block.getEntity()!)
                            }.frame(depth: 50)
                                .gesture(HUDtap)
                        }
                        .position(CGPoint(x: -1500, y: 0))
                        
                        VStack{
                            /*Model3D(named: "woodBlock", bundle: realityKitContentBundle)
                                .frame(depth: 100)
                                .rotation3DEffect(Angle(degrees: 45), axis: (x: 1, y: 1, z: 1))
                                .onTapGesture {
                                    Task{
                                        var block =  storage?.getWoodBlock()
                                        if coins >= block!.getPrice() {
                                            block = await storage?.takeWoodBlock()
                                            block!.setPosition(pos: woodSpawn)
                                            coins-=block!.getPrice()
                                            getManager()?.registerObject(object: block!)
                                            
                                        }
                                    }
                                }*/
                            RealityView{ cheese in
                                /*if let block = try? await Entity(named: "woodBlock", in: realityKitContentBundle){
                                    cheese.add(block)
                                    let iblComponent = ImageBasedLightComponent(source: .single(lighting!), intensityExponent: 0.25)
                                    block.components.set(iblComponent)
                                    block.components.set(ImageBasedLightReceiverComponent(imageBasedLight: block))
                                    
                                    block.setOrientation(simd_quatf(angle: Float.pi/4, axis: [0, 1, 0]), relativeTo: block)
                                }
                                let ex = await woodBlock()
                                manager?.registerObject(object: ex)
                                ex.setPosition(pos: [0, -10, 0])*/
                                
                                let block = await woodBlock()
                                manager?.partialRegisterObject(object: block)
                                block.initiateLighting(IBL: lighting!)
                                block.initiatePhysicsBody()
                                block.getEntity()?.components[CollisionComponent.self]?.isStatic = true
                                
                                cheese.add(block.getEntity()!)
                            }.frame(depth: 50)
                                .gesture(HUDtap)
                        }
                        .position(CGPoint(x: 0, y: 0))
                        
                        VStack{
                            /*Model3D(named: "stoneBlock", bundle: realityKitContentBundle)
                                .frame(depth: 100)
                                .rotation3DEffect(Angle(degrees: 45), axis: (x: 1, y: 1, z: 1))
                                .onTapGesture {
                                    Task{
                                        var block =  storage?.getStoneBlock()
                                        if coins >= block!.getPrice() {
                                            block = await storage?.takeStoneBlock()
                                            block!.setPosition(pos: stoneSpawn)
                                            coins-=block!.getPrice()
                                            getManager()?.registerObject(object: block!)
                                            
                                        }
                                    }
                                }*/
                            RealityView{ cheese in
                                /*if let block = try? await Entity(named: "stoneBlock", in: realityKitContentBundle){
                                    cheese.add(block)
                                    
                                    let iblComponent = ImageBasedLightComponent(source: .single(lighting!), intensityExponent: 0.25)
                                    block.components.set(iblComponent)
                                    block.components.set(ImageBasedLightReceiverComponent(imageBasedLight: block))
                                    
                                    block.components.set(InputTargetComponent())
                                    block.components.set(HoverEffectComponent())
                                    
                                    block.setOrientation(simd_quatf(angle: Float.pi/5, axis: [0, 1, 0]), relativeTo: block)
                                }
                                let ex = await stoneBlock()
                                manager?.registerObject(object: ex)
                                ex.setPosition(pos: [0, -10, 0])*/
                                
                                let block = await stoneBlock()
                                manager?.partialRegisterObject(object: block)
                                block.initiateLighting(IBL: lighting!)
                                block.initiatePhysicsBody()
                                block.getEntity()?.components[CollisionComponent.self]?.isStatic = true
                                
                                cheese.add(block.getEntity()!)
                            }.frame(depth: 50)
                                .gesture(HUDtap)
                        }
                        .position(CGPoint(x: 1500, y: 0))
                        
                        
                    }
                    .frame(width: 300, height: 80)
                    .scaleEffect(0.05)
                    
                    Button("Close"){
                        HUDState = .STANDARD
                    }
                    
                    
                case .SETTINGS:
                    Button("set"){
                        print("recieve")
                    }
                }
            }.glassBackgroundEffect()
            
            
            
            Attachment(id: "earthLabel")
                {
                    ent
                }
            }
            .gesture(gestureA).gesture(gestureB)
                .transform3DEffect(AffineTransform3D(translation: keeper.vec))
        
        
    }
        
        
    var HUDtap : some Gesture {
        TapGesture()
            .targetedToAnyEntity()
            .onEnded { value in
                let block = manager?.findObject(model: value.entity) as! Block
                
                switch block.blockID {
                    case .CARDBOARD_BLOCK:
                        Task{
                            let bb = await cardboardBlock()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                                Task.init {
                                    manager?.registerObject(object: bb)
                                    bb.setPosition(pos: cardboardSpawn)
                                }
                            }
                        }
                        break
                    case .WOOD_BLOCK:
                        Task{
                            let bb = await woodBlock()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                                Task.init {
                                    manager?.registerObject(object: bb)
                                    bb.setPosition(pos: woodSpawn)
                                }
                            }
                        }
                        break
                    case .STONE_BLOCK:
                        Task{
                            let bb = await stoneBlock()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                                Task.init {
                                    manager?.registerObject(object: bb)
                                    bb.setPosition(pos: stoneSpawn)
                                }
                            }
                        }
                        break
                    default:
                        print("Nothing here")
                        
                    }
               
                
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
    
    

