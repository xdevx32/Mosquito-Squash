//
//  GameScene.swift
//  Mosquito Squash
//
//  Created by Angel Kukushev on 9/16/15.
//  Copyright (c) 2015 xdevx332. All rights reserved.
//
import SpriteKit
import CoreGraphics

// Ray Wrendlich Touch events for the flip flop

private let kAnimalNodeName = "movable"

private let predatorNodeName = "predator"

private let roomNodeName = "roomBackground"

private var points = 0

private var lives = 7

//var selectedNodes = [UITouch:SKSpriteNode]()


var highscore = 1

let highScoreDefaults = NSUserDefaults.standardUserDefaults()

var pauseButton: SKSpriteNode! = nil

var pauseFlag: Bool = true

var flopPosition = CGPoint(x:0 ,y:0)

var monsterSpeed = 4.0

// OSCILLATION VARS

let π = CGFloat(M_PI)

var amplitude: CGFloat = 30.0

var timer = NSTimer()

var time = 30

//
var masterMonsterCount: Int = 2

let backgroundMusic = SKAction.playSoundFileNamed("msBackgroundMusic.wav",  waitForCompletion: true)


let myLabel = SKLabelNode(fontNamed: "Copperplate")

let livesLabel = SKLabelNode(fontNamed: "Copperplate")

let highScoreLabel = SKLabelNode(fontNamed: "Copperplate")

let timerLabel = SKLabelNode(fontNamed: "Copperplate")

class GameScene: SKScene {
    
    var deadMosquito = SKTexture()
    
