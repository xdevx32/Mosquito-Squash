//
//  GameScene.swift
//  Mosquito Squash
//
//  Created by Angel Kukushev on 9/16/15.
//  Copyright (c) 2015 xdevx332. All rights reserved.
//
import SpriteKit
import CoreGraphics


class GameScene: SKScene {

    
    var background = SKSpriteNode(imageNamed: "roomBackground")
    let player = SKSpriteNode(imageNamed: "flipFlop")
    
    
    
override func didMoveToView(view: SKView) {
    
    
    
    
        background.position = CGPoint(x: frame.size.width / 2, y: frame.size.height / 2)
        
        
        addChild(background)
 
        backgroundColor = SKColor.whiteColor()
    
        player.position = CGPoint(x: 400.0, y: 300.0)
        
       // addChild(player)
       // runAction(SKAction.repeatActionForever(
       //     SKAction.sequence([
       //         SKAction.runBlock(addMonster),
       //         SKAction.waitForDuration(5.0)
       //         ])
       //     ))
    addChild(player)
    var actionSequence = SKAction.sequence([SKAction.runBlock(addMonster),SKAction.waitForDuration(5.0)])
    
    runAction(SKAction.repeatAction(actionSequence, count: 20))
 
   
    }
    
func addMonster() {
        
        // Create sprite
        var monster = SKSpriteNode(imageNamed: "MosquitoDrawed")
     
        // Determine where to spawn the monster along the Y axis
       // let actualY = random(monster.size.height/2, monster.size.height - monster.size.height/2)
        
        // Position the monster slightly off-screen along the right edge,
        // and along a random position along the Y axis as calculated above
        //monster.position = CGPoint(x: 10.0, y: 100.0)
        monster.position = CGPoint(x: random(10.0,20.0), y: random(100.0,200.0))
        // Add the monster to the scene
        addChild(monster)
        
        // Determine speed of the monster
        let actualDuration = 4.0
        
        // Create the actions
        let actionMove = SKAction.moveToY(200.0, duration: NSTimeInterval(actualDuration))
        let actionMove2 = SKAction.moveToX(600.0, duration: NSTimeInterval(actualDuration))
        let actionMove3 = SKAction.moveToY(120.0, duration: NSTimeInterval(actualDuration))
        
        var action = SKAction.fadeOutWithDuration(NSTimeInterval(actualDuration))
        
        var action2 = SKAction.colorizeWithColor(UIColor.redColor(), colorBlendFactor: CGFloat(20.0), duration: NSTimeInterval(actualDuration))
        
        var action4 = SKAction.playSoundFileNamed("mosquitoFly.mp3", waitForCompletion: false)
        var action5 = SKAction.rotateByAngle(CGFloat(M_PI/4),duration: NSTimeInterval(actualDuration))
        
        let actionMoveDone = SKAction.removeFromParent()
        //monster.runAction(SKAction.sequence([actionMove, actionMoveDone]))
        //monster.runAction(actionMove)
        monster.runAction(actionMove2)
        monster.runAction(actionMove3)
        monster.runAction(action)
        monster.runAction(action4)
        monster.runAction(action5)
       // monster = SKSpriteNode(imageNamed: "MosquitoDrawedDead")
   
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        for touch in (touches as! Set<UITouch>) {
            let location = touch.locationInNode(self)
            
            let sprite = SKSpriteNode(imageNamed:"MosquitoDrawedDead")
            
            sprite.position = location
            self.addChild(sprite)
        }
    }
 
}






func random() -> CGFloat {
    return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
}

func random(min: CGFloat, max: CGFloat) -> CGFloat! {
    return random() * (max - min) + min
}


