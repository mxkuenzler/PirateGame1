//
//  TimedTask.swift
//  PirateGame
//
//  Created by Student on 6/12/24.
//

import Foundation

class gameTask {
    
    init(action: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01 ) {
            Task.init{
                if getManager()?.keeper.isGameActive == true{
                    action()
                }
            }
        }
    }
    
    init(delay: Float, action: @escaping () -> Void) {
        let current = getManager()?.keeper.gameCount
        DispatchQueue.main.asyncAfter(deadline: .now() + Double(delay)) {
            Task.init{
                if getManager()?.keeper.isGameActive == true  && current == getManager()?.keeper.gameCount {
                    action()
                }
            }
        }
    }
    
    init(delay: Double, action: @escaping () -> Void) {
        let current = getManager()?.keeper.gameCount
        DispatchQueue.main.asyncAfter(deadline: .now() + Double(delay)) {
            Task.init{
                if getManager()?.keeper.isGameActive == true && current == getManager()?.keeper.gameCount {
                    action()
                }
            }
        }
    }
    
    init(delay: Int, action: @escaping () -> Void) {
        let current = getManager()?.keeper.gameCount
        DispatchQueue.main.asyncAfter(deadline: .now() + Double(delay)) {
            Task.init{
                if getManager()?.keeper.isGameActive == true && current == getManager()?.keeper.gameCount {
                    action()
                }
            }
        }
    }

    init(action: @escaping () async -> Void)  {
        let current = getManager()?.keeper.gameCount

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            Task.init{
                if getManager()?.keeper.isGameActive == true  && current == getManager()?.keeper.gameCount{
                    
                    await action()
                }
            }
        }
    }
    
    init(delay: Float, action: @escaping () async -> Void)  {
        let current = getManager()?.keeper.gameCount
        DispatchQueue.main.asyncAfter(deadline: .now() + Double(delay)) {
            Task.init{
                if getManager()?.keeper.isGameActive == true && current == getManager()?.keeper.gameCount {

                    await action()
                }
            }
        }
    }
    
    init(delay: Double, action: @escaping () async -> Void) {
        let current = getManager()?.keeper.gameCount
        DispatchQueue.main.asyncAfter(deadline: .now() + Double(delay)) {
            Task.init{
                if getManager()?.keeper.isGameActive == true && current == getManager()?.keeper.gameCount {
                    await action()
                }
            }
        }
    }
    
    init(delay: Int, action: @escaping () async -> Void) {
        let current = getManager()?.keeper.gameCount
        DispatchQueue.main.asyncAfter(deadline: .now() + Double(delay)) {
            Task.init{
                if getManager()?.keeper.isGameActive == true && current == getManager()?.keeper.gameCount {
                    await action()
                }
            }
        }
    }


}
