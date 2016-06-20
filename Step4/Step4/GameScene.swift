//
//  GameScene.swift
//  Step4
//
//  Created by omura.522 on 2016/06/17.
//  Copyright © 2016年 omura.522. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    override func didMove(to view: SKView) {
        // スプライトを作成
        let person = SKSpriteNode(imageNamed: "person.png")
        // スプライトのサイズ
        person.size = CGSize(width: 100, height: 100)
        // スプライトの位置
        person.position = CGPoint(x:self.frame.midX, y:self.frame.midY)
        // スプライトを配置する
        self.addChild(person)
        // 画面の背景色
        self.backgroundColor = UIColor.lightGray()
    }
}
