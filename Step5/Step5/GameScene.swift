//
//  GameScene.swift
//  Step5
//
//  Created by omura.522 on 2016/06/20.
//  Copyright © 2016年 omura.522. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var baseNode: SKNode!
    
    func setupBackground() {
        // 背景画像を読み込む
        let texture = SKTexture(imageNamed: "background")
        texture.filteringMode = .nearest
        
        // 必要な画像枚数を算出
        let needNumber = ceil( 2.0 + (self.frame.size.width / texture.size().width) )
        let needHeightNumber = ceil(self.frame.size.height / texture.size().height)
        
        // アニメーションを作成
        let moveAnim = SKAction.moveBy(x: -texture.size().width, y: 0.0, duration: TimeInterval(texture.size().width / 10.0))
        let resetAnim = SKAction.moveBy(x: texture.size().width, y: 0.0, duration: 0.0)
        let repeatForeverAnim = SKAction.repeatForever(SKAction.sequence([moveAnim, resetAnim]))
        
        // 画像の配置とアニメーションを設定
        for j in 0 ..< Int(needHeightNumber) {
            for i in 0 ..< Int(needNumber) {
                let sprite = SKSpriteNode(texture: texture)
                sprite.zPosition = -100.0
                sprite.position = CGPoint(x: CGFloat(i)*sprite.size.width, y: CGFloat(j)*sprite.size.height)
                sprite.run(repeatForeverAnim)
                self.baseNode.addChild(sprite)
            }
        }
    }
    override func didMove(to view: SKView) {
        baseNode = SKNode()
        baseNode.speed = 1.0
        self.addChild(baseNode)
        
        self.setupBackground()
    }
}
