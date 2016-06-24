//
//  GameScene.swift
//  Step11
//
//  Created by omura.522 on 2016/06/24.
//  Copyright © 2016年 omura.522. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    var ship: SKSpriteNode! = nil
    var status: SKShapeNode! = nil
    // 衝突判定用のビット値
    struct ColliderType {
        static let Ship: UInt32 = (1 << 0)
        static let Enemy: UInt32 = (1 << 1)
        static let World: UInt32 = (1 << 2)
    }
    func setupShip(baseNode: SKNode) {
        ship = SKSpriteNode(imageNamed: "Spaceship")
        ship.position = CGPoint(x:self.frame.midX, y: self.frame.midY)
        ship.size = CGSize(width: 100, height: 100)
        baseNode.addChild(ship)
        
        ship.physicsBody = SKPhysicsBody(rectangleOf: ship.frame.size)
        //ship.physicsBody?.affectedByGravity = false
    }
    func setupStatus(baseNode: SKNode) {
        status = SKShapeNode(rectOf: CGSize(width: 100, height: 10))
        status.position = CGPoint(x: self.frame.width - 60, y: self.frame.height - 10)
        status.fillColor = SKColor.blue()
        baseNode.addChild(status)
    }
    override func didMove(to view: SKView) {
        let baseNode = SKNode()
        setupShip(baseNode: baseNode)
        setupStatus(baseNode: baseNode)

        self.addChild(baseNode)
        
        // 重力
        self.physicsWorld.gravity = CGVector(dx: 0.0, dy: -0.5)
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        self.physicsBody?.restitution = 1.0 // 反発係数
        self.physicsBody?.linearDamping = 0.0 // 空気抵抗
        self.physicsBody?.friction = 0.0 // 摩擦
        
        // 物体種別
        self.physicsBody?.categoryBitMask = ColliderType.World
        // どの物体と接触した場合に衝突させるか
        self.physicsBody?.collisionBitMask = ColliderType.Enemy
    }
    override func update(_ currentTime: TimeInterval) {
        
    }
}
