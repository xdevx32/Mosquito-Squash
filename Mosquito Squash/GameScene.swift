//
//  GameScene.swift
//  Mosquito Squash
//
//  Created by Angel Kukushev on 9/16/15.
//  Copyright (c) 2015 xdevx332. All rights reserved.
//
import SpriteKit
import CoreGraphics
import AVFoundation

private let kAnimalNodeName = "movable"

private let predatorNodeName = "predator"

private let roomNodeName = "roomBackground"

private var points = 0

private var lives = 7

var bossCnt = 0

var highscore = 1

let highScoreDefaults:NSUserDefaults? = NSUserDefaults.standardUserDefaults()

//var pauseButton: SKSpriteNode! = nil

var pauseFlag: Bool = true

var flopPosition = CGPoint(x:0 ,y:0)

var monsterSpeed = 4.0

let π = CGFloat(M_PI)

var amplitude: CGFloat = 30.0

var timer = NSTimer()

var time = 30

var backgroundMusicURL = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("msBackgroundMusic", ofType: "wav")!)
var backgroundMusicPlayer = AVAudioPlayer()


var bonusMusicURL = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("bonusSoundMyBed", ofType: "mp3")!)
var bonusMusicPlayer = AVAudioPlayer()

var splatSoundURL = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("splat", ofType: "mp3")!)
var splatSoundPlayer = AVAudioPlayer()

var masterMonsterCount: Int = 2

let backgroundMusic = SKAction.playSoundFileNamed("msBackgroundMusic.wav",  waitForCompletion: true)

let splatSound = SKAction.playSoundFileNamed("splat.mp3", waitForCompletion: true)

let myLabel = SKLabelNode(fontNamed: "Copperplate")

let livesLabel = SKLabelNode(fontNamed: "Copperplate")

let highScoreLabel = SKLabelNode(fontNamed: "Copperplate")

let timerLabel = SKLabelNode(fontNamed: "Copperplate")

class GameScene: SKScene {
    
    var deadMosquito = SKTexture()
    
    let player = SKSpriteNode(imageNamed: "komarche1")
    
    let background = SKSpriteNode(imageNamed: "roomScaled4sB&W2")
 
    var selectedNode = SKSpriteNode()
  
