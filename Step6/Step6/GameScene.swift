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
    // 衝突判定用のビット値
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
            let enemy = SKSpriteNode(texture: texture)
            enemy.size = CGSize(width: radius * 2, height: radius * 2)
            let randIntX = radius + (CGFloat)(arc4random_uniform((UInt32)(self.frame.width - radius * 2)))
            let randIntY = radius + (CGFloat)(arc4random_uniform((UInt32)(self.frame.height - radius * 2)))
            enemy.position = CGPoint(x:randIntX, y:randIntY)

            // 物理設定
            enemy.physicsBody = SKPhysicsBody(circleOfRadius: radius)
            enemy.physicsBody?.restitution = 1.0 // 反発係数
            enemy.physicsBody?.linearDamping = 0.0 // 空気抵抗
            enemy.physicsBody?.mass = 1.0 // 質量
            enemy.physicsBody?.friction = 0.0 // 摩擦
            enemy.physicsBody?.categoryBitMask = ColliderType.Enemy // 物体種別
            enemy.physicsBody?.collisionBitMask = ColliderType.Enemy | ColliderType.World // どの物体と接触した場合に衝突させるか
            enemy.physicsBody?.contactTestBitMask = ColliderType.Enemy // どの物体と接触した場合にイベントを発生させるか
            
            baseNode.addChild(enemy)
        }
    }
    // 衝突時のイベント
    func didBegin(_ contact: SKPhysicsContact) {
        contact.bodyA.node?.removeFromParent()
    }

    /// Sceneが表示された際に実行される
    override func didMove(to view: SKView) {
        let baseNode = SKNode()
        self.setupEnemy(baseNode: baseNode)

        // 物理設定
        self.physicsWorld.gravity = CGVector(dx: 0.0, dy: -0.5) // 重力
        self.physicsWorld.contactDelegate = self // 衝突デリゲート
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        self.physicsBody?.categoryBitMask = ColliderType.World // 物体種別
        self.physicsBody?.collisionBitMask = ColliderType.Enemy // どの物体と接触した場合に衝突させるか
        
        self.addChild(baseNode)
    }
}
