//
//  HomeScene.swift
//  Step10
//
//  Created by omura.522 on 2016/06/24.
//  Copyright © 2016年 omura.522. All rights reserved.
//

import SpriteKit
import GameplayKit

class HomeScene: SKScene {
    var startLabel: SKLabelNode!
    /// Sceneが表示された際に実行される
    override func didMove(to view: SKView) {
        let baseNode = SKNode()
        startLabel = Button.setup(location: CGPoint(x: self.frame.midX, y: self.frame.midY), text: "Start")
        baseNode.addChild(startLabel)
        self.addChild(baseNode)
    }
    /// タッチ開始イベント
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touche in touches {
            let location = touche.location(in: self)
            // Startラベルタッチ
            if startLabel.contains(location) {
                let transition = SKTransition.doorway(withDuration: 1)
                let newScene = GameScene()
                newScene.size = self.frame.size
                view?.presentScene(newScene, transition: transition)
            }
        }
    }
}