    override init(size: CGSize) {
        
        super.init(size: size)
        
        background.name = "background"
        
        self.background.anchorPoint = CGPointZero
        
        background.zPosition = 0
        
        background.size = self.frame.size
        
        self.addChild(background)
        /*
        let imageNames = ["MosquitoDrawedDead","flipFlop","MosquitoDrawed"]
     
        for i in 0..<imageNames.count {
            
            let imageName = imageNames[i]
            
            let spriteFlop = SKSpriteNode(imageNamed: imageName)
            
            spriteFlop.name = kAnimalNodeName
            
        }
        */
        do {
            try backgroundMusicPlayer = AVAudioPlayer(contentsOfURL: backgroundMusicURL)
            backgroundMusicPlayer.prepareToPlay()
            
            //try bonusMusicPlayer = AVAudioPlayer(contentsOfURL: bonusMusicURL)
            //bonusMusicPlayer.prepareToPlay()
            
            try splatSoundPlayer = AVAudioPlayer(contentsOfURL: splatSoundURL)
            splatSoundPlayer.prepareToPlay()
        }
        catch {
            print("Something bad happened. Try catching specific errors to narrow things down")
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
  
    func decreaseTimer() {
        
        time -= 1
        
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
                        lives -= 1
                        livesLabel.text = "Lives: \(lives)"
                        if lives <= 0{
                            lives = 7
                            
                            let reveal = SKTransition.flipHorizontalWithDuration(0.5)
                            let gameOverScene = GameOverScene(size: self.size, won: false,points: points,highscore: highscore)
                            self.view?.presentScene(gameOverScene, transition: reveal)
                            
                            self.scene?.removeAllChildren()
                            self.scene?.removeAllActions()
                            self.scene?.removeFromParent()
                           
                            points = 0
                        }
        
                }
            }
        }
        
    }
    override func didMoveToView(view: SKView) {
        
 
        
    
        if(highScoreDefaults!.valueForKey("highscore") != nil){
            highscore = highScoreDefaults!.valueForKey("highscore") as! Int
        }else{
            print("nil")
        }
   
       //runAction(SKAction.repeatAction(backgroundMusic, count: 40))
        backgroundMusicPlayer.play()
        backgroundMusicPlayer.numberOfLoops = -1 // infinite playback loop
        
        runAction(SKAction.stop())

        
       // pauseButton = SKSpriteNode(imageNamed: "pauseBtn")
        
        print(CGRectGetMaxX(self.frame))
      //  pauseButton.position = CGPoint(x:CGRectGetMaxX(self.frame) - 20 ,y:self.view!.frame.maxY - 20.0)
        //pauseButton.zPosition = 1
     //   self.addChild(pauseButton)
        

        
        myLabel.fontColor = SKColor.blackColor()
        
        myLabel.fontSize = 20
       
             myLabel.position = CGPointMake(CGRectGetMinX(self.frame) + 60 ,self.view!.frame.maxY - 20.0)
        myLabel.text = "Kills: \(points)"
        
        myLabel.zPosition = 1
        
        self.addChild(myLabel)
        //high score label
        
        highScoreLabel.fontColor = SKColor.blackColor()
        
        highScoreLabel.fontSize = 10
        
                highScoreLabel.position = CGPointMake(CGRectGetMinX(self.frame) + 70 ,self.view!.frame.maxY - 40.0)
        highScoreLabel.text = "High Score: \(highscore)"
        
        highScoreLabel.zPosition = 1
        
        self.addChild(highScoreLabel)
      
        livesLabel.fontColor = SKColor.blackColor()
        
        livesLabel.fontSize = 20
        
        livesLabel.position = CGPointMake(myLabel.position.x + 90.0, self.view!.frame.maxY - 20.0)
        
        livesLabel.text = "Lives: \(lives)"
        
        livesLabel.zPosition = 1
        
        self.addChild(livesLabel)

        
        func fibonacciNumber(n: Int) -> Int{
            if n == 1 {
                return 1
            }
            if n == 2 {
                return 1
            }
            
            return fibonacciNumber(n - 1) + fibonacciNumber(n - 2)
        }
        
  
          let actionSequence = SKAction.sequence([SKAction.waitForDuration(4),SKAction.runBlock(addMonster)])
          let secondActionSequence = SKAction.sequence([SKAction.waitForDuration(2.5),SKAction.runBlock(addMonsterTwo)])
   
         runAction(SKAction.repeatAction(actionSequence, count: 400))
         runAction(SKAction.repeatAction(secondActionSequence, count: 400))
        
        

    }
    
    func addMoreMonsters(functionCount: Int){
        let actionSequence = SKAction.sequence([SKAction.waitForDuration(4),SKAction.runBlock(addMonster),SKAction.waitForDuration(4),SKAction.runBlock(addMonsterTwo)])
        runAction(SKAction.repeatAction(actionSequence, count: functionCount))
    }


