//
//  GameScene.swift
//  SuperSpaceManClass
//
//  Created by apple on 2018/10/16.
//  Copyright © 2018年 15130529. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    let backgroundNode = SKSpriteNode(imageNamed: "Background") //SKSPriteNode is a node that used to draw textured sprite
    let playerNode = SKSpriteNode(imageNamed: "Player") //imageNamed means the node will use the image called Player
    let orbNode = SKSpriteNode(imageNamed: "PowerUp") //adding a node for PowerUp image
    
    let CollisionCategoryPlayer : UInt32 = 0x1 << 1
    //defines the category to which a physics body belongs to (example: this collision category belongs to Player)
    let CollisionCategoryPowerUpOrbs : UInt32 = 0x1 << 2
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(size: CGSize) {
        super.init(size: size)
        
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector(dx: 0.0, dy: -0.1) // modified the world's gravity
        
        
        backgroundColor = SKColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
        isUserInteractionEnabled = true //turns on user interaction in the scene
        
        //add background
        backgroundNode.size.width = frame.size.width
        backgroundNode.anchorPoint = CGPoint(x: 0.5, y: 0.0)
        backgroundNode.position = CGPoint(x: size.width / 2.0, y: 0.0)
        addChild(backgroundNode)
        
        //add player
        playerNode.physicsBody = SKPhysicsBody(circleOfRadius: playerNode.size.width / 2)
        playerNode.physicsBody?.isDynamic = true
        
        playerNode.position = CGPoint(x: size.width / 2.0, y: 80.0)
        playerNode.physicsBody?.linearDamping = 1.0 //the player will fall but slowly due the small value on damping
        playerNode.physicsBody?.allowsRotation = false //the player will not spin but it will bounce off
        playerNode.physicsBody?.categoryBitMask = CollisionCategoryPlayer
        playerNode.physicsBody?.contactTestBitMask = CollisionCategoryPowerUpOrbs //notify if this physics body contact with another physics body belongs to PowerUpOrbs category
        playerNode.physicsBody?.collisionBitMask = 0 //tells SpriteKit not to handle collisions
        addChild(playerNode)
        
        //add orbNode
        orbNode.position = CGPoint(x: 150.0, y: size.height - 25)
        orbNode.physicsBody = SKPhysicsBody(circleOfRadius: orbNode.size.width / 2)
        orbNode.physicsBody?.isDynamic = false
        orbNode.physicsBody?.categoryBitMask = CollisionCategoryPowerUpOrbs
        orbNode.physicsBody?.collisionBitMask = 0
        orbNode.name = "POWER_UP_ORB"
        addChild(orbNode)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        playerNode.physicsBody?.applyImpulse(CGVector(dx: 0.0, dy: 40.0))
    }
    
    
}

extension GameScene: SKPhysicsContactDelegate { //extension of GameScene
    func didBegin(_ contact: SKPhysicsContact) {
        
        let nodeB = contact.bodyB.node
        
        if nodeB?.name == "POWER_UP_ORB" {
            nodeB?.removeFromParent()
        }
    }
}

//creating GameScene background for the first time
