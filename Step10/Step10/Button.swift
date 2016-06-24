//
//  Button.swift
//  Step10
//
//  Created by omura.522 on 2016/06/24.
//  Copyright © 2016年 omura.522. All rights reserved.
//

import SpriteKit

struct Button {
    static func setup(location: CGPoint, text: String, color: SKColor = SKColor.white(), size: CGFloat = 20) -> SKLabelNode{
        let label = SKLabelNode()
        label.text = text
        label.fontSize = size
        label.fontColor = color
        label.position = location
        return label
    }
}
