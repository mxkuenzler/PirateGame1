//
//  ShopGUI.swift
//  PirateGame
//
//  Created by Student on 5/22/24.
//

/*
import Foundation
import RealityKit
import RealityKitContent
import _RealityKit_SwiftUI
import SwiftUI

class Shop:Object {
    var price:Int
    var sellID:ID
    var object:Object?
    var color:UIColor
    var buttonOffset:Float = -1.4
    var gameButton:Object?
    var background:Entity?
    
    init(soldObjectID: ID, price:Int, color: UIColor) async {
        
        self.sellID = soldObjectID
        self.price = price
        self.color = color
        
        
        let ent = try? await Entity(named: "shopFrame", in:realityKitContentBundle)
        
        super.init(Entity:ent!, ID: ID.SHOP)
        
        background = await getEntity()?.findEntity(named: "Background")
            
        changeColor(color: color)
        
        object = await getObjectFromID(id: sellID)
                
        gameButton = await PirateGame.gameButton(action:{
            
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) { [self] in
                Task.init {
                    
                    keeper.coins+=(-price)
                    let obj = await getObjectFromID(id: self.sellID)
                    getManager()?.registerObject(object:obj)
                    obj.goToSpawn()

                }
            }
            
        })
        
        spawnObject()
                
        setPosition(pos: SIMD3<Float>(0,0,0))
    }
    
    override func setPosition(pos: SIMD3<Float>) {
        self.getEntity()?.position = pos
        gameButton?.setPosition(pos: SIMD3<Float>(pos.x, pos.y+buttonOffset, pos.z))
        object!.setPosition(pos: SIMD3<Float>(pos.x, pos.y-buttonOffset/6, pos.z))
    }
    
    override func setOrientation(angle: Float, axes: SIMD3<Float>) {
        super.setOrientation(angle: angle, axes: SIMD3<Float>(0,0,1))
        gameButton?.setOrientation(angle: angle, axes: SIMD3<Float>(1,0,0))
        object!.setOrientation(angle: angle, axes: SIMD3<Float>(0,1,0))
    }
    
    func changeColor(color: UIColor) {
        var mat = background?.components[ModelComponent.self]?.materials[0] as! ShaderGraphMaterial
        try! mat.setParameter(name: "Basecolor_Tint", value: .color(color))
        background?.components[ModelComponent.self]?.materials[0] = mat
    }
    
    func spawnObject() {
        object!.displayObject(lighting: lighting)
    }
    
    
}

*/