    let player = SKSpriteNode(imageNamed: "MosquitoDrawed")
    let background = SKSpriteNode(imageNamed: "roomScaled4sB&W2")
    //MosquitoSquashBackgroundBike
    
    
    var selectedNode = SKSpriteNode()
   
    
    override init(size: CGSize) {
        super.init(size: size)
        
        
        // tap gesture end
        
        // 1
        background.name = "background"
        self.background.anchorPoint = CGPointZero
        background.zPosition = 0
        background.size = self.frame.size
        self.addChild(background)
        
        // 2
        let imageNames = ["MosquitoDrawedDead","flipFlop","MosquitoDrawed"]
        
        // 3
        for i in 0..<imageNames.count {
            let imageName = imageNames[i]
            
            let spriteFlop = SKSpriteNode(imageNamed: imageName)
            spriteFlop.name = kAnimalNodeName
            
            //let offsetFraction = (CGFloat(i) + 1.0)/(CGFloat(imageNames.count) + 1.0)
            
            //spriteFlop.position = CGPoint(x: size.width * offsetFraction, y: size.height / 2)
            // spriteFlop.position = CGPoint(x: 100, y: 100)
            // background.addChild(spriteFlop)
            
        }
        
    
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
  
    func decreaseTimer() {
        
        time--
        
        timerLabel.text = "Time: \(time)"
        
    }
    override func update(currentTime: CFTimeInterval){
     
        // Loop over all nodes in the scene
        self.enumerateChildNodesWithName("*") {
            node, stop in
            if (node is SKSpriteNode) {
                let sprite = node as! SKSpriteNode
                // Check if the node is not in the scene
                if (sprite.position.x < -sprite.size.width/2.0 || sprite.position.x > self.size.width+sprite.size.width/2.0
                    || sprite.position.y < -sprite.size.height/2.0 || sprite.position.y > self.size.height+sprite.size.height/2.0) {
                        sprite.removeFromParent()
                        sprite.physicsBody = nil
                        lives--
                        livesLabel.text = "Lives: \(lives)"
                        if lives <= 0{
                            let reveal = SKTransition.flipHorizontalWithDuration(0.5)
                            let gameOverScene = GameOverScene(size: self.size, won: false,points: points,highscore: highscore)
                            self.view?.presentScene(gameOverScene, transition: reveal)
                            
                            self.scene?.removeAllChildren()
                            self.scene?.removeAllActions()
                            self.scene?.removeFromParent()
                            
                    
                        }
                        
                        
                }
            }
        }
        
    }
    override func didMoveToView(view: SKView) {
        
 
        
    
        if(highScoreDefaults.valueForKey("highscore") != nil){
            highscore = highScoreDefaults.valueForKey("highscore") as! Int
        }else{
            print("nil")
        }
        
        
        //highScoreDefaults.setValue(highscore, forKey: "highscore")
        //highScoreDefaults.synchronize() // don't forget this!!!!
       // print(highScoreDefaults.valueForKey("highscore"))
//        if let highscore = highScoreDefaults.valueForKey("highscore") {
//            print("hey")
//        }
//        else {
//            // no highscore exists
//        }
        
        
        
        
       //   self.view!.showsPhysics = true
       runAction(SKAction.repeatAction(backgroundMusic, count: 40))
        runAction(SKAction.stop())
        
        
        //button code
        
        // Create a simple red rectangle that's 100x44
     
        // Put it in the center of the scene
       // pauseButton.position = CGPoint(x:CGRectGetMidX(self.frame) + 190, y:CGRectGetMidY(self.frame) + 136);

        
//        // -=-=-23=-12=3-12=3-12=3-12=3-12=3-12=3-12=3-12=3-12=3-12=3-
//
        
        pauseButton = SKSpriteNode(imageNamed: "pauseBtn")
        
        print(CGRectGetMaxX(self.frame))
        pauseButton.position = CGPoint(x:CGRectGetMaxX(self.frame) - 20 ,y:self.view!.frame.maxY - 20.0)
        pauseButton.zPosition = 1
        self.addChild(pauseButton)
        
        // label code
        
        myLabel.fontColor = SKColor.blackColor()
        
        myLabel.fontSize = 20
       
        //myLabel.position = CGPointMake(CGRectGetMidX(self.frame) - 160, CGRectGetMidY(self.frame) + 136)
        myLabel.position = CGPointMake(CGRectGetMinX(self.frame) + 60 ,self.view!.frame.maxY - 20.0)
        myLabel.text = "Kills: \(points)"
        
        myLabel.zPosition = 1
        
        self.addChild(myLabel)
        //high score label
        
        highScoreLabel.fontColor = SKColor.blackColor()
        
        highScoreLabel.fontSize = 10
        
        //myLabel.position = CGPointMake(CGRectGetMidX(self.frame) - 160, CGRectGetMidY(self.frame) + 136)
        highScoreLabel.position = CGPointMake(CGRectGetMinX(self.frame) + 70 ,self.view!.frame.maxY - 40.0)
        highScoreLabel.text = "High Score: \(highscore)"
        
        highScoreLabel.zPosition = 1
        
        self.addChild(highScoreLabel)
        //
        // fails label
        
        livesLabel.fontColor = SKColor.blackColor()
        
        livesLabel.fontSize = 20
        
        livesLabel.position = CGPointMake(myLabel.position.x + 90.0, self.view!.frame.maxY - 20.0)
        
        livesLabel.text = "Lives: \(lives)"
        
        livesLabel.zPosition = 1
        
        self.addChild(livesLabel)
        
        //1-=23-12=3-12=3-12=3-12=3-12=3-12=-312=-312=-312=-312=3-12=3-12=
//
//        //timer Label
//        
//        timerLabel.fontColor = SKColor.blackColor()
//        
//        timerLabel.fontSize = 25
//        
//        timerLabel.position = CGPointMake(CGRectGetMidX(self.frame) - 160 , CGRectGetMidY(self.frame) + 100)
//        
//        timerLabel.text = "Time: \(time)"
//        
//        timerLabel.zPosition = 1
//        
//        self.addChild(timerLabel)
//        
//        //
//        //play Timer
//        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("decreaseTimer"), userInfo: nil, repeats: true)
//        
        //tap gesture
//        
//        let tap = UITapGestureRecognizer(target: self, action: "tapped:")
//        self.view!.addGestureRecognizer(tap)
//        
        
       
        //Adding the player
       // addChild(player)
        
        
        func fibonacciNumber(n: Int) -> Int{
            if n == 1 {
                return 1
            }
            if n == 2 {
                return 1
            }
            
            return fibonacciNumber(n - 1) + fibonacciNumber(n - 2)
        }
        
        
       // print(selectedNode.name)
//          old
//        let actionSequence = SKAction.sequence([SKAction.runBlock(addMonster),SKAction.waitForDuration(4)])
//        //was 1.5
        
          let actionSequence = SKAction.sequence([SKAction.waitForDuration(4),SKAction.runBlock(addMonster)])
          let secondActionSequence = SKAction.sequence([SKAction.waitForDuration(2.5),SKAction.runBlock(addMonsterTwo)])
//        //was 5.0
//        
         runAction(SKAction.repeatAction(actionSequence, count: 400))
         runAction(SKAction.repeatAction(secondActionSequence, count: 400))
        
        
        //runAction(SKAction.repeatAction(secondActionSequence, count: 100))
        //for i in 5.stride(to: 1, by: -1)
//      
     // runAction(actionSequence)
    }
    
    func addMoreMonsters(functionCount: Int){
        let actionSequence = SKAction.sequence([SKAction.waitForDuration(4),SKAction.runBlock(addMonster),SKAction.waitForDuration(4),SKAction.runBlock(addMonsterTwo)])
        runAction(SKAction.repeatAction(actionSequence, count: functionCount))
    }

//   // The dragging thing
//    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
//        for touch in touches {
//            let location = touch.locationInNode(self)
//            if let node = self.nodeAtPoint(location) as? SKSpriteNode {
//                // Assumes sprites are named "sprite"
//                //if (node.name == "sprite") {
//                    selectedNodes[touch] = node
//                    print(location)
//                //}
//            }
//        }
//    }
//    
//    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
//        for touch in touches {
//            let location = touch.locationInNode(self)
//            // Update the position of the sprites
//            if let node = selectedNodes[touch] {
//                node.position = location
//                print(location)
//            }
//        }
//    }
//    
//    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
//        for touch in touches {
//            if selectedNodes[touch] != nil {
//                selectedNodes[touch] = nil
//                
//            }
//        }
//    }
    
override func touchesBegan(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        for touchObject in touches! {
            
            let touch = touchObject as UITouch
           
          
            let location = touch.locationInNode(self)
           // selectedNode = self.physicsWorld.bodyAtPoint(location)?.node as! SKSpriteNode
            
            let touchedNodeArray = self.nodesAtPoint(location)
            
            //print(location)
            
            for child in touchedNodeArray {
                if child is SKSpriteNode {
                    
                    //if !selectedNode.isEqual(child) {
                    if ((self.physicsWorld.bodyAtPoint(location)?.node!.isEqual(child)) == nil) {
                       // selectedNode = child as! SKSpriteNode
                        
                        if child.name == predatorNodeName{
                            
                            let deadPredator = SKSpriteNode(imageNamed: "MosquitoDrawedDead")
                            
                            player.name = deadPredator.name
                            
                        }
                    }
                }
                
             //   print( self.physicsWorld.bodyAtPoint(location))
                
                
                if self.physicsWorld.bodyAtPoint(location)?.node!.name == "squirrel"{
                    selectedNode = physicsWorld.bodyAtPoint(location)?.node!  as! SKSpriteNode
                    let pos = selectedNode.position
                    
                    var newPos = CGPoint(x: pos.x, y: pos.y)
                    
                    newPos = self.boundLayerPos(newPos)
                    
                    selectedNode.removeAllActions()
                    
                    let moveTo = SKAction.moveTo(newPos, duration: 0.2)
                    
                    moveTo.timingMode = .EaseOut
                    
                    selectedNode.zPosition = 1
                    
                    let action = SKAction.fadeOutWithDuration(0.2)
                    
                    selectedNode.runAction(action)
                    
                    self.updateScoreWithValue(10)
                   // masterMonsterCount += 5
                    selectedNode.physicsBody = nil
                    
                }
                
                //print(self.physicsWorld.bodyAtPoint(location)?.node?.name)
                
               // if selectedNode.name == "predator"{
                if self.physicsWorld.bodyAtPoint(location)?.node!.name == "predator"{
                    
                     let touchedNodePhysicsBody = physicsWorld.bodyAtPoint(location)?.node!  as! SKSpriteNode
                    touchedNodePhysicsBody.name = "deadPredator"
                  
                   
                    // print("time to kill")
                    
                    if masterMonsterCount % 5 == 0 {
                        addMoreMonsters(2)
                    }

                    
                    
                    masterMonsterCount++
                    print(masterMonsterCount)
                    if masterMonsterCount % 25 == 0 {
                        
                        addBonusLabel("CATCH THE BONUS")
                        
                        self.addSquirrel()
                    }
                    if masterMonsterCount % 30 == 0 {
                        monsterSpeed -= 0.1
                    }
                    
//                    if points % 50 == 0 && masterMonsterCount > 10 {
//                        addBonusLabel("YOU MADE 50 KILLS")
//                    }
                    
                    // Remember me
                    //let pos = selectedNode.position
                    let pos = self.physicsWorld.bodyAtPoint(location)?.node!.position
                    var newPos = CGPoint(x: pos!.x, y: pos!.y)
                    
                    newPos = self.boundLayerPos(newPos)
                    
                   // selectedNode.removeAllActions()
                    self.physicsWorld.bodyAtPoint(location)?.node!.removeAllActions()
                    
                    let moveTo = SKAction.moveTo(newPos, duration: 0.2)
                    
                    moveTo.timingMode = .EaseOut
                    
                    
                    let splatSound = SKAction.playSoundFileNamed("splat.mp3", waitForCompletion: false)
                    
                    
                    //selectedNode.runAction(splatSound)
                    self.physicsWorld.bodyAtPoint(location)?.node!.runAction(splatSound)
                   // selectedNode.zPosition = 1
                    self.physicsWorld.bodyAtPoint(location)?.node!.zPosition = 1
                   // self.selectedNode.texture = SKTexture(imageNamed: "MosquitoDrawedDead")
                   
                    touchedNodePhysicsBody.texture = SKTexture(imageNamed: "MosquitoDrawedDead")
                    
                    
                    
                    let action =  SKAction.fadeOutWithDuration(0.2)
                    
                    //selectedNode.runAction(action)
                    self.physicsWorld.bodyAtPoint(location)?.node?.runAction(action)
                    self.updateScoreWithValue(1)
                  
                    //  print(points)
                   // selectedNode.removeAllActions()
                   // selectedNode.removeAllChildren()
                    touchedNodePhysicsBody.physicsBody = nil
                    UIView.animateWithDuration(0.07) {
                        
                        let killLabel = SKLabelNode(fontNamed: "Copperplate")
                        
                        killLabel.fontColor = SKColor.redColor()
                        
                        killLabel.fontSize = 10
                        
                        
                        // monster.position = CGPoint(x: random(-10.0,max: -30.0), y: random(10.0, max:30.0))
                        
                        killLabel.position = CGPoint(x: touchedNodePhysicsBody.position.x ,y: touchedNodePhysicsBody.position.y)
                        
                        
                        killLabel.text = "BANG!"
                        
                        killLabel.zPosition = 1
                        
                        self.addChild(killLabel)
                        
                        let actionFadeOut = SKAction.fadeOutWithDuration(NSTimeInterval(0.7))
                        killLabel.runAction(actionFadeOut)
                        
                        
                
                    }
                }
                
            }
                
            
            
            
            if pauseButton.containsPoint(location) {
                //This is where the action of the button is fired

                
                if pauseFlag {
                    
                    //pauseButton.texture = SKTexture(imageNamed: "pauseBtn")
                    pauseFlag = false
                    self.scene!.view?.paused = true
                   
                    
                }else {
                   // pauseButton.texture = SKTexture(imageNamed: "plyBtn")
                    pauseFlag = true
                    self.scene!.view?.paused = false
                }
               
            }
        }
       
    
    
    }
    
    func addBonusLabel(text: String){
        
        let bonusLabel = SKLabelNode(fontNamed: "Copperplate")
        
        bonusLabel.fontColor = SKColor.greenColor()
        
        bonusLabel.fontSize = 30
        
        bonusLabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) + 100)
        
