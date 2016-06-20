//
//  MainMenuScene.swift
//  Mosquito Squash
//
//  Created by Angel Kukushev on 5/15/16.
//  Copyright © 2016 xdevx332. All rights reserved.
//
//
//  GameOverScene.swift
//  Mosquito Squash
//
//  Created by Angel Kukushev on 12/4/15.
//  Copyright © 2015 xdevx332. All rights reserved.
//

import Foundation
import SpriteKit

class MainMenuScene: SKScene {
    
    
    var button: SKNode! = nil
    var label: SKNode! = nil
    
    override func didMoveToView(view: SKView) {
        
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
            // Loop over all the touches in this event
            for touch: AnyObject in touches {
                // Get the location of the touch in this scene
                let location = touch.locationInNode(self)
                // Check if the location of the touch is within the button's bounds
                if button.containsPoint(location) {
                    print("tapped!")
                    let reveal = SKTransition.flipHorizontalWithDuration(0.5)
                    let playScene = GameScene(size: view!.bounds.size)
                    self.view?.presentScene(playScene, transition: reveal)
                
                }
            }
    }
    
    override init(size: CGSize) {
        
        super.init(size: size)
        
        backgroundColor = SKColor.whiteColor()
        
        // Create a simple red rectangle that's 100x44
        //  button = SKSpriteNode(color: SKColor.redColor(), size: CGSize(width: 100, height: 44))
        button = SKSpriteNode(imageNamed:"playAgainButton")
        button.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame) - 60)
        button.zPosition = 2

        label = SKSpriteNode(imageNamed: "playLabel")
        label.position = CGPoint(x: button.position.x + 40, y: button.position.y + 90)
        label.zPosition = 1
      
        self.addChild(label)
        self.addChild(button)
     
        
        /*
        let label = SKLabelNode(fontNamed: "Copperplate")
        let label1 = SKLabelNode(fontNamed: "Copperplate")
        let label2 = SKLabelNode(fontNamed: "Copperplate")
        //  label.text = message + "\n" + "Your score is: " + "\(points)"
        label.text = "Game over"
        label.fontSize = 30
        label.fontColor = SKColor.blackColor()
        label.position = CGPoint(x: size.width/2, y: size.height/2 + 30)
        
        label1.text = ""
        label1.fontSize = 30
        label1.fontColor = SKColor.blackColor()
        label1.position = CGPoint(x: size.width/2, y: size.height/2)
        
        label2.text =  "Highscore is: \(highscore)"
        label2.fontSize = 30
        label2.fontColor = SKColor.blackColor()
        label2.position = CGPoint(x: size.width/2, y: size.height/2 - 30)
        
        
    
        addChild(label)
        addChild(label1)
        addChild(label2)
        
        */
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

   
}

