//
//  GameScene.swift
//  Step7
//
//  Created by omura.522 on 2016/06/22.
//  Copyright © 2016年 omura.522. All rights reserved.
//

import SpriteKit
import GameplayKit

struct Ship {
    static let size: CGFloat = 50
    static let positionY: CGFloat = 100
}

struct Shell {
    static let radius: CGFloat = 5
    static let positionY: CGFloat = 110
    static let speed: CGFloat = 10
}

class GameScene: SKScene {
    let baseNode: SKNode? = nil
    var ship: SKSpriteNode!
    /// 飛行機の設定
    func setupShip(baseNode: SKNode) {
        let texture = SKTexture(imageNamed: "Spaceship")
        ship = SKSpriteNode(texture: texture)
        ship.size = CGSize(width: Ship.size, height: Ship.size)
        ship.position = CGPoint(x: self.frame.size.width / 2, y: Ship.positionY)
        baseNode.addChild(ship)
    }
    /// 弾丸の設定
    func createShell(location: CGPoint) {
        let shell = SKShapeNode(circleOfRadius: Shell.radius)
        shell.position = CGPoint(x: location.x, y: Shell.positionY)
        shell.fillColor = SKColor.red
        // 弾丸の移動
        let moveAction = SKAction.move(to: CGPoint(x: location.x, y: self.frame.size.height), duration: 5)
        // 弾丸の削除
        let removeAction = SKAction.removeFromParent()
        let sequenceAction = SKAction.sequence([moveAction, removeAction])
        shell.run(sequenceAction)
        self.addChild(shell)
    }
    /// Sceneが表示された際に実行される
    override func didMove(to view: SKView) {
        let baseNode = SKNode()
        setupShip(baseNode: baseNode)
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
            }
        }
    }
}
