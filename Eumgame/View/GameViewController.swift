//
//  GameViewController.swift
//  Eumgame
//
//  Created by Elena Kapilevich on 10/26/17.
//  Copyright © 2017 KinakoInc. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
		super.viewDidLoad()
		
		let scene = GameScene(size: view.bounds.size)
		let skView = view as! SKView
		skView.showsFPS = true
		skView.showsNodeCount = true
		skView.showsPhysics = true
		skView.ignoresSiblingOrder = true
		scene.scaleMode = .resizeFill
		skView.presentScene(scene)
    }

    override var prefersStatusBarHidden: Bool {
		return false
    }
}
