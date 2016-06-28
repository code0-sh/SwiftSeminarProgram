//
//  GameScene.swift
//  Step11
//
//  Created by omura.522 on 2016/06/24.
//  Copyright © 2016年 omura.522. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    var ship: SKSpriteNode! = nil
    var status: SKShapeNode! = nil
    var timer = Timer();
    // 衝突判定用のビット値
    struct ColliderType {
        static let Ship: UInt32 = 0x1 << 0
        static let Enemy: UInt32 = 0x1 << 1
        static let World: UInt32 = 0x1 << 2
    }
    /// 飛行機情報
    struct Ship {
        static let width: CGFloat = 100
        static let height: CGFloat = 100
        static let positionY: CGFloat = 100
    }
    /// ステータス情報
    struct Status {
        static let width: CGFloat = 200
        static let height: CGFloat = 20
    }
    /// 弾丸情報
    struct Shell {
        static let radius: CGFloat = 5
        static let positionY: CGFloat = 110
        static let speed: CGFloat = 10
    }
    /// 背景画像を設定する
    func setupBackground(baseNode: SKNode) {
        // 背景画像からテクスチャを作成
        let texture = SKTexture(imageNamed: "background")
        // フィルタリングモード（テクスチャの本来のサイズ以外で描画される場合に使用される）
        // .Linear クォリティー高い
        // .Nearest クォリティー低い
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
        for i in 0 ..< Int(needWidthNumber) + 1 {
            for j in 0 ..< Int(needHeightNumber) {
                let sprite = SKSpriteNode(texture: texture)
                sprite.zPosition = -100.0
                sprite.position = CGPoint(x:CGFloat(i)*sprite.size.width, y: CGFloat(j)*sprite.size.height)
                sprite.run(repeatForeverAnim)
                baseNode.addChild(sprite)
            }
        }
    }
    /// 飛行機の初期設定
    func setupShip(baseNode: SKNode) {
        // 飛行機画像からテクスチャを作成
        let texture = SKTexture(imageNamed: "Spaceship")
        // フィルタリングモード（テクスチャの本来のサイズ以外で描画される場合に使用される）
        // .Linear クォリティー高い
        // .Nearest クォリティー低
        texture.filteringMode = .nearest
        
        ship = SKSpriteNode(texture: texture)
        ship.size = CGSize(width: Ship.width, height: Ship.height)
        ship.position = CGPoint(x: self.frame.size.width / 2, y: Ship.positionY)
        ship.name = "ship"
        
        // 重力の影響なし
        ship.physicsBody = SKPhysicsBody(rectangleOf: ship.frame.size)
        ship.physicsBody?.isDynamic = false
        ship.physicsBody?.affectedByGravity = false
        
        // 物体種別
        ship.physicsBody?.categoryBitMask = ColliderType.Ship
        
        baseNode.addChild(ship)
    }
    /// エネミーの初期設定
    func setupEnemy() {
        // エネミー画像からテクスチャを作成
        let texture = SKTexture(imageNamed: "enemy")
        // フィルタリングモード（テクスチャの本来のサイズ以外で描画される場合に使用される）
        // .Linear クォリティー高い
        // .Nearest クォリティー低
        texture.filteringMode = .nearest
        
        // エネミー画像の半径
        let radius: CGFloat = 10

        let enemy = SKSpriteNode(texture: texture)
        enemy.size = CGSize(width: radius * 2, height: radius * 2)
        let randIntX = radius + (CGFloat)(arc4random_uniform((UInt32)(self.frame.width - radius * 2)))
        let randIntY = radius + (CGFloat)(arc4random_uniform((UInt32)(self.frame.height / 2))) + self.frame.height / 2
        enemy.position = CGPoint(x:randIntX, y:randIntY)
        enemy.name = "enemy"
        
        // 重力
        enemy.physicsBody = SKPhysicsBody(circleOfRadius: radius)
        enemy.physicsBody?.restitution = 1.0 // 反発係数
        enemy.physicsBody?.linearDamping = 0.0 // 空気抵抗
        enemy.physicsBody?.mass = 1.0 // 質量
        enemy.physicsBody?.friction = 0.0 // 摩擦
        
        // 物体種別
        enemy.physicsBody?.categoryBitMask = ColliderType.Enemy
        // どの物体と接触した場合に衝突させるか
        enemy.physicsBody?.collisionBitMask = ColliderType.Ship | ColliderType.World
        // どの物体と接触した場合にイベントを発生させるか
        enemy.physicsBody?.contactTestBitMask = ColliderType.Ship | ColliderType.World
            
        self.addChild(enemy)

    }
    /// 弾丸の設定
    func createShell(location: CGPoint) {
        let shell = SKShapeNode(circleOfRadius: Shell.radius)
        shell.position = CGPoint(x: location.x, y: Shell.positionY)
        shell.fillColor = UIColor.red()
        // 弾丸の移動
        let moveAction = SKAction.move(to: CGPoint(x: location.x, y: self.frame.size.height), duration: 5)
        // 弾丸の削除
        let removeAction = SKAction.removeFromParent()
        let sequenceAction = SKAction.sequence([moveAction, removeAction])
        shell.run(sequenceAction)
        self.addChild(shell)
    }
    // パーティクル発生
    func createParticle(location: CGPoint) {
        let particle = SKEmitterNode(fileNamed: "ConflictParticle.sks")
        particle?.position = CGPoint(x: location.x, y: location.y)
        self.addChild(particle!)
        
        // タップするたびにパーティクルが増えて処理が重くなるため
        // パーティクルを表示してから1秒後に削除する
        let removeAction = SKAction.removeFromParent()
        let durationAction = SKAction.wait(forDuration: 1)
        let sequenceAction = SKAction.sequence([durationAction, removeAction])
        particle?.run(sequenceAction)
    }
    /// ステータスの初期設定
    func setupStatus(baseNode: SKNode) {
        status = SKShapeNode(rectOf: CGSize(width: Status.width, height: Status.height))
        status.position = CGPoint(x: self.frame.width - Status.width / 2 - 20, y: self.frame.height - Status.height)
        status.fillColor = SKColor.blue()
        baseNode.addChild(status)
    }
    // 接触した時のイベント
    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyA.node?.name == "ship" {
            let shipNode = contact.bodyA.node!
            let enemyNode = contact.bodyB.node!
            createParticle(location: enemyNode.position)
            enemyNode.removeFromParent()
        }
        if contact.bodyB.node?.name == "ship" {
            let shipNode = contact.bodyB.node!
            let enemyNode = contact.bodyA.node!
            createParticle(location: enemyNode.position)
            enemyNode.removeFromParent()
        }
        
        if contact.bodyA.node?.name == "frame" {
            let enemyNode = contact.bodyB.node!
            enemyNode.removeFromParent()
        }
        if contact.bodyB.node?.name == "frame" {
            let enemyNode = contact.bodyA.node!
            enemyNode.removeFromParent()
        }
    }
    /// Sceneが表示された際に実行される
    override func didMove(to view: SKView) {
        let baseNode = SKNode()
        self.setupBackground(baseNode: baseNode)
        self.setupShip(baseNode: baseNode)
        self.setupStatus(baseNode: baseNode)
        timer = Timer.scheduledTimer(timeInterval: 2.0,target:self,
                                                       selector:#selector(GameScene.setupEnemy),
                                                       userInfo: nil, repeats: true);
        
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
    /// タップ開始イベント
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let action = SKAction.move(to: CGPoint(x: location.x, y: Ship.positionY), duration: 0.2)
            self.ship.run(action)
        }
    }
    /// タップ終了イベント
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let tapCount = touch.tapCount
            if tapCount > 1 {
                createShell(location: location)
                return
            }
        }
    }
    /// 1フレームごとに呼ばれる
    override func update(_ currentTime: TimeInterval) {
        //ship.position = CGPoint(x: ship.position.x + Ship.moveX, y: self.frame.midY)
    }
}