        bonusLabel.text = text
        
        bonusLabel.zPosition = 1
        
        self.addChild(bonusLabel)
        
        //let action =  SKAction.fadeOutWithDuration(5)
        let action = SKAction.sequence([SKAction.fadeInWithDuration(0.3),SKAction.fadeOutWithDuration(0.3)])
       
        
         bonusLabel.runAction(SKAction.repeatAction(action, count: 3))

    }
    
    //Function fires when the flop is tapped
//
//    func tapped(gesture: UIGestureRecognizer){
//
//        var touchLocation = gesture.locationInView(gesture.view)
//
//        touchLocation = self.convertPointFromView(touchLocation)
//
//        //let touchedNode = self.nodeAtPoint(CGPoint(x:(touchLocation.x), y: touchLocation.y))
//        
//        let touchedNodeArray = self.nodesAtPoint(touchLocation)
//       // let touchedNode = self.nodeAtPoint(touchLocation)
//        
//        for child in touchedNodeArray {
//            // ...
//           // print(child)
//            
//            
//            if child is SKSpriteNode {
//                
//                if !selectedNode.isEqual(child) {
//                    
//                    selectedNode = child as! SKSpriteNode
//                    
//                    if child.name == predatorNodeName{
//                       
//                        let deadPredator = SKSpriteNode(imageNamed: "MosquitoDrawedDead")
//                        
//                        player.name = deadPredator.name
//                        
//                    }
//                }
//            }
//            
//            
//            //  print(selectedNode.name)
//            
//            if selectedNode.name == "squirrel"{
//                
//                let pos = selectedNode.position
//                
//                var newPos = CGPoint(x: pos.x, y: pos.y)
//                
//                newPos = self.boundLayerPos(newPos)
//                
//                selectedNode.removeAllActions()
//                
//                let moveTo = SKAction.moveTo(newPos, duration: 0.2)
//                
//                moveTo.timingMode = .EaseOut
//                
//                selectedNode.zPosition = 1
//                
//                let action = SKAction.fadeOutWithDuration(0.2)
//                
//                selectedNode.runAction(action)
//                
//                self.updateScoreWithValue(10)
//                
//                
//            }
//            
//            if selectedNode.name == "predator"{
//                
//                selectedNode.name = "deadPredator"
//             
//                
//                // print("time to kill")
//                if masterMonsterCount % 3 == 0 {
//                    addMoreMonsters(3)
//                }
//                
////                if masterMonsterCount % 25 == 0 {
////                    runAction(SKAction.repeatAction(masterOfPuppets, count: 1))
////                }
//                
//                masterMonsterCount++
//                
//                if masterMonsterCount % 15 == 0 {
//                    
//                    let bonusLabel = SKLabelNode(fontNamed: "Copperplate")
//                    
//                    bonusLabel.fontColor = SKColor.greenColor()
//                    
//                    bonusLabel.fontSize = 30
//                    
//                    bonusLabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) + 100)
//                    
//                    bonusLabel.text = "CATCH THE BONUS"
//                    
//                    bonusLabel.zPosition = 1
//                    
//                    self.addChild(bonusLabel)
//                    
//                    let action =  SKAction.fadeOutWithDuration(5)
//                    
//                    bonusLabel.runAction(action)
//                    
//                    addSquirrel()
//                    
//                    
//                }
//                
//                // Remember me
//                let pos = selectedNode.position
//                
//                var newPos = CGPoint(x: pos.x, y: pos.y)
//                
//                newPos = self.boundLayerPos(newPos)
//                
//                selectedNode.removeAllActions()
//                
//                let moveTo = SKAction.moveTo(newPos, duration: 0.2)
//                
//                moveTo.timingMode = .EaseOut
//                
//                
//                let splatSound = SKAction.playSoundFileNamed("splat.mp3", waitForCompletion: false)
//                
//                selectedNode.runAction(splatSound)
//                
//                selectedNode.zPosition = 1
//                
//                self.selectedNode.texture = SKTexture(imageNamed: "MosquitoDrawedDead")
//                
//                
//                
//                let action =  SKAction.fadeOutWithDuration(0.2)
//                
//                selectedNode.runAction(action)
//                
//                self.updateScoreWithValue(1)
//                
//                //  print(points)
//                
//                UIView.animateWithDuration(0.07) {
//                    
//                    let killLabel = SKLabelNode(fontNamed: "Copperplate")
//                    
//                    killLabel.fontColor = SKColor.redColor()
//                    
//                    killLabel.fontSize = 10
//                    
//                    
//                    // monster.position = CGPoint(x: random(-10.0,max: -30.0), y: random(10.0, max:30.0))
//                    
//                    killLabel.position = CGPoint(x: self.selectedNode.position.x ,y: self.selectedNode.position.y)
//                    
//                    
//                    killLabel.text = "BANG!"
//                    
//                    killLabel.zPosition = 1
//                    
//                    self.addChild(killLabel)
//                    
//                    let actionFadeOut = SKAction.fadeOutWithDuration(NSTimeInterval(0.7))
//                    killLabel.runAction(actionFadeOut)
//                    
//                    
//                }
//                
//                
//            }
//        } //for loop through all nodes ends here
//       
//        
//    }

  
    func updateScoreWithValue (value: Int) {
        
        points += value
        
        myLabel.text = "Kills: \(points)"
        
        if points > highscore {
            highscore = points
            highScoreDefaults.setValue(highscore, forKey: "highscore")
            highScoreDefaults.synchronize()
            highScoreLabel.text = "High Score: \(highscore)"
        }

    }
    
