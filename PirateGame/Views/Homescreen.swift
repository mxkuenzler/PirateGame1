//
//  Homescreen.swift
//  PirateGame
//
//  Created by Maxwell Kuenzler on 5/23/24.
//

import Foundation
import SwiftUI
import RealityKit
import RealityKitContent


struct Homescreen: View {
    
    @Environment(\.openImmersiveSpace) var openImmersiveSpace
    @Environment(\.dismissImmersiveSpace) var dismissImmersiveSpace
    
    var body: some View {//home menu
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
                    await dismissImmersiveSpace()
                    await openImmersiveSpace(id: "BlimpView")
                }
            }.scaleEffect(10)
        }.transform3DEffect(AffineTransform3D(translation: Vector3D(x: 0, y: -1500, z: -4000)))
//            .task {
//                await openImmersiveSpace(id: "ImmersiveHomescreen")
//            }
    }
}


func makeWorld(light: EnvironmentResource) -> Entity {
    let world = Entity()
    world.components[WorldComponent.self] = .init()
    
    world.components[ImageBasedLightComponent.self] = .init(source: .single(light))
    world.components[ImageBasedLightReceiverComponent.self] = .init(imageBasedLight: world)
    
    Task{
        let show = try! await Entity(named: "homescreenView", in: realityKitContentBundle)
        await world.addChild(show)
    }
    
    world.position = SIMD3<Float>(0, -3, -6)
//    world.setScale(SIMD3<Float>(0.5, 0.5, 0.5), relativeTo: world)
    
    return world
}

func makePortal(world: Entity) -> Entity {
    let portal = Entity()
    
    portal.components[ModelComponent.self] = .init(mesh: .generatePlane(width: 4, height: 2, cornerRadius: 0.5), materials: [PortalMaterial()])
    portal.components[PortalComponent.self] = .init(target: world)
    
    return portal
}
