//
//  ResultScene.swift
//  Step11
//
//  Created by omura.522 on 2016/06/28.
//  Copyright © 2016年 omura.522. All rights reserved.
//

import SpriteKit

class ResultScene: SKScene {
    var restartLabel: SKLabelNode! = nil
    /// Sceneが表示された際に実行される
    override func didMove(to view: SKView) {
        let baseNode = SKNode()
        // ゲームオーバーラベル
        let resultLabel = Label.setup(location: CGPoint(x: self.frame.midX, y: self.frame.midY), text: "Game Over")
        baseNode.addChild(resultLabel)
        // スコアラベル
        if let num = self.scene?.userData?["score"] {
            let scoreLabel = Label.setup(location: CGPoint(x: self.frame.midX, y: self.frame.midY - 50), text: "得点：\(num)")
            baseNode.addChild(scoreLabel)
        }
        // 再スタートラベル
        restartLabel = Label.setup(location: CGPoint(x: self.frame.midX, y: self.frame.midY - 100), text: "Restart")
        baseNode.addChild(restartLabel)
        
        self.addChild(baseNode)
    }
    /// タッチ開始イベント
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touche in touches {
            let location = touche.location(in: self)
            // 再スタートラベルタッチ
            if restartLabel.contains(location) {
                let transition = SKTransition.doorway(withDuration: 1.0)
                let newScene = GameScene()
                newScene.size = self.frame.size
                view?.presentScene(newScene, transition: transition)
            }
        }
    }
}
