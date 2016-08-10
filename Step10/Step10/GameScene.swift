//
//  GameScene.swift
//  Step10
//
//  Created by omura.522 on 2016/06/24.
//  Copyright © 2016年 omura.522. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    var gameLabel: SKLabelNode!
    var scoreLabel: SKLabelNode!
    var score: Int = 0
    
    /// 得点加算
    func incrementScore() {
        score += 1
    }
    /// 顔文字更新
    func updateEmoticon() {
        if score % 2 == 0 {
            gameLabel.text = "\\(^^)/"
        } else {
            gameLabel.text = "/(^^)\\"
        }
    }
    /// 遷移先のSceneのUserDataにスコアを保存
    func setUserData(scene: SKScene) {
        scene.userData = NSMutableDictionary()
        scene.userData?.setObject(score, forKey: "score")
    }
    /// Sceneが表示された際に実行される
    override func didMove(to view: SKView) {
        let baseNode = SKNode()
        gameLabel = Button.setup(location: CGPoint(x: self.frame.midX, y: self.frame.midY), text: "\\(^^)/")
        scoreLabel = Button.setup(location: CGPoint(x: self.frame.midX, y: self.frame.midY - 50), text: "タップすると得点加算")
        baseNode.addChild(gameLabel)
        baseNode.addChild(scoreLabel)
        self.addChild(baseNode)
    }
    /// タッチ開始イベント
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touche in touches {
            let location = touche.location(in: self)
            // Gameラベルタッチ
            if gameLabel.contains(location) {
                let transition = SKTransition.reveal(with: SKTransitionDirection.down, duration: 1.0)
                let newScene = ResultScene()
                newScene.size = self.frame.size
                setUserData(scene: newScene)
                view?.presentScene(newScene, transition: transition)
            }
            // Scoreラベルタッチ
            if scoreLabel.contains(location) {
                incrementScore()
                updateEmoticon()
            }
        }
    }
}
