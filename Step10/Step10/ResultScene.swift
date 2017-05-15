//
//  ResultScene.swift
//  Step10
//
//  Created by omura.522 on 2016/06/24.
//  Copyright © 2016年 omura.522. All rights reserved.
//

import SpriteKit
import GameplayKit

class ResultScene: SKScene {
    /// Sceneが表示された際に実行される
    override func didMove(to view: SKView) {
        let baseNode = SKNode()
        let resultLabel = Button.setup(CGPoint(x: self.frame.midX, y: self.frame.midY), text: "結果")
        if let num = self.scene?.userData?["score"] {
            let score = Button.setup(CGPoint(x: self.frame.midX, y: self.frame.midY - 50), text: "得点：\(num)")
            baseNode.addChild(score)
        }
        baseNode.addChild(resultLabel)
        self.addChild(baseNode)
    }
}
