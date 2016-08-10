//
//  Setting.swift
//  Step11
//
//  Created by omura.522 on 2016/06/28.
//  Copyright © 2016年 omura.522. All rights reserved.
//

import SpriteKit

/// 衝突判定用のビット値
struct ColliderType {
    static let Ship: UInt32 = 0x1 << 0
    static let Shell: UInt32 = 0x1 << 1
    static let Enemy: UInt32 = 0x1 << 2
    static let World: UInt32 = 0x1 << 3
}
/// 背景情報
struct Background {
    static let textureName: String = "background"
    static let sppedAnim: CGFloat = 20
}
/// 飛行機情報
struct Ship {
    static let textureName: String = "Spaceship"
    static let width: CGFloat = 100
    static let height: CGFloat = 100
    static let positionY: CGFloat = 100
    var moveX: CGFloat
    init() {
        self.moveX = 0
    }
}
/// 弾丸情報
struct Shell {
    static let radius: CGFloat = 5
    static let positionY: CGFloat = 110
    static let speed: CGFloat = 10
}
/// エネミー情報
struct Enemy {
    static let textureName: String = "enemy"
    static let radius: CGFloat = 20
    static let appearanceInterval: Double = 2
}
/// パーティクル情報
struct Particle {
    static let fileName: String = "ConflictParticle.sks"
}
/// 飛行機のステータス情報
struct ShipStatus {
    static let width: CGFloat = 100
    static let height: CGFloat = 30
    static let color: SKColor = SKColor.blue
    var point: Int
    var scaleX: Int
    init() {
        self.point = 10
        self.scaleX = 10
    }
}
/// 弾丸のステータス情報
struct ShellStatus {
    static let width: CGFloat = 100
    static let height: CGFloat = 30
    static let color: SKColor = SKColor.yellow
    var point: Int
    var scaleX: Int
    init() {
        self.point = 100
        self.scaleX = 100
    }
}
/// スコア情報
struct Score {
    static let fontSize: CGFloat = 20
    static let fontColor: SKColor = SKColor.green
    static let fontName: String = "Chalkduster"
    var point: Int
    init() {
        self.point = 0
    }
}
