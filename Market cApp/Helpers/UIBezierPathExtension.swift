//
//  UIBezierPathExtension.swift
//  Market cApp
//
//  Created by David on 9/30/20.
//

import UIKit

extension UIBezierPath {
    
    convenience init(lineSegment: LineSegment) {
        self.init()
        self.move(to: lineSegment.startPoint)
        self.addLine(to: lineSegment.endPoint)
    }
}
