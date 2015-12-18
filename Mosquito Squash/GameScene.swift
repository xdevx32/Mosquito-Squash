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

var flopPosition = CGPoint(x:0 ,y:0)

// OSCILLATION VARS

let π = CGFloat(M_PI)

var amplitude: CGFloat = 20.0

var timer = NSTimer()

var time = 40

//



let myLabel = SKLabelNode(fontNamed: "Copperplate")

let timerLabel = SKLabelNode(fontNamed: "Copperplate")

class GameScene: SKScene {
    
    
    
    var deadMosquito = SKTexture()
    
    let player = SKSpriteNode(imageNamed: "MosquitoDrawed")
    let background = SKSpriteNode(imageNamed: "MosquitoSquashKidsRoom")
    //MosquitoSquashBackgroundBike
    var selectedNode = SKSpriteNode()
    override init(size: CGSize) {
        super.init(size: size)
        
        
                // tap gesture end
        
        // 1
        background.name = "background"
        self.background.anchorPoint = CGPointZero
        background.zPosition = 0
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
    
    override func didMoveToView(view: SKView) {
        // label code
        
        myLabel.fontColor = SKColor.blackColor()
        
        myLabel.fontSize = 25
        
        myLabel.position = CGPointMake(CGRectGetMidX(self.frame) - 160, CGRectGetMidY(self.frame) + 136)
        
        myLabel.text = "Points: \(points)"
        
        myLabel.zPosition = 1
        
        self.addChild(myLabel)
        
        //
        
        //timer Label
        
        timerLabel.fontColor = SKColor.blackColor()
        
        timerLabel.fontSize = 25
        
        timerLabel.position = CGPointMake(CGRectGetMidX(self.frame) - 160 , CGRectGetMidY(self.frame) + 100)
        
        timerLabel.text = "Time: \(time)"
        
        timerLabel.zPosition = 1
        
        self.addChild(timerLabel)
        
        //
        //play Timer
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("decreaseTimer"), userInfo: nil, repeats: true)
        
        //tap gesture
        
        let tap = UITapGestureRecognizer(target: self, action: "tapped:")
        self.view!.addGestureRecognizer(tap)
        
        
       
        //Adding the player
        addChild(player)
        
       // print(selectedNode.name)
        
        let actionSequence = SKAction.sequence([SKAction.runBlock(addMonster),SKAction.waitForDuration(0.9)])
        let secondActionSequence = SKAction.sequence([SKAction.runBlock(addMonsterTwo),SKAction.waitForDuration(2.3)])
        
        runAction(SKAction.repeatAction(actionSequence, count: 100))
        
        runAction(SKAction.repeatAction(secondActionSequence, count: 100))

        
    }
    //Function fires when the flop is tapped
   
    func tapped(gesture: UIGestureRecognizer){
        
        var touchLocation = gesture.locationInView(gesture.view)
        
        touchLocation = self.convertPointFromView(touchLocation)
        
        self.selectNodeForTouch(touchLocation)
        
        
        
        print(selectedNode.name)
        
        if selectedNode.name == "predator"{
            
            print("time to kill")
          
        
            let pos = selectedNode.position
            
            var newPos = CGPoint(x: pos.x + pos.x, y: pos.y + pos.y)
            
            newPos = self.boundLayerPos(newPos)
            
            selectedNode.removeAllActions()
            
            let moveTo = SKAction.moveTo(newPos, duration: 0.2)
            
            moveTo.timingMode = .EaseOut

            
            let splatSound = SKAction.playSoundFileNamed("splat.mp3", waitForCompletion: false)
            
            selectedNode.runAction(splatSound)
            
            selectedNode.zPosition = 1
            
            self.selectedNode.texture = SKTexture(imageNamed: "MosquitoDrawedDead")
            
            let action =  SKAction.fadeOutWithDuration(0.5)
            selectedNode.runAction(action)
            
            self.updateScoreWithValue(1)
            
            print(points)
            

        }
        
    }

  
    func updateScoreWithValue (value: Int) {
        
        points += value
        
        myLabel.text = "Points: \(points)"

    }
    
    func degToRad(degree: Double) -> CGFloat {
        
        return CGFloat(degree / 180.0 * M_PI)
        
    }
    
