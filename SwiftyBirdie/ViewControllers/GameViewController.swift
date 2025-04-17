//
//  GameViewController.swift
//  BirdGameSwift
//
//  Created by Antonio Abilio on 26/07/2024.
//

import UIKit
import SpriteKit
import GameplayKit

import GameKit

class GameViewController: UIViewController {
    var scene: SKScene?
    var skView: SKView?
    
    // Handle the notification
    @objc func nextSceneAction(notification: Notification) {
        switch notification.name {
        case .changeToMainSceneNoRandomization:
            switchToNewScene(newScene: GameScene(size: (skView?.scene?.size)!, randomizeValues: false))
            break
        case .changeToMainSceneWithRandomization:
            switchToNewScene(newScene: GameScene(size: (skView?.scene?.size)!, randomizeValues: true))
            break
        default:
            switchToNewScene(newScene: GameScene(size: (skView?.scene?.size)!, randomizeValues: true))
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(nextSceneAction), name: .changeToMainSceneWithRandomization, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(nextSceneAction), name: .changeToMainSceneNoRandomization, object: nil)
        skView = (self.view as! SKView) // Setup the view
        switchToNewScene(newScene: SKScene(fileNamed: "MainMenuScene")!)
    }
    
    // Function to swich Scenes
    func switchToNewScene(newScene: SKScene) {
        scene = newScene
        scene!.scaleMode = .aspectFill

        skView!.ignoresSiblingOrder = true
        //skView!.showsFPS = true
        //skView!.showsNodeCount = true
        skView!.preferredFramesPerSecond = 60;
        skView!.presentScene(scene!, transition: SKTransition.fade(with: UIColor.black, duration: 0.7))
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
