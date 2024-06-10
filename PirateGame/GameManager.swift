//
//  GameManager.swift
//  PirateGame
//
//  Created by Student on 5/8/24.
//
import SwiftUI
import Foundation
import RealityKit
import RealityKitContent
import _RealityKit_SwiftUI


class GameManager {
    
    private var rContent:RealityViewContent?
    private var lighting:EnvironmentResource?
    private var audioController:Entity?
    private var objectList:[Object]
    private var IsLevelActive = false
    private var pirateShip:PirateShip?
    private var currentLevel = 1
    private var gameLocation:gameLocation?
    private var intermission:levelIntermission?
    private var cardObjects:[GameCard]?
    private var cardList:[GameCard]
    private var physicalCards:[Object]?
    private var cardSize:SIMD3<Float>?
    init(rContent: RealityViewContent?, lighting:EnvironmentResource?, audioController:Entity?) {
        
        
        self.rContent = rContent
        self.lighting = lighting
        self.audioController = audioController
        self.objectList = Array<Object>()
        cardObjects = Array()
        cardObjects!.append(GameCard())
        cardObjects!.append(GameCard())
        cardObjects!.append(GameCard())

        cardList = Array()
        self.setupCardList()
        
        physicalCards = Array()
    }
    
    func setupCardList() {
        cardList.append(doubleCannonballCard())
        cardList.append(largeCannonballCard())
    }
    
//    func registerObject(object: Shop) {
//        object.initiateLighting(IBL: lighting!)
//        if object.getID() != ID.EFFECT {
//            object.initiatePhysicsBody()
//        }
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
//            Task.init {
//                self.rContent?.add(object.getEntity()!)
//                self.objectList.append(object)
//            }
//        }
//        registerObject(object: object.gameButton!)
//        object.gameButton!.setPosition(pos: SIMD3<Float>(0,object.buttonOffset,0))
//    }
//    
    func registerObject(object: Object) {
        object.initiateLighting(IBL: lighting!)
        if object.getID() != ID.EFFECT {
            object.initiatePhysicsBody()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            Task.init {
                self.rContent?.add(object.getEntity()!)
                self.objectList.append(object)
                object.onRegister()
            }
        }
    }
    
    func registerObject(object: PhysicalCard) {
        object.initiateLighting(IBL: lighting!)
        if object.getID() != ID.EFFECT {
            object.initiatePhysicsBody()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            Task.init {
                self.rContent?.add(object.getEntity()!)
                self.objectList.append(object)
                object.onRegister()
            }
        }
        print("physical")
        physicalCards?.append(object)
        cardSize = object.getEntity()!.scale
    }
    
    func partialRegisterObject(object: Object) {
        self.objectList.append(object)
    }
    
    func unregisterObject(object: Object) {
        
        let count = 0...objectList.count-1
        
        for i in count {
            if(objectList[i] == object) {
                
                objectList[i].getEntity()?.removeFromParent()
                objectList.remove(at: i)
                return
                
            }
        }
        
        
    }
    
    func findObject(model: Entity) -> Object? {
        let count = 0...objectList.count-1
        var obj:Object?
        for i in count {
            if(objectList[i].getEntity() == model) {
                
                obj = objectList[i]
                
            }
        }
        
        return obj
    }
    
    func getObjects() -> Array<Object> {
        return objectList
    }
    
    func handleCollision(event: CollisionEvents.Began) {
        
        //HANDLE COLLISION
        
        let obj:Object? = findObject(model:event.entityA)
        
        if obj?.getID() == ID.CANNON_BALL {
            obj?.handleCollision(event:event)
        }
        if obj?.getID() == ID.SIMPLE_BLOCK {
            obj?.handleCollision(event: event)
        }
        
    }
 
    
    func setPirateShip(obj:PirateShip?) {
        pirateShip = obj
    }
    
    func isLevelActive() -> Bool {
        return IsLevelActive
    }
    
    func getCurrentLevel() -> Int {
        return currentLevel
    }
    
    func startNextLevel(level:Level) async {
        IsLevelActive = true
        let levelDuration = level.getDuration()
        
        if level.isSpecialLevel {
            await handleSpecialLevel(level:level)
        }
        else {
            await pirateShip?.shootCannonBalls(amount: level.getBallAmount(), time: level.getDuration())
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + Double(levelDuration) + Double(5)) {
            self.IsLevelActive = false
        }
        
        currentLevel += 1
    }
    
    func endLevel(body: some View) {
        
        
        
        
    }
    
    func handleSpecialLevel(level: Level) async {
        
        let ballArr = level.getBallArray()
        let delayArr = level.getBallDelayArray()
        var totalTime:Float = 0.0
        
        for i in 0...delayArr!.count-1 {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(totalTime + delayArr![i])) {
                Task.init {
                    await self.pirateShip?.shootCannonBall(time: self.pirateShip!.getRandomTime(), type: ballArr![i])
                }
            }
            totalTime += delayArr![i]
        }
    
    }
    
    func pickIntermission() async -> levelIntermission {
        return Merchantintermission() // INFINITE LOOP CHANGE THIS
    }
    
    func startIntermission(cards:inout [GameCard]?) async {
        intermission = await pickIntermission()
        for i in 0...physicalCards!.count-1 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                Task.init{
                    self.physicalCards![i].getEntity()!.scale = self.cardSize!
                }
            }
        }
        await intermission?.onStart(cards: &cards)
    }
    
    func endIntermission(cards:inout [GameCard]?) async {
        await intermission?.onEnd(cards: &cards)
        if let _ = physicalCards {
            for i in 0...physicalCards!.count-1 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                    Task.init{
                        self.physicalCards![i].getEntity()!.scale = [0,0,0]
                    }
                }
            }}
        intermission = nil
    }
    
    func getGameLocation() -> gameLocation {
        return gameLocation!
    }
    
    func setGameLocation(a:gameLocation, vec: inout Vector3D) {
        gameLocation = a
        vec = a.vector3D
        print(vec)
    }
    
    func getCards() -> [GameCard]? {
        return cardObjects
    }
    
    func pickRandomCard() -> GameCard {
        return cardList[Int.random(in: 0...(cardList.count-1))]
    }
    
    func pickCards(cards:inout [GameCard]?) {
        for i in 0...2 {
            cardObjects![i] = pickRandomCard()
            cards![i] = cardObjects![i]
        }
    }
    
    func setCards(cards:inout [GameCard]?) {
        cards = cardObjects
        
        
    }
        
    
    
}
