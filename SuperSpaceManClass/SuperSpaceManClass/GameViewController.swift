//
//  GameViewController.swift
//  SuperSpaceManClass
//
//  Created by apple on 2018/10/16.
//  Copyright © 2018年 15130529. All rights reserved.
//


import SpriteKit


class GameViewController: UIViewController {

    var scene: GameScene!
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //1. Configure the main view
        let skView = view as! SKView
        skView.showsFPS = true  //show or hide the frame per second in the application
        
        
        //2. Create and configure our game scene
        scene = GameScene(size: skView.bounds.size)
        scene.scaleMode = .aspectFill //scaling the scene to fill while maintaining the aspect ratio of the scene
        
        //3. Show the scene
        skView.presentScene(scene)
    }
}
