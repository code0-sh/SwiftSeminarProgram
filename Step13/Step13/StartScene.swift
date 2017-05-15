//
//  GameScene.swift
//  Step13
//
//  Created by omura.522 on 2016/07/01.
//  Copyright © 2016年 omura.522. All rights reserved.
//

import SpriteKit

class StartScene: SKScene {
    var label: SKLabelNode! = nil
    /// Sceneが表示された際に実行される
    override func didMove(to view: SKView) {
        // ラベルのフォントを指定しインスタンスを生成する
        label = SKLabelNode(fontNamed:"Chalkduster")
        // ラベルに表示する文字列
        label.text = "Start"
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
    /// タッチ開始イベント
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touche in touches {
            let location = touche.location(in: self)
            // Startラベルタッチ
            if label.contains(location) {
                // EndSceneを表示
                let newScene = EndScene(size: self.frame.size)
                newScene.scaleMode = SKSceneScaleMode.aspectFill
                view?.presentScene(newScene)
                // Bug?
                //let transition = SKTransition.moveIn(with: .right, duration: 1)
                //view?.presentScene(newScene, transition: transition)
            }
        }
    }
}
