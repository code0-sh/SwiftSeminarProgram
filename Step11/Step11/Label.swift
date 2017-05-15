//
//  Button.swift
//  Step11
//
//  Created by omura.522 on 2016/06/28.
//  Copyright © 2016年 omura.522. All rights reserved.
//

import SpriteKit

struct Label {
    static func setup(_ location: CGPoint, text: String, color: SKColor = SKColor.white, size: CGFloat = 30) -> SKLabelNode{
        let label = SKLabelNode()
        label.text = text
        label.fontSize = size
        label.fontColor = color
        label.fontName = "Chalkduster"
        label.position = location
        return label
    }
}
