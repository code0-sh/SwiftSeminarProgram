//
//  GameScene.swift
//  Step12
//
//  Created by omura.522 on 2016/06/29.
//  Copyright © 2016年 omura.522. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    var score: Int = 0
    var scoreLabelNode: SKLabelNode! = nil
    var endLabelNode: SKLabelNode! = nil
    var buttonUpNode: SKSpriteNode! = nil
    func setup(baseNode: SKNode) {
        // ラベルのフォントを指定しインスタンスを生成する
        scoreLabelNode = SKLabelNode(fontNamed:"Chalkduster")
        // ラベルに表示する文字列
        scoreLabelNode.text = String(score)
        // ラベルの文字サイズ
        scoreLabelNode.fontSize = 30
        // ラベルの文字色
        scoreLabelNode.fontColor = SKColor.brown()
        // ラベルの位置
        scoreLabelNode.position = CGPoint(x:self.frame.midX, y:self.frame.midY);
        // ラベルを配置する
        self.addChild(scoreLabelNode)

        // ラベルのフォントを指定しインスタンスを生成する
        endLabelNode = SKLabelNode(fontNamed:"Chalkduster")
        // ラベルに表示する文字列
        endLabelNode.text = String("End")
        // ラベルの文字サイズ
        endLabelNode.fontSize = 30
        // ラベルの文字色
        endLabelNode.fontColor = SKColor.brown()
        // ラベルの位置
        endLabelNode.position = CGPoint(x:self.frame.midX, y:self.frame.midY - 150);
        // ラベルを配置する
        self.addChild(endLabelNode)
        
        // スプライトを作成
        buttonUpNode = SKSpriteNode(imageNamed: "buttonUp")
        // スプライトのサイズ
        buttonUpNode.size = CGSize(width: 50, height: 50)
        // スプライトの位置
        buttonUpNode.position = CGPoint(x:self.frame.midX, y:self.frame.midY - 50)
        // スプライトを配置する
        baseNode.addChild(buttonUpNode)
        
    }
    /// Sceneが表示された際に実行される
    override func didMove(to view: SKView) {
        let baseNode = SKNode()
        self.setup(baseNode: baseNode)
        self.addChild(baseNode)

        // 背景色
        self.backgroundColor = SKColor.white()
    }
    /// タップ開始イベント
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touche in touches {
            let location = touche.location(in: self)
            if endLabelNode.contains(location) {
                let gameScene = GameScene(size: self.size)
                self.view!.presentScene(gameScene)
            }
            if buttonUpNode.contains(location) {
                self.score += 1
                scoreLabelNode.text = String(score)
            }
        }
    }
}
