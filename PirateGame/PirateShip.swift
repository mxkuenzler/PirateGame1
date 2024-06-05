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
        ship = await PirateShipModel?.children.first?.children.first?.children.first
        super.init(Entity: PirateShipModel!, ID: ID.PIRATE_SHIP)
    }
    
    func shootCannonBalls(amount: Int, time: Float) async {
            let range = 0...amount-1
            var current:Double = 0
            let arr = await getTimes(intervals: amount, time: time)
            for i in range {
                DispatchQueue.main.asyncAfter(deadline: .now() + current + Double(arr[i])) {
                    Task.init{
                        await self.shootCannonBall(time:self.getRandomTime())
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
                let newPos = SIMD3<Float>(0 + Float.random(in: -1.5...1.5),1 + Float.random(in: -1.5...1.5),0 + Float.random(in: -1.5...1.5))
                await self.moveBall(ent: ball.getEntity()!, newPos: newPos, time: time)
            }
        }
    }
    
    func shootCannonBall(time: Float, type: String) async { // MAKE THIS COMPATIBLE WITH DIFF TYPES
        
        let ball = await Cannonball(pos: ship!.position, relativeTo: getEntity()!)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) { [self] in
            Task.init {
                manager?.registerObject(object: ball)
                ball.setDynamic()
                let newPos = SIMD3<Float>(0 + Float.random(in: 0...0),1 + Float.random(in: 0...0),0 + Float.random(in: 0...0))
                await self.moveBall(ent: ball.getEntity()!, newPos: newPos, time: time)
            }
        }
    }
    
    func moveBall(ent : Entity, newPos: SIMD3<Float>, time:Float) async {
        
        let angle:Float = await getEntity()!.orientation.angle
        await playEffect(pos: ent.position, angle: angle)
        
        let currentPos = await ent.position
        let diff = newPos - currentPos
        let vX = diff.x/time
        let vY = diff.y/time + 4.9*time
        let vZ = diff.z/time
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            Task.init {
                ent.components[PhysicsMotionComponent.self]?.linearVelocity = SIMD3<Float>(vX,vY,vZ)
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3*Double(time)) {
            Task.init {
                let obj = manager!.findObject(model: ent)
                if let _ = obj {
                    manager?.unregisterObject(object: obj!)
                }
            }
        }
        
    }
    
    func getRandomTime() ->Float {
        return Float.random(in: 1...1.5)
    }
    
}

func playEffect(pos : SIMD3<Float>, angle: Float) async {
    
    let effect = await CannonballEffect(pos: pos, angle:angle) //MAKE THIS SHIP EFFECT
    getManager()?.registerObject(object: effect)
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
        Task.init {
            
            getManager()?.unregisterObject(object:effect)
            
        }
    }
    
}
    
    
    
    
