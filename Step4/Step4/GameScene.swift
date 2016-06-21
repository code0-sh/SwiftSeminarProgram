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
        let sprite = SKSpriteNode(imageNamed: "person.png")
        // スプライトのサイズ
        sprite.size = CGSize(width: 50, height: 50)
        // スプライトの位置
        sprite.position = CGPoint(x:self.frame.midX, y:self.frame.midY)
        // スプライトを配置する
        self.addChild(sprite)
        // 画面の背景色
        self.backgroundColor = UIColor.lightGray()
        
        // 画像の差し替え
        let texture = SKTexture(imageNamed: "airplane.png")
        sprite.texture = texture
        
        // 色をブレンドする
        sprite.color = #colorLiteral(red: 0.1991284192, green: 0.6028449535, blue: 0.9592232704, alpha: 1)
        sprite.colorBlendFactor = 1
    }
}
