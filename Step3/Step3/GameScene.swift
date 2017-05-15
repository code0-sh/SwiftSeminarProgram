//
//  GameScene.swift
//  Step3
//
//  Created by omura.522 on 2016/06/17.
//  Copyright © 2016年 omura.522. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    /// Sceneが表示された際に実行される
    override func didMove(to view: SKView) {
        // ラベルのフォントを指定しインスタンスを生成する
        let label = SKLabelNode(fontNamed:"Chalkduster")
        // ラベルに表示する文字列
        label.text = "Hello, SpriteKit"
        // ラベルの文字サイズ
        label.fontSize = 30
        // ラベルの文字色
        label.fontColor = SKColor.green
        // ラベルの位置
        label.position = CGPoint(x:self.frame.midX, y:self.frame.midY);

        // シーンに追加
        self.addChild(label)
        
        // 背景色
        self.backgroundColor = SKColor.purple
    }
}
