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
    let background = SKSpriteNode(imageNamed: "roomScaled4s")
    var selectedNode = SKSpriteNode()
    override init(size: CGSize) {
        super.init(size: size)
        
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
            background.addChild(spriteFlop)
            
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    //Function for spawning nodes
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first {
            // ...
            print("\(touch.locationInNode(self))")
            
        }
        super.touchesBegan(touches, withEvent:event)
    }
    
            /* Called when a touch begins */
//
//            for touch in (touches as! Set<UITouch>) {
//                let location = touch.locationInNode(self)
//    
//                let sprite = SKSpriteNode(imageNamed:"MosquitoDrawedDead")
//    
//                sprite.position = location
//                self.addChild(sprite)
//    
//            
//                print("Touched")
//            }
//    }
//    

    

    func decreaseTimer() {
        
        time--
        
        timerLabel.text = "Time: \(time)"
        
        if (points > 30) {
            removeAllActions()
            timer.invalidate()
            let reveal = SKTransition.flipHorizontalWithDuration(0.5)
            let gameOverScene = GameOverScene(size: self.size, won: true)
            self.view?.presentScene(gameOverScene, transition: reveal)
        }
        
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
        
        
        
        let gestureRecognizer = UIPanGestureRecognizer(target: self, action: Selector("handlePanFrom:"))
       
        self.view!.addGestureRecognizer(gestureRecognizer)
        //Adding the player
        addChild(player)
        
        let actionSequence = SKAction.sequence([SKAction.runBlock(addMonster),SKAction.waitForDuration(0.9)])
        
        runAction(SKAction.repeatAction(actionSequence, count: 100))

        
    }
    //Function fires when the flop is touched.
   
       func handlePanFrom(recognizer : UIPanGestureRecognizer) {
       
        if recognizer.state == .Began {
        // JUST STARTED EDITING

            
            var touchLocation = recognizer.locationInView(recognizer.view)
            
            touchLocation = self.convertPointFromView(touchLocation)
            
            self.selectNodeForTouch(touchLocation)
            
        
            } else if recognizer.state == .Changed {
            
                var translation = recognizer.translationInView(recognizer.view!)
            
                translation = CGPoint(x: translation.x, y: -translation.y)
            
                self.panForTranslation(translation)
            
                recognizer.setTranslation(CGPointZero, inView: recognizer.view)
            
                } else if recognizer.state == .Ended {
            
                if selectedNode.name != kAnimalNodeName {
                
                let scrollDuration = 1.0
                
                print("Bang!")
                
                let velocity = recognizer.velocityInView(recognizer.view)
                
                let pos = selectedNode.position
                
                // This just multiplies your velocity with the scroll duration.
                let p = CGPoint(x: velocity.x * CGFloat(scrollDuration), y: velocity.y * CGFloat(scrollDuration))
                
                var newPos = CGPoint(x: pos.x + p.x, y: pos.y + p.y)
                
                newPos = self.boundLayerPos(newPos)
                
                selectedNode.removeAllActions()
                
                let moveTo = SKAction.moveTo(newPos, duration: scrollDuration)
                
                moveTo.timingMode = .EaseOut
                //selectedNode.runAction(moveTo)
                
                if selectedNode.name != background.name{
                    // You just hit a mosquito ! Horray.
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
        }
    }

    func updateScoreWithValue (value: Int) {
        points += value
        myLabel.text = "Points: \(points)"
//        if(points > 15){
//            myLabel.fontColor = SKColor.greenColor()
//        }
//        if (points > 40) {
//            removeAllActions()
//            let reveal = SKTransition.flipHorizontalWithDuration(0.5)
//            let gameOverScene = GameOverScene(size: self.size, won: true)
//            self.view?.presentScene(gameOverScene, transition: reveal)
//        }
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
//        if(time < 10){
//            timerLabel.fontColor = SKColor.redColor()
//        }
         if(time < 1){
            //removeAllActions()
            timer.invalidate()
            let reveal = SKTransition.flipHorizontalWithDuration(0.5)
            let gameOverScene = GameOverScene(size: self.size, won: false)
            self.view?.presentScene(gameOverScene, transition: reveal)
        
        }
    
    
        let monster = SKSpriteNode(imageNamed: "MosquitoDrawed")
        monster.name = predatorNodeName
        //  monster.name = kAnimalNodeName
        monster.zPosition = 1
    
           // self.addChild(monster)
        // This One Osscilates !
     //   let monsterTwo = SKSpriteNode(imageNamed: "MosquitoDrawed")
       // monsterTwo.name = predatorNodeName
       // monsterTwo.zPosition = 1
            
//            var timer = NSTimer.scheduledTimerWithTimeInterval(0.2, target: self, selector: "doAction", userInfo: nil, repeats: true)
//        
//        
        
        // SOME OSSCILATION CODE
        
        //before doing osscilation that was uncommented
        // player.position = monster.position
       // monsterTwo.position = CGPoint(x: random(-40.0,max: -30.0), y: random(50.0,max: 200.0))
//        // NEG
//    
//        monster.position = CGPoint(x: random(600.0,max: 700.0), y: random(50.0,max: 200.0))
//    
//        //
        monster.position = CGPoint(x: random(-10.0,max: -30.0), y: random(10.0, max:30.0))
        
      //  let oscillate = SKAction.oscillation(amplitude: amplitude, timePeriod: 1, midPoint: monsterTwo.position)
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
        addChild(monster)
       // addChild(monsterTwo)
        
        
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
        
        let action4 = SKAction.playSoundFileNamed("mosquitoFly.mp3", waitForCompletion: false)
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
        monster.runAction(actionMoveTo)
    //oscc
       // monsterTwo.runAction(actionMoveTo)
    //end
    //monster.runAction(actionFadeOut)
        monster.runAction(action4)
       // monster.runAction(action5)
    
    //osc
    //  monsterTwo.runAction(SKAction.repeatAction(oscillate, count: 4))

        
        //hiding a node
          //  monster.runAction(tempActionHide)

        // monster = SKSpriteNode(imageNamed: "MosquitoDrawedDead")
    }
    
    func panForTranslation(translation : CGPoint) {
        let position = selectedNode.position
        
        if selectedNode.name! == kAnimalNodeName {
            selectedNode.position = CGPoint(x: position.x + translation.x, y: position.y + translation.y)
            
//         code for killing a mosquito
//            print("kAnimalNodeName selected")
//            // You just hit a mosquito ! Horray.
//            let splatSound = SKAction.playSoundFileNamed("splat.mp3", waitForCompletion: false)
//            selectedNode.runAction(splatSound)
//            selectedNode.zPosition = 1
//            self.selectedNode.texture = SKTexture(imageNamed: "MosquitoDrawedDead")
//            let action =  SKAction.fadeOutWithDuration(0.5)
//            selectedNode.runAction(action)
//            
//            self.updateScoreWithValue(1)
//            print(points)
//
//            
            
            //
        } else {
            let aNewPosition = CGPoint(x: position.x + translation.x, y: position.y + translation.y)
            background.position = self.boundLayerPos(aNewPosition)
        }
    }
    
}


func WithAmplitude(amplitude amp: CGFloat,frequency freq:CGFloat,width:CGFloat,centered:Bool,andNumPoints numPoints:CGFloat) -> CGMutablePathRef{
    var offsetX = 0.0;
    var offsetY = amp;
    
    if (centered) {
        offsetX = 0.0;
        offsetY = 0;
    }
    
    let path: CGMutablePathRef = CGPathCreateMutable()
    CGPathMoveToPoint(path, nil, 0.0 , 0.0);
    let xIncr: CGFloat = 2.0
    let counter:Int = Int(numPoints)
    for i in 1..<counter {
        let yC = amp * sin(CGFloat(i) * π * 2.0 / 100.0)
        CGPathAddLineToPoint(path, nil, CGFloat(i)*xIncr-2.5, yC+15.0);
    }
    
    return path
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