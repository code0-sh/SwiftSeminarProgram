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
    var endNode: SKSpriteNode! = nil
    var saveNode: SKSpriteNode! = nil
    var buttonUpNode: SKSpriteNode! = nil
    var clearNode: SKSpriteNode! = nil
    let defaults: UserDefaults = UserDefaults.standard
    
    func setup(baseNode: SKNode) {
        // スコアをUserDefaultsから読み取る
        score = defaults.integer(forKey: "Score")
        
        // ラベルのフォントを指定しインスタンスを生成する
        scoreLabelNode = SKLabelNode(fontNamed:"Chalkduster")
        // ラベルに表示する文字列
        scoreLabelNode.text = String(score)
        // ラベルの文字サイズ
        scoreLabelNode.fontSize = 30
        // ラベルの文字色
        scoreLabelNode.fontColor = SKColor.brown
        // ラベルの位置
        scoreLabelNode.position = CGPoint(x:self.frame.midX, y:self.frame.midY);
        // ラベルを配置する
        self.addChild(scoreLabelNode)

        // Upボタンを作成
        buttonUpNode = SKSpriteNode(imageNamed: "buttonUp")
        // Upボタンのサイズ
        buttonUpNode.size = CGSize(width: 50, height: 50)
        // Upボタンの位置
        buttonUpNode.position = CGPoint(x:self.frame.midX, y:self.frame.midY - 50)
        // Upボタンを配置する
        baseNode.addChild(buttonUpNode)
        
        // Endボタンを作成
        endNode = SKSpriteNode(imageNamed:"end")
        // Endボタンのサイズ
        endNode.size = CGSize(width: 50, height: 25)
        // Endボタンの位置
        endNode.position = CGPoint(x:self.frame.midX, y:self.frame.midY - 150);
        // Endボタンを配置する
        self.addChild(endNode)
        
        // Saveボタンを作成
        saveNode = SKSpriteNode(imageNamed:"save")
        // Saveボタンのサイズ
        saveNode.size = CGSize(width: 50, height: 25)
        // Saveボタンの位置
        saveNode.position = CGPoint(x:self.frame.midX, y:self.frame.midY - 200);
        // Saveボタンを配置する
        self.addChild(saveNode)
        
        // Clearボタンを作成
        clearNode = SKSpriteNode(imageNamed:"clear")
        // Clearボタンのサイズ
        clearNode.size = CGSize(width: 50, height: 25)
        // Clearボタンの位置
        clearNode.position = CGPoint(x:self.frame.midX, y:self.frame.midY - 250);
        // Clearボタンを配置する
        self.addChild(clearNode)
    }
    /// Sceneが表示された際に実行される
    override func didMove(to view: SKView) {
        let baseNode = SKNode()
        self.setup(baseNode: baseNode)
        self.addChild(baseNode)

        // 背景色
        self.backgroundColor = SKColor.purple
    }
    /// タップ開始イベント
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touche in touches {
            let location = touche.location(in: self)
            if buttonUpNode.contains(location) {
                score += 1
                scoreLabelNode.text = String(score)
            }
            if endNode.contains(location) {
                let gameScene = GameScene(size: self.size)
                self.view!.presentScene(gameScene)
            }
            if saveNode.contains(location) {
                // スコアをUserDefaultsに保存
                defaults.set(self.score, forKey: "Score")
            }
            if clearNode.contains(location) {
                // スコアをUserDefaultsから削除
                defaults.removeObject(forKey: "Score")
            }
        }
    }
}
