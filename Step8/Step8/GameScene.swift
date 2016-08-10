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
    let lifeTime: Double = 5 // パーティクルのライフタイム
    let sound = SKAction.playSoundFileNamed("sound_explosion.mp3", waitForCompletion: false) // 効果音
    
    func setupParticle(location: CGPoint) {
        guard let particle = SKEmitterNode(fileNamed: "ConflictParticle.sks") else {
            return
        }
        particle.position = CGPoint(x: location.x, y: location.y)
      
        // タップするたびにパーティクルが増えて処理が重くなるため
        // パーティクルを表示してからlifeTime秒後に削除する
        let durationAction = SKAction.wait(forDuration: lifeTime)
        let removeAction = SKAction.removeFromParent()
        let sequenceAction = SKAction.sequence([sound, durationAction, removeAction])
        particle.run(sequenceAction)
      
        self.addChild(particle)
    }
    /// タップ開始イベント
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            setupParticle(location: location)
        }
    }
}