//    func degToRad(degree: Double) -> CGFloat {
//        
//        return CGFloat(degree / 180.0 * M_PI)
//        
//    }

//    old selectedNodeForTouch function
//    func selectNodeForTouch(touchLocation : CGPoint) {
//        // 1
//        let touchedNode = self.nodeAtPoint(touchLocation)
//        
//        if touchedNode is SKSpriteNode {
//            // 2
//            if !selectedNode.isEqual(touchedNode) {
//                
//                //selectedNode.removeAllActions()
//                
//                //selectedNode.runAction(SKAction.rotateToAngle(3.14/4, duration: 4))
//                
//                selectedNode = touchedNode as! SKSpriteNode
//                
//                // 3
//                if touchedNode.name == kAnimalNodeName {
//                
//                    let sequence = SKAction.sequence([SKAction.rotateByAngle(degToRad(-4.0), duration: 0.1),
//                        
//                        SKAction.rotateByAngle(0.0, duration: 0.1),
//                        
//                        SKAction.rotateByAngle(degToRad(4.0), duration: 0.1)])
//                    selectedNode.runAction(SKAction.repeatActionForever(sequence))
//                
//                }else if touchedNode.name == predatorNodeName{
//                    
//                    let deadPredator = SKSpriteNode(imageNamed: "MosquitoDrawedDead")
//                    print("hit the spot")
//                    player.name = deadPredator.name
//                   
//
//              
//                }else if touchedNode.name == background.name{
//                    
//                    print("you missed")
//                }
//            }
//        }
//    }
    
    
    func boundLayerPos(aNewPosition : CGPoint) -> CGPoint {
        let winSize = self.size
        var retval = aNewPosition
        retval.x = CGFloat(min(retval.x, 0))
        retval.x = CGFloat(max(retval.x, -(background.size.width) + winSize.width))
        retval.y = self.position.y
        
        return retval
    }
    
    /* Let's sum up what's going on here.
    We have the monster which is our predator node, flying in a linear line going to the nowhere of the screen.
    Then we added monsterTwo , which does exactly the same thing as monster, but instead flying straight, it does the osscilation and spawns from different places.
    We also have actions for the sound.
    */
