//
//  GameViewController.swift
//  Step13
//
//  Created by omura.522 on 2016/07/01.
//  Copyright © 2016年 omura.522. All rights reserved.
//

import UIKit
import SpriteKit

class FirstViewController: UIViewController {
    
    /// SecondViewControllerに遷移する
    func moveSecondViewController(notification: NSNotification) {
        var second = UIViewController()
        let selfStoryboard = self.storyboard
        second = selfStoryboard!.instantiateViewController(withIdentifier: "second") as UIViewController
        self.present(second, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // NotificationCenterに登録する
        NotificationCenter.default().addObserver(self,
                                                 selector: #selector(moveSecondViewController),
                                                 name: "MoveSecondViewController",
                                                 object: nil)
        
        // View ControllerのViewをSKView型として取り出す
        if let view = self.view as? SKView {
            // シーンの作成
            let scene = StartScene()
            
            // FPSの表示
            view.showsFPS = true
            
            // ノード数の表示
            view.showsNodeCount = true
            
            // シーンのサイズをビューに合わせる
            scene.size = view.frame.size
            
            // ビュー上にシーンを表示
            view.presentScene(scene)
        }
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
