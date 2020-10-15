//
//  CALayerExtension.swift
//  Market cApp
//
//  Created by David on 9/30/20.
//

import UIKit

extension CALayer {
    
    func addLineLayer(lineSegment: LineSegment, color: CGColor, width: CGFloat, isDashed: Bool, animated: Bool, oldSegment: LineSegment?) {
        let layer = CAShapeLayer()
        layer.path = UIBezierPath(lineSegment: lineSegment).cgPath
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeColor = color
        layer.lineWidth = width
        if isDashed {
            layer.lineDashPattern = [4, 4]
        }
        self.addSublayer(layer)
        
        if animated, let segment = oldSegment {
            layer.animate(
                fromValue: UIBezierPath(lineSegment: segment).cgPath,
                toValue: layer.path!,
                keyPath: "path")
        }
    }
    
    func addTextLayer(frame: CGRect, color: CGColor, fontSize: CGFloat, text: String, animated: Bool, oldFrame: CGRect?) {
        let textLayer = CATextLayer()
        textLayer.frame = frame
        textLayer.foregroundColor = color
        textLayer.backgroundColor = UIColor.clear.cgColor
        textLayer.alignmentMode = CATextLayerAlignmentMode.center
        textLayer.contentsScale = UIScreen.main.scale
        textLayer.font = CTFontCreateWithName(UIFont.systemFont(ofSize: 0).fontName as CFString, 0, nil)
        textLayer.fontSize = fontSize
        textLayer.string = text
        self.addSublayer(textLayer)
        
        if animated, let oldFrame = oldFrame {
            // "frame" property is not animatable in CALayer, so, I use "position" instead
            // Position is at the center of the frame (if you don't change the anchor point)
            let oldPosition = CGPoint(x: oldFrame.midX, y: oldFrame.midY)
            textLayer.animate(fromValue: oldPosition, toValue: textLayer.position, keyPath: "position")
        }
    }
    
    func addRectangleLayer(frame: CGRect, color: CGColor, animated: Bool, oldFrame: CGRect?) {
        let layer = CALayer()
        layer.frame = frame
        layer.backgroundColor = color
        
        layer.cornerRadius = 5
        
        self.addSublayer(layer)
        
        if animated, let oldFrame = oldFrame {
            layer.animate(fromValue: CGPoint(x: oldFrame.midX, y: oldFrame.midY), toValue: layer.position, keyPath: "position")
            layer.animate(fromValue: CGRect(x: 0, y: 0, width: oldFrame.width, height: oldFrame.height), toValue: layer.bounds, keyPath: "bounds")
        }
        
    }
    
    func animate(fromValue: Any, toValue: Any, keyPath: String) {
        let anim = CABasicAnimation(keyPath: keyPath)
        anim.fromValue = fromValue
        anim.toValue = toValue
        anim.duration = 0.5
        anim.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        self.add(anim, forKey: keyPath)
    }
}
