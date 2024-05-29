//
//  Button.swift
//  PirateGame
//
//  Created by Student on 5/22/24.
//

import Foundation
import RealityKit
import RealityKitContent
import _RealityKit_SwiftUI


class gameButton : Object {
    
    var act:(()->Void)?
    var buttonDebounce:Bool = false
    var debounceTime:Double = 1
    
    init(action: @escaping () -> Void) async {
        
        print("he")
        var entity = try? await Entity(named:"gameBuyButton", in:realityKitContentBundle)
        await print(entity)
        super.init(Entity: entity!, ID: ID.BUTTON)
        act = action
        entity = await entity?.children.first?.children.first
        await entity?.components.set(HoverEffectComponent())
        await entity?.components.set(InputTargetComponent())

    }
    
    func pressedButton() {
        if !buttonDebounce {
            buttonDebounce = true
            act?()
            DispatchQueue.main.asyncAfter(deadline: .now() + (debounceTime)) {
                Task.init {
                    self.buttonDebounce = false
                }
            }
        }
    }
    
    
}


