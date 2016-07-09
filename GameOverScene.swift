//
//  GameOverScene.swift
//  Mosquito Squash
//
//  Created by Angel Kukushev on 12/4/15.
//  Copyright © 2015 xdevx332. All rights reserved.
//

import Foundation
import SpriteKit
import AVFoundation


var button: SKNode! = nil

var loseURL = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("MosquitoLose", ofType: "mp3")!)
var losePlayer = AVAudioPlayer()

var newHighscoreURL = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("MosquitoWin", ofType: "mp3")!)
var newHighscorePlayer = AVAudioPlayer()

class GameOverScene: SKScene {
   
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
   
    init(size: CGSize, won:Bool, points: Int, highscore: Int) {
        
        super.init(size: size)
        
        
        do {
            try losePlayer = AVAudioPlayer(contentsOfURL: loseURL)
            losePlayer.prepareToPlay()
            
        }
        catch {
            print("Something bad happened. Try catching specific errors to narrow things down")
        }

        

        
        // 1
        backgroundColor = SKColor.whiteColor()
        
        // 2
        let message = won ? "You Won!" : "You Lose!"
        
        // 3
        let label = SKLabelNode(fontNamed: "Copperplate")
        let label1 = SKLabelNode(fontNamed: "Copperplate")
        let label2 = SKLabelNode(fontNamed: "Copperplate")
        
        button = SKSpriteNode(imageNamed:"playAgainButton")
        //  label.text = message + "\n" + "Your score is: " + "\(points)"
        label.text = "Game over"
        label.fontSize = 30
        label.fontColor = SKColor.blackColor()
        label.position = CGPoint(x: size.width/2, y: size.height/2 + 30)
        
        label1.text = "Your score is: \(points)"
        label1.fontSize = 30
        label1.fontColor = SKColor.blackColor()
        label1.position = CGPoint(x: size.width/2, y: size.height/2)
        
        label2.text =  "Highscore is: \(highscore)"
        label2.fontSize = 30
        label2.fontColor = SKColor.blackColor()
        label2.position = CGPoint(x: size.width/2, y: size.height/2 - 30)
        
        
        button.position = CGPoint(x:CGRectGetMidX(self.frame), y:label2.position.y - 40)
        button.setScale(0.5)
        
        
        
        
        if message == "You Won!"{
        
            let soundWon = SKAction.playSoundFileNamed("MosquitoWin.mp3", waitForCompletion: true)
             self.runAction(soundWon)
        
        } else if message == "You Lost!"{
            
            let soundLost   = SKAction.playSoundFileNamed("MosquitoLose.mp3", waitForCompletion: true)
            self.runAction(soundLost)
            
        }
        addChild(label)
        addChild(label1)
        addChild(label2)
        addChild(button)

    }
    

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func didMoveToView(view: SKView) {
        
        losePlayer.play()
        losePlayer.numberOfLoops = 0
        
        runAction(SKAction.stop())

    }
}