override func touchesBegan(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        for touchObject in touches! {
            
          
            
            let touch = touchObject as UITouch
           
          
            let location = touch.locationInNode(self)
          
            let touchedNodeArray = self.nodesAtPoint(location)
            
     
            
            for child in touchedNodeArray {
                if child is SKSpriteNode {
                    
          
                    if ((self.physicsWorld.bodyAtPoint(location)?.node!.isEqual(child)) == nil) {
                
                        
                        if child.name == predatorNodeName{
                            
                            let deadPredator = SKSpriteNode(imageNamed: "MosquitoDrawedDead")
                            
                            player.name = deadPredator.name
                            
                        }
                    }
                }
                
                
                if self.physicsWorld.bodyAtPoint(location)?.node!.name == "boss"{
                    selectedNode = physicsWorld.bodyAtPoint(location)?.node!  as! SKSpriteNode
                    let pos = selectedNode.position
                    
                    var newPos = CGPoint(x: pos.x, y: pos.y)
                    
                    newPos = self.boundLayerPos(newPos)
                    
                    selectedNode.removeAllActions()
                    
                    let moveTo = SKAction.moveTo(newPos, duration: 0.2)
                    
                    moveTo.timingMode = .EaseOut
                    
                    selectedNode.zPosition = 1
                   
                    bossCnt == bossCnt + 1
                    
                        let action = SKAction.fadeOutWithDuration(1.0)
                    
                    let VECTOR = CGVector(dx: pos.x, dy: pos.y)
                    
                        let another = SKAction.applyForce(VECTOR, atPoint: newPos, duration: 0.5)
                    
                        selectedNode.runAction(another)
                        selectedNode.runAction(action)
                        
                        self.updateScoreWithValue(20)
                        
                        selectedNode.physicsBody = nil
            
                    
                }
                
                
                
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
                  
                    selectedNode.physicsBody = nil
                    
                }
                
                if self.physicsWorld.bodyAtPoint(location)?.node!.name == "predator"{
                    
                     let touchedNodePhysicsBody = physicsWorld.bodyAtPoint(location)?.node!  as! SKSpriteNode
                    touchedNodePhysicsBody.name = "deadPredator"
                  
                   
                    if masterMonsterCount % 5 == 0 {
                        addMoreMonsters(2)
                    }

                    
                    
                    masterMonsterCount += 1
                    print(masterMonsterCount)
                    if masterMonsterCount % 25 == 0 {
                        
                        addBonusLabel("CATCH THE BONUS")
                        
                        self.addSquirrel()
                    }
                    if masterMonsterCount % 40 == 0 {
                        addBossLabel("Oh noo...")
                        
                        self.addBoss()
                    }
                    
                 
                    if masterMonsterCount % 30 == 0 {
                        monsterSpeed -= 0.1
                    }
                    

                    let pos = self.physicsWorld.bodyAtPoint(location)?.node!.position
                    var newPos = CGPoint(x: pos!.x, y: pos!.y)
                    
                    newPos = self.boundLayerPos(newPos)
                    
                    self.physicsWorld.bodyAtPoint(location)?.node!.removeAllActions()
                    
                    let moveTo = SKAction.moveTo(newPos, duration: 0.2)
                    
                    moveTo.timingMode = .EaseOut
                    
                    
               
                    
                    //self.runAction(splatSound)
                    
                    if (splatSoundPlayer.playing) {
                        splatSoundPlayer.stop()
                        splatSoundPlayer.play()
                    }
                    else {
                        splatSoundPlayer.play()
                    }
                    
                    self.physicsWorld.bodyAtPoint(location)?.node!.zPosition = 1
               
                    let action =  SKAction.fadeOutWithDuration(0.2)
                    
                    self.physicsWorld.bodyAtPoint(location)?.node?.runAction(action)
                    self.updateScoreWithValue(1)
                  
                    touchedNodePhysicsBody.physicsBody = nil
                    UIView.animateWithDuration(0.07) {
                        
                        let killLabel = SKLabelNode(fontNamed: "Copperplate")
                        
                        killLabel.fontColor = SKColor.redColor()
                        
                        killLabel.fontSize = 10
                        
                        
                       
                        killLabel.position = CGPoint(x: touchedNodePhysicsBody.position.x ,y: touchedNodePhysicsBody.position.y)
                        
                        
                        killLabel.text = "BANG!"
                        
                        killLabel.zPosition = 1
                        
                        self.addChild(killLabel)
                        
                        let actionFadeOut = SKAction.fadeOutWithDuration(NSTimeInterval(0.7))
                        killLabel.runAction(actionFadeOut)
                        
                        
                
                    }
                }
                
            }
                
            
            
           /*
            if pauseButton.containsPoint(location) {
     

                
                if pauseFlag {
                    
                    pauseFlag = false
                    self.scene!.view?.paused = true
                  
                    
                   
                    
                }else {
                    pauseFlag = true
                    self.scene!.view?.paused = false
                    
                }
               
            }
             */
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
        
                let action = SKAction.sequence([SKAction.fadeInWithDuration(0.3),SKAction.fadeOutWithDuration(0.3)])
       
        
         bonusLabel.runAction(SKAction.repeatAction(action, count: 3))

    }
    func addBossLabel(text: String){
        
        let bonusLabel = SKLabelNode(fontNamed: "Copperplate")
        
        bonusLabel.fontColor = SKColor.redColor()
        
        bonusLabel.fontSize = 30
        
        bonusLabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) + 50)
        
        bonusLabel.text = text
        
        bonusLabel.zPosition = 1
        
        self.addChild(bonusLabel)
        
        let action = SKAction.sequence([SKAction.fadeInWithDuration(0.3),SKAction.fadeOutWithDuration(0.3)])
        
        
        bonusLabel.runAction(SKAction.repeatAction(action, count: 3))
        
    }


  
    func updateScoreWithValue (value: Int) {
        
        points += value
        
        myLabel.text = "Kills: \(points)"
        
        if points > highscore {
            highscore = points
            highScoreDefaults!.setValue(highscore, forKey: "highscore")
            highScoreDefaults!.synchronize()
            highScoreLabel.text = "High Score: \(highscore)"
        }

    }
    

    func boundLayerPos(aNewPosition : CGPoint) -> CGPoint {
        let winSize = self.size
        var retval = aNewPosition
        retval.x = CGFloat(min(retval.x, 0))
        retval.x = CGFloat(max(retval.x, -(background.size.width) + winSize.width))
        retval.y = self.position.y
        
        return retval
    }

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
   
    
    let actionMoveTo = SKAction.moveTo(CGPoint(x: random(500, max:800),y: random(1, max:800) ), duration: NSTimeInterval(monsterSpeed))
    
    
    squirrel.runAction(actionMoveTo,withKey: "move")

}
    
