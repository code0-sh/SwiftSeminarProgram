//
//  GameScene.swift
//  Step9
//
//  Created by omura.522 on 2016/06/23.
//  Copyright © 2016年 omura.522. All rights reserved.
//

import SpriteKit
import CoreMotion
import GameplayKit

class GameScene: SKScene {
    var motionManager: CMMotionManager = CMMotionManager()
    var ship: SKSpriteNode!
    /// 衝突判定用のビット値
    struct ColliderType {
        static let Ship: UInt32 = (1 << 0)
        static let World: UInt32 = (1 << 1)
    }
    /// 飛行機情報
    struct Ship {
        static let width: CGFloat = 50
        static let height: CGFloat = 50
        static var moveX: CGFloat = 0
    }
    /// 飛行機のノードを追加
    func setupShip(baseNode: SKNode) {
        let texture = SKTexture(imageNamed: "Spaceship")
        // フィルタリングモード（テクスチャの本来のサイズ以外で描画される場合に使用される）
        // .linear クォリティー高い
        // .nearest クォリティー低
        texture.filteringMode = .nearest
        ship = SKSpriteNode(texture: texture)
        ship.size = CGSize(width: Ship.width, height: Ship.height)
        ship.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        ship.physicsBody = SKPhysicsBody(rectangleOf: ship.size)
        ship.physicsBody?.affectedByGravity = false // 飛行機に重力を効かせない
        ship.physicsBody?.categoryBitMask = ColliderType.Ship // 物体種別
        ship.physicsBody?.collisionBitMask = ColliderType.World // どの物体と接触した場合に衝突させるか
        
        baseNode.addChild(ship)
    }
    /// 加速度データを使用して飛行機のx方向の移動距離を算出
    func setupMotionManager() {
        motionManager.accelerometerUpdateInterval = 0.1 // 取得間隔
        // 加速度センサーを使用開始
        motionManager.startAccelerometerUpdates(to: OperationQueue.current!, withHandler: { accelerometerData, error in
          guard let data = accelerometerData else { return }
          print("x:\(data.acceleration.x)")
        
          Ship.moveX = CGFloat(data.acceleration.x) * 20
        })
    }
    /// Sceneが表示された際に実行される
    override func didMove(to view: SKView) {
        let baseNode = SKNode()
        setupShip(baseNode: baseNode)
        setupMotionManager()

        self.physicsBody = SKPhysicsBody(edgeLoopFrom: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
        self.physicsBody?.categoryBitMask = ColliderType.World // 物体種別
        self.physicsBody?.collisionBitMask = ColliderType.Ship // どの物体と接触した場合に衝突させるか
        
        self.addChild(baseNode)
    }
    /// 1フレームごとに呼ばれる
    override func update(_ currentTime: TimeInterval) {
        ship.position = CGPoint(x: Ship.moveX + ship.position.x, y: self.frame.midY)
    }
}
