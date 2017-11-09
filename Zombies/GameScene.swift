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
    let playableRect: CGRect
    var velocity = CGPoint.zero
    
    override init(size: CGSize)
    {
        let maxAspectRatio: CGFloat = 2.3
        let playableHeight = size.width /  maxAspectRatio
       let playableMargin = (size.height-playableHeight)/2.0
        playableRect = CGRect(x: 0,
                              y: playableMargin,
                              width: size.width,
                              height: playableHeight)
        super.init(size: size)
    }
    
    //helper method to visualize playable rectangle of screen
    func debugDrawPlayableArea(){
        let shape = SKShapeNode(rect: playableRect)
        shape.strokeColor = SKColor.red
        shape.lineWidth = 4.0
        addChild(shape)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
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
        zombie.setScale(0.7)
        addChild(zombie)
        debugDrawPlayableArea()
        
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
    
    func moveZombieToward(location: CGPoint)
    {
        let offset = CGPoint(x: location.x - zombie.position.x, y: location.y - zombie.position.y)
        let length = sqrt(Double(offset.x * offset.x + offset.y * offset.y))
        
        let direction = CGPoint(x: offset.x / CGFloat(length),y: offset.y / CGFloat(length))
        
        velocity = CGPoint(x: direction.x * zombieMovePointsPerSecond, y: direction.y * zombieMovePointsPerSecond)
    }
    
    func rotate(sprite: SKSpriteNode, direction: CGPoint)
    {
        sprite.zRotation = atan2(direction.y, direction.x)
    }
    
    override func update(_ currentTime: TimeInterval) {
        if lastUpdateTime > 0 {
            dt = currentTime - lastUpdateTime
        } else {
            dt = 0
        }
        lastUpdateTime = currentTime
        print("\(dt * 1000) milliseconds since last update!")
        move(sprite: zombie, velocity: velocity)
        boundsCheckZombie()
        rotate(sprite: zombie, direction: velocity)
    }
    
    func sceneTouched(touchLocation: CGPoint)
    {
        moveZombieToward(location: touchLocation)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let touchLocation = touch.location(in: self)
        sceneTouched(touchLocation: touchLocation)
    }
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        let touchLocation = touch.location(in: self)
        sceneTouched(touchLocation: touchLocation)
    }
    
    
    func boundsCheckZombie() {
        let bottomLeft = CGPoint(x: 0, y: playableRect.minY)
        let topRight = CGPoint(x: size.width, y: playableRect.maxY)
        
        if zombie.position.x <= bottomLeft.x {
            zombie.position.x = bottomLeft.x
            velocity.x = -velocity.x
        }
        
        if zombie.position.x >= topRight.x {
            zombie.position.x = topRight.x
            velocity.x = -velocity.x
        }
        if zombie.position.y <= bottomLeft.y {
            zombie.position.y = bottomLeft.y
            velocity.y = -velocity.y
        }
        
        if zombie.position.y >= topRight.y {
            zombie.position.y = topRight.y
            velocity.y = -velocity.y
        }
        
    }
}
