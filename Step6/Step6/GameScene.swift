//
//  GameScene.swift
//  Step6
//
//  Created by omura.522 on 2016/06/21.
//  Copyright © 2016年 omura.522. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    struct ColliderType {
        static let Enemy: UInt32 = (1 << 0)
        static let World: UInt32 = (1 << 1)
    }
    
    func setupEnemy(baseNode: SKNode) {
        // エネミー画像からテクスチャを作成
        let texture = SKTexture(imageNamed: "enemy")
        // フィルタリングモード（テクスチャの本来のサイズ以外で描画される場合に使用される）
        // .Linear クォリティー高い
        // .Nearest クォリティー低
        texture.filteringMode = .nearest
        
        // エネミー画像の半径
        let radius: CGFloat = 10
        
        for _ in 0..<10 {
            let sprite = SKSpriteNode(texture: texture)
            sprite.size = CGSize(width: radius*2, height: radius*2)
            let randIntX = radius + (CGFloat)(arc4random_uniform((UInt32)(self.frame.width - radius * 2)))
            let randIntY = radius + (CGFloat)(arc4random_uniform((UInt32)(self.frame.height - radius * 2)))
            sprite.position = CGPoint(x:randIntX, y:randIntY)

            // 重力
            sprite.physicsBody = SKPhysicsBody(circleOfRadius: radius)
            sprite.physicsBody?.restitution = 1.0 // 反発係数
            sprite.physicsBody?.linearDamping = 0.0 // 空気抵抗
            sprite.physicsBody?.mass = 1.0 // 質量
            sprite.physicsBody?.friction = 0.0 // 摩擦
            
            // 物体種別
            sprite.physicsBody?.categoryBitMask = ColliderType.Enemy
            // どの物体と接触した場合に衝突させるか
            sprite.physicsBody?.collisionBitMask = ColliderType.Enemy | ColliderType.World
            // どの物体と接触した場合にイベントを発生させるか
            sprite.physicsBody?.contactTestBitMask = ColliderType.Enemy
            
            baseNode.addChild(sprite)
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        contact.bodyA.node?.removeFromParent()
    }

    /// Sceneが表示された際に実行される
    override func didMove(to view: SKView) {
        let baseNode = SKNode()
        self.setupEnemy(baseNode: baseNode)

        // 重力
        self.physicsWorld.gravity = CGVector(dx: 0.0, dy: -0.5)
        self.physicsWorld.contactDelegate = self
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        self.physicsBody?.restitution = 1.0 // 反発係数
        self.physicsBody?.linearDamping = 0.0 // 空気抵抗
        self.physicsBody?.friction = 0.0 // 摩擦
        self.name = "frame"
        
        // 物体種別
        self.physicsBody?.categoryBitMask = ColliderType.World
        // どの物体と接触した場合に衝突させるか
        self.physicsBody?.collisionBitMask = ColliderType.Enemy
        
        self.addChild(baseNode)
    }
}
