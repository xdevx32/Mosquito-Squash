//
//  GameViewController.swift
//  Mosquito Squash
//
//  Created by Angel Kukushev on 9/16/15.
//  Copyright (c) 2015 xdevx332. All rights reserved.
//
import UIKit
import SpriteKit

class GameViewController: UIViewController {
    
   
  
    override func viewDidLoad() {
        super.viewDidLoad()
   
        presentScene()
    //    self.view.frame.midX
//        let label: UILabel = UILabel()
//        label.frame = CGRectMake(self.view.bounds.midX, self.view.bounds.midY, 300.0, 100.0)
//       // label.backgroundColor = UIColor.whiteColor()
//        label.textColor = UIColor.blackColor()
//        label.textAlignment = NSTextAlignment.Center
//        label.text = "Mosquito Squash"
//        label.font = UIFont(name: "Trebuchet MS", size: 40.0)
//        self.view.addSubview(label)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    
    func presentScene(){
     
        let scene = MainMenuScene(size: view!.bounds.size)
       
        let skView = view as! SKView
      
        skView.showsFPS = false
      
        skView.showsNodeCount = true
      
        skView.ignoresSiblingOrder = true
       
        scene.scaleMode = .ResizeFill
       
        skView.presentScene(scene)
        
    }
    /*
    func presentScene(){
        let scene = GameScene(size: view.bounds.size)
        let skView = view as! SKView
        skView.showsFPS = false
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        scene.scaleMode = .ResizeFill
        skView.presentScene(scene)
        
    }
*/
}


