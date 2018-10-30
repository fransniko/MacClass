import SpriteKit
import CoreMotion

class GameScene: SKScene {
    
    let backgroundNode = SKSpriteNode(imageNamed: "Background")
    let backgroundStarsNode = SKSpriteNode(imageNamed: "Stars")
    let backgroundPlanetNode = SKSpriteNode(imageNamed: "PlanetStart")
    let foregroundNode = SKSpriteNode()
    let playerNode = SKSpriteNode(imageNamed: "Player")
    
    
    let coreMotionManager = CMMotionManager()
    
    var impulseCount = 4
    
    let CollisionCategoryPlayer : UInt32 = 0x1 << 1
    let CollisionCategoryPowerUpOrbs : UInt32 = 0x1 << 2
    let CollisionCategoryBlackHoles : UInt32 = 0x1 << 3
    
    var engineExhaust: SKEmitterNode?
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
    }
    
    override init(size: CGSize) {
        
        super.init(size: size)
        
        physicsWorld.contactDelegate = self
        
        physicsWorld.gravity = CGVector(dx: 0.0, dy: -5.0);
        
        backgroundColor = SKColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
        
        isUserInteractionEnabled = true
        
        // adding the background
        backgroundNode.size.width = frame.size.width
        backgroundNode.anchorPoint = CGPoint(x: 0.5, y: 0.0)
        backgroundNode.position = CGPoint(x: size.width / 2.0, y: 0.0)
        addChild(backgroundNode)
        
        backgroundStarsNode.size.width = frame.size.width
        backgroundStarsNode.anchorPoint = CGPoint(x: 0.5, y: 0.0)
        backgroundStarsNode.position = CGPoint(x: 160.0, y: 0.0)
        addChild(backgroundStarsNode)
        
        backgroundPlanetNode.size.width = frame.size.width
        backgroundPlanetNode.anchorPoint = CGPoint(x: 0.5, y: 0.0)
        backgroundPlanetNode.position = CGPoint(x: size.width / 2, y: 0.0)
        addChild(backgroundPlanetNode)
        
        //adding foreground
        addChild(foregroundNode)
        
        // add the player
        playerNode.position = CGPoint(x: size.width / 2.0, y: 180.0)
        
        playerNode.physicsBody = SKPhysicsBody(circleOfRadius: playerNode.size.width / 2)
        playerNode.physicsBody?.isDynamic = false
        
        playerNode.position = CGPoint(x: size.width / 2.0, y: 220.0)
        playerNode.physicsBody?.linearDamping = 1.0
        playerNode.physicsBody?.allowsRotation = false
        playerNode.physicsBody?.categoryBitMask = CollisionCategoryPlayer
        playerNode.physicsBody?.contactTestBitMask = CollisionCategoryPowerUpOrbs | CollisionCategoryBlackHoles
        playerNode.physicsBody?.collisionBitMask = 0
        foregroundNode.addChild(playerNode)
        
        //        let pathToEmitter = Bundle.main.path(forResource: "MyParticle", ofType: "sks")
        //        let emitter = NSKeyedUnarchiver.unarchiveObject(withFile: pathToEmitter!) as? SKEmitterNode
        //        foregroundNode.addChild(emitter!)
        
        let engineExhaustPath = Bundle.main.path(forResource: "EngineExhaust", ofType: "sks")
        engineExhaust = NSKeyedUnarchiver.unarchiveObject(withFile: engineExhaustPath!) as? SKEmitterNode
        engineExhaust?.position = CGPoint(x: 0.0, y: -(playerNode.size.height / 2))
        playerNode.addChild(engineExhaust!)
        engineExhaust?.isHidden = false
        
        
        func addOrbsToForeground(){
            
            var orbNodePosition = CGPoint(x: playerNode.position.x, y: playerNode.position.y + 100
            )
            var orbXshift : CGFloat = -1.0
            
            for _ in 1...50 {
                
                let orbNode = SKSpriteNode(imageNamed: "PowerUp")
                
                if orbNodePosition.x - (orbNode.size.width * 2) <= 0 {
                    orbXshift = 1.0
                }
                
                if orbNodePosition.x + orbNode.size.width >= size.width{
                    orbXshift = -1.0
                }
                
                orbNodePosition.x += 40.0 * orbXshift //if it is 50, the orb node will move a little bit to the right and vice versa
                orbNodePosition.y += 120 //position of y
                orbNode.position = orbNodePosition
                orbNode.physicsBody = SKPhysicsBody(circleOfRadius: orbNode.size.width / 2)
                orbNode.physicsBody?.isDynamic = false
                
                orbNode.physicsBody?.categoryBitMask = CollisionCategoryPowerUpOrbs
                orbNode.physicsBody?.collisionBitMask = 0
                orbNode.name = "POWER_UP_ORB"
                
                foregroundNode.addChild(orbNode)
            }
            
        }
        
        addOrbsToForeground()
        
        
        func addBlackHolesToForeground() {
            
            let textureAtlas = SKTextureAtlas(named: "sprites.atlas")
            
            let  frame0 = textureAtlas.textureNamed("BlackHole0")
            let  frame1 = textureAtlas.textureNamed("BlackHole1")
            let  frame2 = textureAtlas.textureNamed("BlackHole2")
            let  frame3 = textureAtlas.textureNamed("BlackHole3")
            let  frame4 = textureAtlas.textureNamed("BlackHole4")
            
            let blackHoleTextures = [frame0, frame1, frame2, frame3, frame4]
            
            let animateAction = SKAction.animate(with: blackHoleTextures, timePerFrame: 0.2)
            let rotateAction = SKAction.repeatForever(animateAction)
            
            let moveLeftAction = SKAction.moveTo(x: 0.0, duration: 2.0)
            let moveRightAction = SKAction.moveTo(x: size.width, duration: 2.0)
            let actionSequence = SKAction.sequence([moveLeftAction, moveRightAction])
            let moveAction = SKAction.repeatForever(actionSequence)
            
            for i in 1...10 {
                let blackHoleNode = SKSpriteNode(imageNamed: "BlackHole0")
                
                blackHoleNode.position = CGPoint(x: size.width - 80.0, y: 600.0 * CGFloat(i))
                blackHoleNode.physicsBody = SKPhysicsBody(circleOfRadius: blackHoleNode.size.width / 2)
                blackHoleNode.physicsBody?.isDynamic = false
                blackHoleNode.physicsBody?.categoryBitMask = CollisionCategoryBlackHoles
                blackHoleNode.physicsBody?.collisionBitMask = 0
                blackHoleNode.name = "BLACK_HOLE"
                
                blackHoleNode.run(moveAction)
                blackHoleNode.run(rotateAction)
                
                foregroundNode.addChild(blackHoleNode)
            }
        }
        
        addBlackHolesToForeground()
        
        
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if !playerNode.physicsBody!.isDynamic {
            
            playerNode.physicsBody?.isDynamic = true
            
            coreMotionManager.accelerometerUpdateInterval = 0.3
            coreMotionManager.startAccelerometerUpdates()
            
        }
        
        if impulseCount > 0 {
            
            playerNode.physicsBody!.applyImpulse(CGVector(dx: 0.0, dy: 40.0))
            impulseCount -= 1
            
            engineExhaust?.isHidden = false
            
            Timer.scheduledTimer(timeInterval: 0.5, //provide period for time
                target: self,
                selector: #selector(GameScene.hideEngineExhaust(_:)),
                userInfo: nil,
                repeats: false)
            
        }
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        if playerNode.position.y >= 180.0 {
            
            backgroundNode.position = CGPoint(x: backgroundNode.position.x, y: -((playerNode.position.y - 180.0)/16))
            
            backgroundStarsNode.position = CGPoint(x: backgroundStarsNode.position.x, y: -((playerNode.position.y - 180.0)/6))
            
            backgroundPlanetNode.position = CGPoint(x: backgroundPlanetNode.position.x, y: -((playerNode.position.y - 180)/8))
            
            foregroundNode.position = CGPoint(x: foregroundNode.position.x, y: -(playerNode.position.y - 180.0))
        }
    }
    
    
    
    
    
    
    deinit {
        coreMotionManager.stopAccelerometerUpdates()
    }
    
    @objc func hideEngineExhaust(_ timer:Timer!){
        if !engineExhaust!.isHidden { // !---! means 1st ! = equal to false
            engineExhaust?.isHidden = true
        }
    }
    
}

extension GameScene: SKPhysicsContactDelegate {
    
    func didBegin(_ contact: SKPhysicsContact) {
        //let nodeB
        //if let contact.bodyB.node != nil{
        //nodeB = contact.bodyB.node!
        //}
        
        let nodeB = contact.bodyB.node!
        if nodeB.name == "POWER_UP_ORB"  {
            impulseCount += 1
            nodeB.removeFromParent()
        }
        else if nodeB.name == "BLACK_HOLE"{
            
            playerNode.physicsBody?.contactTestBitMask = 0
            impulseCount = 0
            
            let colorizeAction = SKAction.colorize(with: UIColor.red, colorBlendFactor: 1.0, duration: 1)
            playerNode.run(colorizeAction)
        }
        
    }
    
    
}

