//
//  GameScene.swift
//  Step11
//
//  Created by omura.522 on 2016/06/24.
//  Copyright © 2016年 omura.522. All rights reserved.
//

import SpriteKit
import CoreMotion

class GameScene: SKScene, SKPhysicsContactDelegate {
    var shipNode: SKSpriteNode!
    var shipStatusNode: SKSpriteNode!
    var shellStatusNode: SKSpriteNode!
    var scoreNode: SKLabelNode!
    var timer = Timer();
    var shipStatus: ShipStatus!
    var shellStatus: ShellStatus!
    var score: Score!
    var ship: Ship!
    var motionManager: CMMotionManager = CMMotionManager()

    /// 背景画像の設定
    func setupBackground(baseNode: SKNode) {
        // 背景画像からテクスチャを作成
        let texture = SKTexture(imageNamed: Background.textureName)
        // フィルタリングモード（テクスチャの本来のサイズ以外で描画される場合に使用される）
        // .Linear クォリティー高い
        // .Nearest クォリティー低い
        texture.filteringMode = .nearest
        
        // 必要な画像枚数を算出
        let needHeightNumber = ceil(2 + (self.frame.size.height / texture.size().height))
        let needWidthNumber = ceil(self.frame.size.width / texture.size().width)

        // アニメーションを作成
        let moveAnim = SKAction.moveBy(x: 0, y: -texture.size().height, duration: TimeInterval(texture.size().height / 10.0))
        let resetAnim = SKAction.moveBy(x: 0, y: texture.size().height, duration: 0.0)
        let repeatForeverAnim = SKAction.repeatForever(SKAction.sequence([moveAnim, resetAnim]))
        
        // 画像の配置とアニメーションを設定
        for i in 0 ..< Int(needWidthNumber) + 1 {
            for j in 0 ..< Int(needHeightNumber) {
                let sprite = SKSpriteNode(texture: texture)
                sprite.zPosition = -100
                sprite.position = CGPoint(x: CGFloat(i) * sprite.size.width, y: CGFloat(j) * sprite.size.height)
                // アニメーションスピード
                sprite.speed = Background.sppedAnim
                sprite.run(repeatForeverAnim)
                baseNode.addChild(sprite)
            }
        }
    }
    /// 飛行機の設定
    func setupShip(baseNode: SKNode) {
        // 飛行機画像からテクスチャを作成
        let texture = SKTexture(imageNamed: Ship.textureName)
        // フィルタリングモード（テクスチャの本来のサイズ以外で描画される場合に使用される）
        // .Linear クォリティー高い
        // .Nearest クォリティー低
        texture.filteringMode = .nearest
        
        shipNode = SKSpriteNode(texture: texture)
        shipNode.size = CGSize(width: Ship.width, height: Ship.height)
        shipNode.position = CGPoint(x: self.frame.midX, y: Ship.positionY)
        shipNode.name = "ship"
        
        // 重力の影響なし
        shipNode.physicsBody = SKPhysicsBody(rectangleOf: shipNode.frame.size)
        shipNode.physicsBody?.affectedByGravity = false
        
        // 物体種別
        shipNode.physicsBody?.categoryBitMask = ColliderType.Ship
        // どの物体と接触した場合に衝突させるか
        shipNode.physicsBody?.collisionBitMask = ColliderType.World
        
        baseNode.addChild(shipNode)
    }
    /// エネミーの設定
    func setupEnemy() {
        // エネミー画像からテクスチャを作成
        let texture = SKTexture(imageNamed: Enemy.textureName)
        // フィルタリングモード（テクスチャの本来のサイズ以外で描画される場合に使用される）
        // .Linear クォリティー高い
        // .Nearest クォリティー低
        texture.filteringMode = .nearest
        
        let enemy = SKSpriteNode(texture: texture)
        enemy.size = CGSize(width: Enemy.radius * 2, height: Enemy.radius * 2)
        let randIntX = Enemy.radius + (CGFloat)(arc4random_uniform((UInt32)(self.frame.width - Enemy.radius * 2)))
        let randIntY = Enemy.radius + (CGFloat)(arc4random_uniform((UInt32)(self.frame.height / 2))) + self.frame.height / 2
        enemy.position = CGPoint(x:randIntX, y:randIntY)
        enemy.name = "enemy"
        
        // 重力
        enemy.physicsBody = SKPhysicsBody(circleOfRadius: Enemy.radius)
        enemy.physicsBody?.restitution = 1.0 // 反発係数
        enemy.physicsBody?.linearDamping = 0.0 // 空気抵抗
        enemy.physicsBody?.mass = 1.0 // 質量
        enemy.physicsBody?.friction = 0.0 // 摩擦
        
        // 物体種別
        enemy.physicsBody?.categoryBitMask = ColliderType.Enemy
        // どの物体と接触した場合に衝突させるか
        enemy.physicsBody?.collisionBitMask = ColliderType.Ship | ColliderType.World | ColliderType.Shell
        // どの物体と接触した場合にイベントを発生させるか
        enemy.physicsBody?.contactTestBitMask = ColliderType.Ship | ColliderType.World | ColliderType.Shell
            
        self.addChild(enemy)

    }
    /// 弾丸の設定
    func createShell(location: CGPoint) {
        let shell = SKShapeNode(circleOfRadius: Shell.radius)
        shell.position = CGPoint(x: location.x, y: Shell.positionY)
        shell.fillColor = UIColor.red
        shell.name = "shell"
        // 弾丸の移動
        let moveAction = SKAction.move(to: CGPoint(x: location.x, y: self.frame.size.height), duration: 5.0)
        // 弾丸の削除
        let removeAction = SKAction.removeFromParent()
        let sequenceAction = SKAction.sequence([moveAction, removeAction])
        shell.run(sequenceAction)
        
        // 重力の影響なし
        shell.physicsBody = SKPhysicsBody(rectangleOf: shell.frame.size)
        shell.physicsBody?.isDynamic = false
        shell.physicsBody?.affectedByGravity = false
        
        // 物体種別
        shell.physicsBody?.categoryBitMask = ColliderType.Shell
        
        self.addChild(shell)
    }
    /// パーティクルの設定
    func createParticle(location: CGPoint) {
        let particle = SKEmitterNode(fileNamed: Particle.fileName)
        particle?.position = CGPoint(x: location.x, y: location.y)
        self.addChild(particle!)
        
        // タップするたびにパーティクルが増えて処理が重くなるため
        // パーティクルを表示してから1秒後に削除する
        let removeAction = SKAction.removeFromParent()
        let durationAction = SKAction.wait(forDuration: 1.0)
        let sequenceAction = SKAction.sequence([durationAction, removeAction])
        particle?.run(sequenceAction)
    }
    /// 飛行機のステータスの設定
    func setupShipStatus(baseNode: SKNode) {
        shipStatusNode = SKSpriteNode(color: ShipStatus.color, size: CGSize(width: ShipStatus.width, height: ShipStatus.height))
        shipStatusNode.position = CGPoint(x: self.frame.midX, y: self.frame.height - ShipStatus.height)
        shipStatusNode.anchorPoint = CGPoint(x: 0, y: 0)
        baseNode.addChild(shipStatusNode)
    }
    /// 弾丸のステータスの設定
    func setupShellStatus(baseNode: SKNode) {
        shellStatusNode = SKSpriteNode(color: ShellStatus.color, size: CGSize(width: ShellStatus.width, height: ShellStatus.height))
        shellStatusNode.position = CGPoint(x: self.frame.midX, y: self.frame.height - ShipStatus.height - ShellStatus.height)
        shellStatusNode.anchorPoint = CGPoint(x: 0, y: 0)
        baseNode.addChild(shellStatusNode)
    }
    /// 飛行機のステータス更新
    func updateShipStatus() {
        if shipStatus?.scaleX > 0 {
            shipStatus?.scaleX -= 1
            let scaleAction = SKAction.scaleX(to: CGFloat(shipStatus.scaleX)/10.0, duration: 1.0)
            scaleAction.timingMode = .easeIn
            shipStatusNode.run(scaleAction)
        }
        // Game Over
        if shipStatus?.point <= 1 {
            timer.invalidate() // タイマー停止
            let transition = SKTransition.reveal(with: SKTransitionDirection.down, duration: 1.0)
            let newScene = ResultScene()
            newScene.size = self.frame.size
            setUserData(scene: newScene)
            view?.presentScene(newScene, transition: transition)
        }
        shipStatus?.point -= 1
    }
    /// 弾丸のステータス更新
    func updateShellStatus() {
        if shellStatus?.scaleX > 0 {
            shellStatus?.scaleX -= 1
            let scaleAction = SKAction.scaleX(to: CGFloat(shellStatus.scaleX)/100.0, duration: 1.0)
            scaleAction.timingMode = .easeIn
            shellStatusNode.run(scaleAction)
        }
        // 弾丸切れ
        if shellStatus?.point <= 1 {
            timer.invalidate() // タイマー停止
            let transition = SKTransition.reveal(with: SKTransitionDirection.down, duration: 1.0)
            let newScene = ResultScene()
            newScene.size = self.frame.size
            setUserData(scene: newScene)
            view?.presentScene(newScene, transition: transition)
        }
        shellStatus?.point -= 1
    }
    /// スコアの設定
    func setupScore(baseNode: SKNode) {
        // ラベルのフォントを指定しインスタンスを生成する
        scoreNode = SKLabelNode(fontNamed: Score.fontName)
        // ラベルに表示する文字列
        scoreNode.text = "スコア:\(score.point)ポイント"
        // ラベルの文字サイズ
        scoreNode.fontSize = Score.fontSize
        // ラベルの文字色
        scoreNode.fontColor = Score.fontColor
        // ラベルの位置
        scoreNode.position = CGPoint(x: self.frame.midX, y: self.frame.height - ShipStatus.height - ShellStatus.height - 50);
        
        baseNode.addChild(scoreNode)
    }
    /// スコア更新
    func updateScorePoint() {
        score?.point += 1
        scoreNode.text = "スコア:\(score.point)ポイント"
    }
    /// 遷移先のSceneのuserDataにスコアを保存
    func setUserData(scene: SKScene) {
        scene.userData = NSMutableDictionary()
        scene.userData?.setObject(score.point, forKey: "score")
    }
    /// 接触時のイベント
    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyA.node?.name == "ship" {
            guard let enemyNode = contact.bodyB.node else {
                return
            }
            createParticle(location: enemyNode.position)
            enemyNode.removeFromParent()
            updateShipStatus()
        }
        if contact.bodyB.node?.name == "ship" {
            guard let enemyNode = contact.bodyA.node else {
                return
            }
            createParticle(location: enemyNode.position)
            enemyNode.removeFromParent()
            updateShipStatus()
        }
        
