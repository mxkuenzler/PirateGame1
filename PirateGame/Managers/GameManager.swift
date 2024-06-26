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
    public var cardDeck:[GameCardID]
    public var keeper:Country
    
    let queue = DispatchQueue.global()
    
    init(rContent: RealityViewContent?, lighting:EnvironmentResource?, audioController:Entity?, keeper:Country) async {
        
        self.keeper = keeper
        
        self.rContent = rContent
        self.lighting = lighting
        self.audioController = audioController
        self.objectList = Array<Object>()
        self.cardDeck = Array()
        setupCardDeck()
        
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
    
    func setupCardDeck() {
        //ADD ALL CARDS HERE
        cardDeck.append(.LARGE_CANNONBALLS)
        cardDeck.append(.DOUBLE_CANNONBALLS)
    }
    
    func getCardFromID(ID: GameCardID) async -> GameCard {
        switch ID {
        case .LARGE_CANNONBALLS:
            return await LargeCannonballCard()
        case .DOUBLE_CANNONBALLS:
            return await DoubleCannonballCard()
        default:
            return await GameCard(cardID: .NIL, EntityName: "NIL", action: {})
        }
    }
    
    
    func registerObject(object: Object) {
        keeper.historicObjects.append(object)
        object.initiateLighting(IBL: lighting!)
        if object.getID() != ID.EFFECT {
            object.initiatePhysicsBody()
        }
        gameTask() {
            
            self.rContent?.add(object.getEntity()!)
            self.objectList.append(object)
            object.onRegister()
        }
    }
    
    func partialRegisterObject(object: Object) {
        keeper.historicObjects.append(object)
        self.objectList.append(object)
    }
    
    func unregisterObject(object: Object) {
        queue.sync {
            let count = 0..<self.objectList.count
            for i in count {
                if let entity = self.objectList[i].getEntity(), entity == object.getEntity() {
                    
                    self.objectList.remove(at: i)
                    object.onUnregister()
                    
                    if let rContentEntity = object.getEntity() {
                        self.rContent?.remove(rContentEntity)
                    }
                    break
                }
            }
        }
    }

    
// func unregisterObject(object: Object) {
//        queue.sync {
//            let count = 0...objectList.count-1
//            for i in count {
//                if(objectList[i].getEntity() == object.getEntity()) {
////                    print(object.getEntity()?.parent?.name)
//                    objectList.remove(at: i)
//                    object.onUnregister()
////                    print("compared: \(obj.getEntity()?.name) to \(object.getEntity()?.name)")
////                    print("compared: \(obj.getEntity()?.hashValue) to \(object.getEntity()?.hashValue)")
////                    print(object.getEntity()?.parent?.hashValue)
////                    print(object.getEntity()?.parent?.name)
//
////                    object.getEntity()?.removeFromParent()
//                    self.rContent?.remove(object.getEntity()!)
//                    break
//                }
//            }
//        }
//
//    }
    
    func findObject(model: Entity) -> Object? {
        var obj:Object?
        queue.sync {
            let count = 0...objectList.count-1
            for i in count {
                if(objectList[i].getEntity() == model) {
                    
                    obj = objectList[i]
                    
                }
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
        
        gameTask(delay:Double(levelDuration) + Double(3)) {
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
            gameTask(delay:Double(totalTime + delayArr![i])) {
                await self.pirateShip?.shootCannonBall(time: self.pirateShip!.getRandomTime(), type: ballArr![i])
                
            }
            totalTime += delayArr![i]
        }
    
    }
    
    func pickIntermission() async -> levelIntermission {
        return Merchantintermission() // INFINITE LOOP CHANGE THIS
    }
    
    func startIntermission(cards:inout [GameCard]?) async {
        intermission = await pickIntermission()
        await intermission?.onStart()
    }
    
    func endIntermission() async {
        await intermission?.onEnd()
        intermission = nil
    }
        
    
    func getGameLocation() -> gameLocation {
        return gameLocation!
    }
    
    func setGameLocation(a:gameLocation, vec: inout Vector3D) {
        gameLocation = a
        vec = a.vector3D
    }
    
    func pickRandomCard() async -> GameCard {
        let index = Int.random(in: 0...keeper.availableCards.count-1)
        let card = await getCardFromID(ID:keeper.availableCards[index])
        return card
    }
    
    func getContent() -> RealityViewContent? {
        return rContent
    }
    
}
