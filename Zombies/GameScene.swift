//
//  GameScene.swift
//  Zombies
//
//  Created by Grey Grissom on 11/8/17.
//  Copyright © 2017 Grey Grissom. All rights reserved.
//

import SpriteKit


/// scene / 1 screen
class GameScene: SKScene
{
    
    var zombie: SKSpriteNode! = nil
    var lastUpdateTime: TimeInterval = 0
    var dt: TimeInterval = 0
    let zombieMovePointsPerSecond: CGFloat = 480.0
    var velocity = CGPoint.zero
    
    
    /// SpriteKit's equivalent method to `viewDidLoad` in UIKit
    ///
    /// - Parameter view: the main view of the SKScene - root node to the scene object
    override func didMove(to view: SKView) {
        backgroundColor = SKColor.black
        let background = SKSpriteNode(imageNamed: "background1")
       
        //needs to add background to a parent node to view
        background.position = CGPoint(x: size.width/2, y: size.height/2)
        // the position of background as -1 to ensure its the base layer when rendering
        background.zPosition = -1
        addChild(background)
        let mySize = background.size
        print("Size: \(mySize)")
        
        
        // zombie
        zombie = SKSpriteNode(imageNamed: "zombie1")
        zombie.position = CGPoint(x: 400, y: 400)
//        zombie.setScale(2.0)
        addChild(zombie)
        
        
    }
    
    
    func move(sprite: SKSpriteNode, velocity: CGPoint)
    {
        //1
        
        let amountToMove = CGPoint(x: velocity.x * CGFloat(dt),
                                   y: velocity.y * CGFloat(dt))
        print("Amount to move: \(amountToMove)")
        
        //2
        
        sprite.position = CGPoint(x: sprite.position.x + amountToMove.x, y: sprite.position.y + amountToMove.y)
    }
    
    
    
    override func update(_ currentTime: TimeInterval) { .
        if lastUpdateTime > 0 {
            dt = currentTime - lastUpdateTime
        } else {
            dt = 0
        }
        lastUpdateTime = currentTime
        print("\(dt * 1000) milliseconds since last update!")
        move(sprite: zombie, velocity: CGPoint(x: zombieMovePointsPerSecond, y: 0))
    }
}
