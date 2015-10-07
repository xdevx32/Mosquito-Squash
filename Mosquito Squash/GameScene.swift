//
//  GameScene.swift
//  Mosquito Squash
//
//  Created by Angel Kukushev on 9/16/15.
//  Copyright (c) 2015 xdevx332. All rights reserved.
//
import SpriteKit
import CoreGraphics
/*

Function for spawning nodes

//    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
//        /* Called when a touch begins */
//
//        for touch in (touches as! Set<UITouch>) {
//            let location = touch.locationInNode(self)
//
//            let sprite = SKSpriteNode(imageNamed:"MosquitoDrawedDead")
//
//            sprite.position = location
//            self.addChild(sprite)
//
//        }

*/
// Ray Wrendlich Touch events for the flip flop

private let kAnimalNodeName = "movable"
private let predatorNodeName = "predator"
private let roomNodeName = "roomBackground"
var flopPosition = CGPoint(x:0 ,y:0)

class GameScene: SKScene {
    var deadMosquito = SKTexture()
    
    let player = SKSpriteNode(imageNamed: "MosquitoDrawed")
    let background = SKSpriteNode(imageNamed: "roomBackground")
    var selectedNode = SKSpriteNode()
    override init(size: CGSize) {
        super.init(size: size)
        
        // 1
        background.name = "background"
        self.background.anchorPoint = CGPointZero
        self.addChild(background)
        
        // 2
        let imageNames = ["MosquitoDrawedDead","flipFlop","MosquitoDrawed"]
        
        // 3
        for i in 0..<imageNames.count {
            let imageName = imageNames[i]
            
            let spriteFlop = SKSpriteNode(imageNamed: imageName)
            spriteFlop.name = kAnimalNodeName
            
            let offsetFraction = (CGFloat(i) + 1.0)/(CGFloat(imageNames.count) + 1.0)
            
            //spriteFlop.position = CGPoint(x: size.width * offsetFraction, y: size.height / 2)
            spriteFlop.position = CGPoint(x: 100, y: 100)
            background.addChild(spriteFlop)
            
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Function spawns a dead mosquito or something else
        override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
            /* Called when a touch begins */
    
       //     for touch in (touches ) {
               // let location = touch.locationInNode(self)
    
                //let sprite = SKSpriteNode(imageNamed:"MosquitoDrawedDead")
    
                //sprite.position = location
                //self.addChild(sprite)
    
        //}
    }
    

    
    
   
    
    
    override func didMoveToView(view: SKView) {
        let gestureRecognizer = UIPanGestureRecognizer(target: self, action: Selector("handlePanFrom:"))
       
        self.view!.addGestureRecognizer(gestureRecognizer)
        //Adding the player
        addChild(player)
        
        let actionSequence = SKAction.sequence([SKAction.runBlock(addMonster),SKAction.waitForDuration(0.9)])
        
        runAction(SKAction.repeatAction(actionSequence, count: 100))

        
    }
    //Function fires when the flop is touched.
    //
    func handlePanFrom(recognizer : UIPanGestureRecognizer) {
        if recognizer.state == .Began {
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
                let scrollDuration = 5.0
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
                 
                    // animate that image change
                    
                    
                    
                  // self.selectedNode.tran
                    //CGAffineTransformMakeRotation(3.14/2)
                     self.selectedNode.texture = SKTexture(imageNamed: "MosquitoDrawedDead")
                  
                    
                    
                    
                    
                    
                }
            }
        }
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
                    var deadPredator = SKSpriteNode(imageNamed: "MosquitoDrawedDead")
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
    
    
    
    
    func addMonster() {
        
        // Create sprite
        let monster = SKSpriteNode(imageNamed: "MosquitoDrawed")
        monster.name = predatorNodeName
        
           // self.addChild(monster)
            
//            var timer = NSTimer.scheduledTimerWithTimeInterval(0.2, target: self, selector: "doAction", userInfo: nil, repeats: true)
//        
//        
        
        // Determine where to spawn the monster along the Y axis
        // let actualY = random(monster.size.height/2, monster.size.height - monster.size.height/2)
        
        // Position the monster slightly off-screen along the right edge,
        // and along a random position along the Y axis as calculated above
        //monster.position = CGPoint(x: 10.0, y: 100.0)
        monster.position = CGPoint(x: random(-40.0,max: -30.0), y: random(50.0,max: 200.0))
        // Add the monster to the scene
        addChild(monster)
        
        player.position = monster.position
        
        // Determine speed of the monster
        let actualDuration = 4.0
        
        // Create the actions
        
       // _ = SKAction.moveToY(200.0, duration: NSTimeInterval(actualDuration))
        var actionmoveTo = SKAction.moveToX(600.0, duration: NSTimeInterval(actualDuration))
        var actionMoveToY = SKAction.moveToY(120.0, duration: NSTimeInterval(actualDuration))
        
        let actionFadeOut = SKAction.fadeOutWithDuration(NSTimeInterval(actualDuration))
        //var tempActionHide = SKAction.hide()
      //  var action2 = SKAction.colorizeWithColor(UIColor.redColor(), colorBlendFactor: CGFloat(20.0), duration: NSTimeInterval(actualDuration))
        
        let action4 = SKAction.playSoundFileNamed("mosquitoFly.mp3", waitForCompletion: false)
        //let action5 = SKAction.rotateByAngle(CGFloat(2*M_PI),duration: NSTimeInterval(actualDuration))
        
        //let actionMoveDone = SKAction.removeFromParent()
        
        //Action letting me to move the monster to a CGPoint
        let actionMoveTo = SKAction.moveTo(CGPoint(x: random(500, max:100),y: random(1, max:400) ), duration: NSTimeInterval(actualDuration))
        //
        
        //monster.runAction(SKAction.sequence([actionMove, actionMoveDone]))
        //monster.runAction(actionMove)
        //        monster.runAction(actionMove2)
        //        monster.runAction(actionMove3)
        monster.runAction(actionMoveTo)
        //monster.runAction(actionFadeOut)
        monster.runAction(action4)
       // monster.runAction(action5)
       
        //hiding a node
          //  monster.runAction(tempActionHide)

        // monster = SKSpriteNode(imageNamed: "MosquitoDrawedDead")
    }
    
    func panForTranslation(translation : CGPoint) {
        let position = selectedNode.position
        
        if selectedNode.name! == kAnimalNodeName {
            selectedNode.position = CGPoint(x: position.x + translation.x, y: position.y + translation.y)
        } else {
            let aNewPosition = CGPoint(x: position.x + translation.x, y: position.y + translation.y)
            background.position = self.boundLayerPos(aNewPosition)
        }
    }
    
}


func random() -> CGFloat {
    return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
}

func random(min: CGFloat, max: CGFloat) -> CGFloat! {
    return random() * (max - min) + min
}

// Ray Wrendlich