func addSquirrel() {

    let bonusSound = SKAction.playSoundFileNamed("bonusSoundMyBed.mp3", waitForCompletion: false)
    
    self.runAction(bonusSound)
    
    let squirrel = SKSpriteNode(imageNamed: "flyingSquirrel")
    
    squirrel.name = "squirrel"
    
    squirrel.zPosition = 1
    
    squirrel.setScale(0.8)
    
    squirrel.position = CGPoint(x: random(-10.0,max: -30.0), y: random(10.0, max:30.0))
    squirrel.physicsBody = SKPhysicsBody(circleOfRadius: 45.0)
   
    addChild(squirrel)
    squirrel.physicsBody?.dynamic = false
    squirrel.physicsBody?.affectedByGravity = false
    squirrel.physicsBody?.affectedByGravity = false
    squirrel.physicsBody?.allowsRotation = false
    //let actualDuration = 4.0
    
    
    let actionMoveTo = SKAction.moveTo(CGPoint(x: random(500, max:800),y: random(1, max:800) ), duration: NSTimeInterval(monsterSpeed))
    
    
    squirrel.runAction(actionMoveTo,withKey: "move")

}
    
    
    
func addMonster() {
        
        // Create sprite
        //let monster = SKSpriteNode(imageNamed: "MosquitoFlipped")
    
    
       let monster = SKSpriteNode(imageNamed: "MosquitoDrawed")
       // let monsterTexture = SKTexture(imageNamed: "MosquitoDrawed")
       // let monster = SKPhysicsBody(texture: monsterTexture, size: CGSize(width: 40.0, height: 40.0))
    
    
    monster.setScale(1.2)
        monster.name = predatorNodeName
        //  monster.name = kAnimalNodeName
        monster.zPosition = 1
//        monster.physicsBody?.applyForce(CGVector(dx: 2.0, dy: 2.0))
//        monster.physicsBody?.applyTorque(5.0)
       // print(monster.physicsBody)
    
    //monster.physicsBody!.affectedByGravity = true self.character.physicsBody = SKPhysicsBody(texture: firstFrame, size: characterSize)
    //monster.physicsBody
   //
 
        monster.physicsBody = SKPhysicsBody(circleOfRadius: 35.0)
        //print(monster.physicsBody!.area)
        //monster.physicsBody!.usesPreciseCollisionDetection = true
        //print(monster.physicsBody)
    // or if you specifically want to adjust around the image, instead use button.imageEdgeInsetsimageEdgeInsets
//            var timer = NSTimer.scheduledTimerWithTimeInterval(0.2, target: self, selector: "doAction", userInfo: nil, repeats: true)
//        
//        
    
       // monster.position = CGPoint(x: random(-10.0,max: -30.0), y: random(10.0, max:130.0))
    monster.position = CGPoint(x: -10.0,y:random(10.0, max:300.0))
        addChild(monster)
    
      monster.physicsBody?.dynamic = false
    monster.physicsBody?.affectedByGravity = false
    monster.physicsBody?.affectedByGravity = false
    monster.physicsBody?.allowsRotation = false
   // print(monster.physicsBody)
    
        //print(monster)
         //   var cool = monster.anchorPoint.x
       // monster.anchorPoint = CGPoint(x: 40.0,y: 40.0)
        // Determine speed of the monster
       // let actualDuration = 4.0
        
       // let action4 = SKAction.playSoundFileNamed("mosquitoFly.mp3",  waitForCompletion: false)
  
        
        //this action makes them move out of the screen !
       // let actionMoveTo = SKAction.moveTo(CGPoint(x: random(500, max:800),y: random(1, max:800) ), duration: NSTimeInterval(actualDuration))
    let actionMoveTo = SKAction.moveTo(CGPoint(x: 1200.0,y: random(100.0,max:300.0)), duration: NSTimeInterval(monsterSpeed * 2))
    
        monster.runAction(actionMoveTo,withKey: "move")
       //monster.runAction(actionFadeOut)
       // monster.runAction(action4,withKey: "bzz")
    
    //monster.runAction(SKAction.sequence([action4,actionMoveTo]), withKey: "actionA")
    
    // monster.runAction(action5)
    
        //hiding a node
          //  monster.runAction(tempActionHide)

        // monster = SKSpriteNode(imageNamed: "MosquitoDrawedDead")
    
    if(time < 10){
        
        timerLabel.fontColor = SKColor.redColor()
        
    }
    
    // Lose situation
//    if(time < 1){
////that doesen't work ?
//        
////        monster.removeActionForKey("move")
////        monster.removeActionForKey("bzz")
//       
//            
//            timer.invalidate()
//        let reveal = SKTransition.flipHorizontalWithDuration(0.5)
//        let gameOverScene = GameOverScene(size: self.size, won: false)
//        self.view?.presentScene(gameOverScene, transition: reveal)
//        
//    }
    // Win situation
//    
//    if (points > 50) {
//        //removeAllActions()
//        //not working ?
////        monster.removeActionForKey("move")
////        monster.removeActionForKey("bzz")
////        
//        timer.invalidate()
//        let reveal = SKTransition.flipHorizontalWithDuration(0.5)
//        let gameOverScene = GameOverScene(size: self.size, won: true)
//        self.view?.presentScene(gameOverScene, transition: reveal)
//    }

    
    
    }
 
    func addMonsterTwo() {
       
        // This One Osscilates !
      //  let size = CG
      //  let texture = SKTexture(imageNamed: "MosquitoDrawed")
        let monsterTwo = SKSpriteNode(imageNamed: "MosquitoDrawed")
        monsterTwo.name = predatorNodeName
        monsterTwo.zPosition = 1
        //monsterTwo.physicsBody = SKPhysicsBody(circleOfRadius: 50.0)

        monsterTwo.setScale(1.2)
        monsterTwo.position = CGPoint(x: -10.0, y: random(50.0,max: 300.0))
        //        // NEG
        //
        //        monster.position = CGPoint(x: random(600.0,max: 700.0), y: random(50.0,max: 200.0))
        //
        //        //
        
        
        let oscillate = SKAction.oscillation(amplitude: amplitude, timePeriod: 1, midPoint: monsterTwo.position)
        // let oscillateNeg = SKAction.oscillation(amplitude: -amplitude, timePeriod: 1, midPoint: monster.position)
        
//        if(amplitude >= 80.0){
//            amplitude = amplitude - 20.0
//        }
        
        //
        
        // Determine where to spawn the monster along the Y axis
        // let actualY = random(monster.size.height/2, monster.size.height - monster.size.height/2)
        
        // Position the monster slightly off-screen along the right edge,
        // and along a random position along the Y axis as calculated above
        //monster.position = CGPoint(x: 10.0, y: 100.0)
        
        // Add the monster to the scene
        
        monsterTwo.physicsBody = SKPhysicsBody(circleOfRadius: 35.0)
        addChild(monsterTwo)
        monsterTwo.physicsBody?.dynamic = false
        monsterTwo.physicsBody?.affectedByGravity = false
        monsterTwo.physicsBody?.affectedByGravity = false
        monsterTwo.physicsBody?.allowsRotation = false
        
        //before doing osscilation that was uncommented
        // player.position = monster.position
        
        // Determine speed of the monster
        //let actualDuration = 4.0
        
        // Create the actions
        
        // _ = SKAction.moveToY(200.0, duration: NSTimeInterval(actualDuration))
        // let actionmoveTo = SKAction.moveToX(600.0, duration: NSTimeInterval(actualDuration))
        //  let actionMoveToY = SKAction.moveToY(120.0, duration: NSTimeInterval(actualDuration))
        
        //  let actionFadeOut = SKAction.fadeOutWithDuration(NSTimeInterval(actualDuration))
        //var tempActionHide = SKAction.hide()
        //  var action2 = SKAction.colorizeWithColor(UIColor.redColor(), colorBlendFactor: CGFloat(20.0), duration: NSTimeInterval(actualDuration))
        
      
        //let action5 = SKAction.rotateByAngle(CGFloat(2*M_PI),duration: NSTimeInterval(actualDuration))
        
        //let actionMoveDone = SKAction.removeFromParent()
        
        
        //Action letting me to move the monster to a CGPoint
        // in this case the action makes them move to somewhere in the screen
        // let actionMoveTo = SKAction.moveTo(CGPoint(x: random(500, max:100),y: random(1, max:400) ), duration: NSTimeInterval(actualDuration))
        
        //this action makes them move out of the screen !
        //let actionMoveTo = SKAction.moveTo(CGPoint(x: random(500, max:800),y: random(1, max:800) ), duration: NSTimeInterval(actualDuration))
         let actionMoveTo = SKAction.moveTo(CGPoint(x: 1200.0,y: random(100.0,max:300.0)), duration: NSTimeInterval(monsterSpeed * 2))
        
        //let actionMoveToNeg = SKAction.moveTo(CGPoint(x: random(-500, max:-800),y: random(-1, max:-800) ), duration: NSTimeInterval(actualDuration))
        //
        
        //monster.runAction(SKAction.sequence([actionMove, actionMoveDone]))
        //monster.runAction(actionMove)
        //        monster.runAction(actionMove2)
        //        monster.runAction(actionMove3)
       
        //oscc
        monsterTwo.runAction(actionMoveTo)
        //end
        //monster.runAction(actionFadeOut)
  
        // monster.runAction(action5)
        
        // osc
        monsterTwo.runAction(SKAction.repeatAction(oscillate, count: 8))
        
        
        //hiding a node
        //  monster.runAction(tempActionHide)
        
        // monster = SKSpriteNode(imageNamed: "MosquitoDrawedDead")
    }
    

    
func WithAmplitude(amplitude amp: CGFloat,frequency freq:CGFloat,width:CGFloat,centered:Bool,andNumPoints numPoints:CGFloat) -> CGMutablePathRef{
     
        
        let path: CGMutablePathRef = CGPathCreateMutable()
        CGPathMoveToPoint(path, nil, 0.0 , 0.0)
        let xIncr: CGFloat = 2.0
        let counter:Int = Int(numPoints)
        for i in 1..<counter {
            let yC = amp * sin(CGFloat(i) * π * 2.0 / 100.0)
            CGPathAddLineToPoint(path, nil, CGFloat(i)*xIncr-2.5, yC+15.0);
        }
        
        return path
    }

}



extension SKAction {
    static func oscillation(amplitude a: CGFloat, timePeriod t: CGFloat, midPoint: CGPoint) -> SKAction {
        let action = SKAction.customActionWithDuration(Double(t)) { node, currentTime in
            let displacement = a * sin(2 * π * currentTime / t)
            node.position.y = midPoint.y + displacement
        }
        
        return action
    }
}


func random() -> CGFloat {
    return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
}

func random(min: CGFloat, max: CGFloat) -> CGFloat! {
    return random() * (max - min) + min
}

// Ray Wrendlich