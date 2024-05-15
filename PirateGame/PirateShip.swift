//
//  PirateShip.swift
//  PirateGame
//
//  Created by Student on 5/14/24.
//


import Foundation
import RealityKit
import RealityKitContent
import _RealityKit_SwiftUI

class PirateShip: Object {
    
    var ship:Entity?
    init() async{
        let PirateShipModel = try? await Entity(named: "PirateShip", in: realityKitContentBundle)
        await print(PirateShipModel?.children.first?.children.first?.children.first?.name)
        ship = await PirateShipModel?.children.first?.children.first?.children.first
        super.init(Entity: PirateShipModel!, ID: ID.PIRATE_SHIP)
        
        
    }
    
    func shootCannonBalls(amount: Int, time: Float) async {
            var range = 0...amount-1
            var current:Double = 0
            var arr = await getTimes(intervals: amount, time: time)
            for i in range {
                DispatchQueue.main.asyncAfter(deadline: .now() + current + Double(arr[i])) {
                    Task.init{
                    await self.shootCannonBall(time: Float.random(in: 0...1.5))
                    }
                }
                current = current + Double(arr[i])
            }
    }
    
    func shootCannonBall(time: Float) async {
        
        let ball = await Cannonball(pos: ship!.position, relativeTo: getEntity()!)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) { [self] in
            Task.init {
                manager?.registerObject(object: ball)
                ball.setDynamic()
                print("ball")
                
                print("pos")
                var newPos = SIMD3<Float>(0 + Float.random(in: -1.5...1.5),1 + Float.random(in: -1.5...1.5),0 + Float.random(in: -1.5...1.5))
                print("shooting")
                await self.moveBall(ent: ball.getEntity()!, newPos: newPos, time: time)
            }
        }
    }
    
    func moveBall(ent : Entity, newPos: SIMD3<Float>, time:Float) async {
        
        var currentPos = await ent.position
        var diff = newPos - currentPos
        var vX = diff.x/time
        var vY = diff.y/time + 4.9*time
        var vZ = diff.z/time
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            Task.init {
                ent.components[PhysicsMotionComponent.self]?.linearVelocity = SIMD3<Float>(vX,vY,vZ)
                print("velocity")
                print(ent.components[PhysicsBodyComponent.self]?.mode)
            }
        }
    }
    
    
}
    
    
    
    
    