func addBoss() {
    
    let boss = SKSpriteNode(imageNamed: "2000px-Mosquito_female")
    
    let bossSound = SKAction.playSoundFileNamed("bossSound.mp3", waitForCompletion: false)
    
    self.runAction(bossSound)
    
    boss.name = "boss"
    
    boss.zPosition = 1
    
    boss.setScale(10.1)
    
    boss.position = CGPoint(x: random(-10.0,max: -30.0), y: random(10.0, max:30.0))
    boss.physicsBody = SKPhysicsBody(circleOfRadius: 55.0)
    boss.setScale(0.789765)
    addChild(boss)
    boss.physicsBody?.dynamic = false
    boss.physicsBody?.affectedByGravity = false
    boss.physicsBody?.affectedByGravity = false
    boss.physicsBody?.allowsRotation = false
  
    let actionMoveTo = SKAction.moveTo(CGPoint(x: 1000,y: 500), duration: NSTimeInterval(monsterSpeed*7))
    
    // asdddddd
    boss.runAction(actionMoveTo)
    
}
    

    
    
func addMonster() {
        
  
    
       let monster = SKSpriteNode(imageNamed: "komarche1")

    
        //monster.setScale(0.7)
        monster.name = predatorNodeName

        monster.zPosition = 1

 
        monster.physicsBody = SKPhysicsBody(circleOfRadius: 35.0)

    monster.position = CGPoint(x: -10.0,y:random(10.0, max:300.0))
    monster.setScale(0.5)
        addChild(monster)
    
      monster.physicsBody?.dynamic = false
    monster.physicsBody?.affectedByGravity = false
    monster.physicsBody?.affectedByGravity = false
    monster.physicsBody?.allowsRotation = false

    let actionMoveTo = SKAction.moveTo(CGPoint(x: 1200.0,y: random(100.0,max:300.0)), duration: NSTimeInterval(monsterSpeed * 2))
    
        monster.runAction(actionMoveTo,withKey: "move")
      if(time < 10){
        
        timerLabel.fontColor = SKColor.redColor()
        
    }
    
    
    }
 
    func addMonsterTwo() {
        let monsterTwo = SKSpriteNode(imageNamed: "komarche2")
 
        monsterTwo.name = predatorNodeName
        monsterTwo.zPosition = 1
    
        //monsterTwo.setScale(0.7)
        monsterTwo.position = CGPoint(x: -10.0, y: random(50.0,max: 300.0))
             let oscillate = SKAction.oscillation(amplitude: amplitude, timePeriod: 1, midPoint: monsterTwo.position)
   
        monsterTwo.physicsBody = SKPhysicsBody(circleOfRadius: 35.0)
        addChild(monsterTwo)
        monsterTwo.physicsBody?.dynamic = false
        monsterTwo.physicsBody?.affectedByGravity = false
        monsterTwo.physicsBody?.affectedByGravity = false
        monsterTwo.physicsBody?.allowsRotation = false
               let actionMoveTo = SKAction.moveTo(CGPoint(x: 1200.0,y: random(100.0,max:300.0)), duration: NSTimeInterval(monsterSpeed * 2))
               monsterTwo.runAction(actionMoveTo)
                monsterTwo.runAction(SKAction.repeatAction(oscillate, count: 8))
        
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
