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
    
    func setupBackground(baseNode: SKNode) {
        // 背景画像からテクスチャを作成
        let texture = SKTexture(imageNamed: "background")
        // フィルタリングモード（テクスチャの本来のサイズ以外で描画される場合に使用される）
        // .Linear クォリティーの高い描画ができるけど遅い
        // .Nearest 粗いけど速い
        texture.filteringMode = .nearest
        
        // 必要な画像枚数を算出
        let needHeightNumber = ceil(2.0 + (self.frame.size.height / texture.size().height))
        let needWidthNumber = ceil(self.frame.size.width / texture.size().width)
        
        print("frame height:\(self.frame.size.height)")
        print("frame width:\(self.frame.size.width)")
        
        print("texture height:\(texture.size().height)")
        print("texture width:\(texture.size().width)")
        
        print("needHeightNumber:\(needHeightNumber)")
        print("needWidthNumber:\(needWidthNumber)")
        
        // アニメーションを作成
        let moveAnim = SKAction.moveBy(x: 0.0, y: -texture.size().height, duration: TimeInterval(texture.size().height / 10.0))
        let resetAnim = SKAction.moveBy(x: 0.0, y: texture.size().height, duration: 0.0)
        let repeatForeverAnim = SKAction.repeatForever(SKAction.sequence([moveAnim, resetAnim]))
        
        // 画像の配置とアニメーションを設定
        for j in 0 ..< Int(needHeightNumber) {
            let sprite = SKSpriteNode(texture: texture)
            sprite.zPosition = -100.0
            sprite.position = CGPoint(x:self.frame.midX, y: CGFloat(j)*sprite.size.height)
            sprite.run(repeatForeverAnim)
            baseNode.addChild(sprite)
        }
    }
    
    override func didMove(to view: SKView) {
        let baseNode = SKNode()
        baseNode.speed = 1.0
        self.setupBackground(baseNode: baseNode)
        self.addChild(baseNode)
    }
}
