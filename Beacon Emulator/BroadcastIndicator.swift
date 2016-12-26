//
//  BroadcastIndicator.swift
//  Beacon Emulator
//
//  Created by Patryk Romańczuk on 25/12/2016.
//  Copyright © 2016 AviadorApps. All rights reserved.
//

import UIKit

@IBDesignable
class BroadcastIndicator: UIControl {
    override func layoutSubviews() {
        contentMode = .redraw
    }
    
    override func draw(_ rect: CGRect) {
        let size = frame.width < frame.height ? frame.width : frame.height
        let padding = size * 0.1
        
        let context = UIGraphicsGetCurrentContext()!
        
        context.setLineWidth(padding)
        context.setStrokeColor(UIColor(red: 40 / 255.0, green: 122 / 255.0, blue: 169.0 / 255, alpha: 1.0).cgColor)
        let outerX = (frame.width - (size - padding)) / 2
        let outerY = (frame.height - (size - padding)) / 2
        let outerRim = CGRect(x: outerX, y: outerY, width: size - padding, height: size - padding)
        context.addEllipse(in: outerRim)
        
        let middleX = (frame.width - (size - padding * 5)) / 2
        let middleY = (frame.height - (size - padding * 5)) / 2
        let middleRim = CGRect(x: middleX, y: middleY, width: size - (padding * 5), height: size - (padding * 5))
        context.addEllipse(in: middleRim)
        
        let innerX = (frame.width - padding) / 2
        let innerY = (frame.height - padding) / 2
        let innerRim = CGRect(x: innerX, y: innerY, width: padding, height: padding)
        context.addEllipse(in: innerRim)
        
        context.strokePath()
    }
}