    func selectNodeForTouch(touchLocation : CGPoint) {
        // 1
        let touchedNode = self.nodeAtPoint(touchLocation)
        
        if touchedNode is SKSpriteNode {
            // 2
            if !selectedNode.isEqual(touchedNode) {
                
                selectedNode.removeAllActions()
                
                selectedNode.runAction(SKAction.rotateToAngle(0.0, duration: 0.1))
                
                selectedNode = touchedNode as! SKSpriteNode
                
                // 3
                if touchedNode.name == kAnimalNodeName {
                
                    let sequence = SKAction.sequence([SKAction.rotateByAngle(degToRad(-4.0), duration: 0.1),
                        
                        SKAction.rotateByAngle(0.0, duration: 0.1),
                        
                        SKAction.rotateByAngle(degToRad(4.0), duration: 0.1)])
                    selectedNode.runAction(SKAction.repeatActionForever(sequence))
                
                }else if touchedNode.name == predatorNodeName{
                    
                    let deadPredator = SKSpriteNode(imageNamed: "MosquitoDrawedDead")
                    print("hit the spot")
                    player.name = deadPredator.name
                   

              
                }else if touchedNode.name == background.name{
                    
                    print("you missed")
                }
            }
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
    
    /* Let's sum up what's going on here.
    We have the monster which is our predator node, flying in a linear line going to the nowhere of the screen.
    Then we added monsterTwo , which does exactly the same thing as monster, but instead flying straight, it does the osscilation and spawns from different places.
    We also have actions for the sound.
    */
func addMonster() {
        
        // Create sprite
        //let monster = SKSpriteNode(imageNamed: "MosquitoFlipped")
         if(time < 10){
         
            timerLabel.fontColor = SKColor.redColor()
         
         }
    
         if(time < 1){
            //removeAllActions()
            timer.invalidate()
            let reveal = SKTransition.flipHorizontalWithDuration(0.5)
            let gameOverScene = GameOverScene(size: self.size, won: false)
            self.view?.presentScene(gameOverScene, transition: reveal)
        
        }
    
    
        if (points > 30) {
            //removeAllActions()
            timer.invalidate()
            let reveal = SKTransition.flipHorizontalWithDuration(0.5)
            let gameOverScene = GameOverScene(size: self.size, won: true)
            self.view?.presentScene(gameOverScene, transition: reveal)
        }

    
    
        let monster = SKSpriteNode(imageNamed: "MosquitoDrawed")
        monster.name = predatorNodeName
        //  monster.name = kAnimalNodeName
        monster.zPosition = 1
    
//            var timer = NSTimer.scheduledTimerWithTimeInterval(0.2, target: self, selector: "doAction", userInfo: nil, repeats: true)
//        
//        
        monster.position = CGPoint(x: random(-10.0,max: -30.0), y: random(10.0, max:30.0))
    
        addChild(monster)
    
        // Determine speed of the monster
        let actualDuration = 4.0
        
               let action4 = SKAction.playSoundFileNamed("mosquitoFly.mp3", waitForCompletion: true)
    
        
        //this action makes them move out of the screen !
        let actionMoveTo = SKAction.moveTo(CGPoint(x: random(500, max:800),y: random(1, max:800) ), duration: NSTimeInterval(actualDuration))
    
    
        monster.runAction(actionMoveTo)
       //monster.runAction(actionFadeOut)
        monster.runAction(action4)
       // monster.runAction(action5)
    
        //hiding a node
          //  monster.runAction(tempActionHide)

        // monster = SKSpriteNode(imageNamed: "MosquitoDrawedDead")
    }
 
    func addMonsterTwo() {
       
        // This One Osscilates !
        let monsterTwo = SKSpriteNode(imageNamed: "MosquitoDrawed")
        monsterTwo.name = predatorNodeName
        monsterTwo.zPosition = 1
        
       
        monsterTwo.position = CGPoint(x: random(-40.0,max: -30.0), y: random(50.0,max: 200.0))
        //        // NEG
        //
        //        monster.position = CGPoint(x: random(600.0,max: 700.0), y: random(50.0,max: 200.0))
        //
        //        //
        
        
        let oscillate = SKAction.oscillation(amplitude: amplitude, timePeriod: 1, midPoint: monsterTwo.position)
        // let oscillateNeg = SKAction.oscillation(amplitude: -amplitude, timePeriod: 1, midPoint: monster.position)
        
        if(amplitude >= 80.0){
            amplitude = amplitude - 20.0
        }
        
        //
        
        // Determine where to spawn the monster along the Y axis
        // let actualY = random(monster.size.height/2, monster.size.height - monster.size.height/2)
        
        // Position the monster slightly off-screen along the right edge,
        // and along a random position along the Y axis as calculated above
        //monster.position = CGPoint(x: 10.0, y: 100.0)
        
        // Add the monster to the scene
       
        addChild(monsterTwo)
        
        
        //before doing osscilation that was uncommented
        // player.position = monster.position
        
        // Determine speed of the monster
        let actualDuration = 4.0
        
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
        let actionMoveTo = SKAction.moveTo(CGPoint(x: random(500, max:800),y: random(1, max:800) ), duration: NSTimeInterval(actualDuration))
        
        
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
        monsterTwo.runAction(SKAction.repeatAction(oscillate, count: 4))
        
        
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