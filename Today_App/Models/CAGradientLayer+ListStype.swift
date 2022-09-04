//
//  CAGradientLayer+ListStype.swift
//  Today_App
//
//  Created by Nhựt Dương on 9/5/22.
//

import UIKit

extension CAGradientLayer {
    static func gradientLayer(for style: ReminderListtyle, in frame: CGRect) -> Self {
        let layer = Self()
        layer.colors = color(for: style)
        layer.frame = frame
        return layer
    }
    
    private static func color(for stype: ReminderListtyle) -> [CGColor] {
        let beginColor: UIColor
        let endColor: UIColor
        
        switch stype {
        case .all:
            beginColor = .todayGradientAllBegin
            endColor = .todayGradientAllEnd
        case .future:
            beginColor = .todayGradientAllBegin
            endColor = .todayGradientAllEnd
        case .today:
            beginColor = .todayGradientAllBegin
            endColor = .todayGradientAllEnd
        }
        return [beginColor.cgColor, endColor.cgColor]
    }
}
