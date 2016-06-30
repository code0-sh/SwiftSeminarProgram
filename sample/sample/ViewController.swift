//
//  GameViewController.swift
//  sample
//
//  Created by omura.522 on 2016/06/30.
//  Copyright © 2016年 omura.522. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default().addObserver(self,
                                                 selector: #selector(moveSecondViewController),
                                                 name: "secondViewController",
                                                 object: nil)
        
        let scene = StartScene()
        let skView = self.view as? SKView
        scene.scaleMode = .aspectFill
        scene.size = self.view.frame.size
        skView?.presentScene(scene)
    }
    
    func moveSecondViewController(notification: NSNotification) {
        var second = UIViewController()
        let selfStoryboard = self.storyboard
        second = selfStoryboard!.instantiateViewController(withIdentifier: "second") as UIViewController
        self.present(second, animated: true, completion: nil)
    }

    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.current().userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
