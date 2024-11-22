//
//  DashedView.swift
//  Tatawei Organisation
//
//  Created by Wesam Kadah on 21/11/2024.
//

import UIKit

class DashedView: UIView {
    
    @IBInspectable var perDashLength: CGFloat = 2
    @IBInspectable var spaceBetweenDash: CGFloat = 2
    @IBInspectable var dashColor: UIColor = UIColor.lightGray
    @IBInspectable var isHorizontal: Bool = true // Toggle for orientation

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let path = UIBezierPath()
        
        if isHorizontal {
            // Draw horizontal line
            let p0 = CGPoint(x: self.bounds.minX, y: self.bounds.midY)
            path.move(to: p0)
            
            let p1 = CGPoint(x: self.bounds.maxX, y: self.bounds.midY)
            path.addLine(to: p1)
        } else {
            // Draw vertical line
            let p0 = CGPoint(x: self.bounds.midX, y: self.bounds.minY)
            path.move(to: p0)
            
            let p1 = CGPoint(x: self.bounds.midX, y: self.bounds.maxY)
            path.addLine(to: p1)
        }
        
        path.lineWidth = 2
        
        let dashes: [CGFloat] = [perDashLength, spaceBetweenDash]
        path.setLineDash(dashes, count: dashes.count, phase: 0.0)
        
        path.lineCapStyle = .butt
        dashColor.set()
        path.stroke()
    }
}