        if contact.bodyA.node?.name == "shell" {
            guard let shellNode = contact.bodyA.node, let enemyNode = contact.bodyB.node else {
                return
            }
            createParticle(location: enemyNode.position)
            shellNode.removeFromParent()
            enemyNode.removeFromParent()
            updateScorePoint()

        }
        if contact.bodyB.node?.name == "shell" {
            guard let shellNode = contact.bodyB.node, let enemyNode = contact.bodyA.node else {
                return
            }
            createParticle(location: enemyNode.position)
            shellNode.removeFromParent()
            enemyNode.removeFromParent()
            updateScorePoint()
        }
        
        if contact.bodyA.node?.name == "frame" {
            guard let enemyNode = contact.bodyB.node else {
                return
            }
            enemyNode.removeFromParent()
        }
        if contact.bodyB.node?.name == "frame" {
            guard let enemyNode = contact.bodyA.node else {
                return
            }
            enemyNode.removeFromParent()
        }
    }
    /// 加速度データを使用し飛行機の位置を更新する
    func setupMotionManager() {
        motionManager.accelerometerUpdateInterval = 0.1
        // 加速度センサーを使用開始
        motionManager.startAccelerometerUpdates(to: OperationQueue.current!, withHandler: { data, error in
          guard let data = data else { return }        
          self.ship.moveX = CGFloat(data.acceleration.x) * 20
        })
    }
    /// ステータスとスコアの初期化
    func initSetting() {
        shipStatus = ShipStatus()
        shellStatus = ShellStatus()
        score = Score()
        ship = Ship()
    }
    /// Sceneが表示された際に実行される
    override func didMove(to view: SKView) {
        initSetting()
        setupMotionManager()
        let baseNode = SKNode()
        setupBackground(baseNode: baseNode)
        setupShip(baseNode: baseNode)
        setupShipStatus(baseNode: baseNode)
        setupShellStatus(baseNode: baseNode)
        setupScore(baseNode: baseNode)
        timer = Timer.scheduledTimer(timeInterval: Enemy.appearanceInterval,
                                     target:self,
                                     selector:#selector(GameScene.setupEnemy),
                                     userInfo: nil,
                                     repeats: true)
        // 重力
        self.physicsWorld.gravity = CGVector(dx: 0.0, dy: -0.5)
        self.physicsWorld.contactDelegate = self
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        self.name = "frame"
        
        // 物体種別
        self.physicsBody?.categoryBitMask = ColliderType.World
        // どの物体と接触した場合に衝突させるか
        self.physicsBody?.collisionBitMask = ColliderType.Enemy | ColliderType.Ship
        
        self.addChild(baseNode)
    }
    /// タップ開始イベント
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for _ in touches {
            if shellStatus.point > 0 {
                createShell(location: shipNode.position)
                updateShellStatus()
            }
        }
    }
    /// 1フレームごとに呼ばれる
    override func update(_ currentTime: TimeInterval) {
        shipNode.position = CGPoint(x: shipNode.position.x + ship.moveX, y: Ship.positionY)
    }
}
