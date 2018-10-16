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
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(size: CGSize) {
        super.init(size: size)
        
        backgroundNode.size.width = frame.size.width
        backgroundNode.anchorPoint = CGPoint(x: 0.5, y: 0.0)
        backgroundNode.position = CGPoint(x: size.width / 2.0, y: 0.0)
        addChild(backgroundNode)
        
        playerNode.position = CGPoint(x: size.width / 2.0, y: 80.0)
        addChild(playerNode)
    }
    
}

//creating GameScene background for the first time

