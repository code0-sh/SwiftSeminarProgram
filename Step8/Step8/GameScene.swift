//
//  GameScene.swift
//  Step8
//
//  Created by omura.522 on 2016/06/22.
//  Copyright © 2016年 omura.522. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    // 効果音
    let sound = SKAction.playSoundFileNamed("sound", waitForCompletion: false)
    
    func setupParticle(location: CGPoint) {
        let particle = SKEmitterNode(fileNamed: "ConflictParticle.sks")
        particle?.position = CGPoint(x: location.x, y: location.y)
        self.addChild(particle!)
        
        // タップするたびにパーティクルが増えて処理が重くなるため
        // パーティクルを表示してから1秒後に削除する
        let removeAction = SKAction.removeFromParent()
        let durationAction = SKAction.wait(forDuration: 1)
        let sequenceAction = SKAction.sequence([sound, durationAction, removeAction])
        particle?.run(sequenceAction)
    }
    /// Sceneが表示された際に実行される
    override func didMove(to view: SKView) {
        let baseNode = SKNode()
        self.addChild(baseNode)
    }
    /// タップ開始イベント
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            setupParticle(location: location)
        }
    }
}
