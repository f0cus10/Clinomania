//
//  successHudView.swift
//  Clinomania
//
//  Created by Iftikhar A. Khan on 5/11/20.
//  Copyright © 2020 Iftikhar A. Khan. All rights reserved.
//

import UIKit

class successHudView: UIView {
    
    var displayText = ""
    
    // MARK: - Convenience constructor
    class func hud(containerView view: UIView, animated: Bool) -> successHudView {
        let hudView = successHudView(frame: view.bounds)
        hudView.isOpaque = false
        
        view.addSubview(hudView)
        view.isUserInteractionEnabled = false
        
        return hudView
    }
    
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        let boxWidth: CGFloat = 96
        let boxHeight: CGFloat = 96
        
        let boxRect = CGRect(x: round((bounds.size.width - boxWidth) / 2.0), y: round((bounds.size.height - boxHeight) / 2.0), width: boxWidth, height: boxHeight)
        
        let roundedRect = UIBezierPath(roundedRect: boxRect, cornerRadius: 10.0)
        UIColor(white: 0.3, alpha: 0.7).setFill()
        roundedRect.fill()
        
        if let image = UIImage(named: "icons8-checked") {
            let imageStartPoint = CGPoint(x: center.x - round(image.size.width / 2), y: center.y - round(image.size.height / 2) - boxHeight / 8)
            image.draw(at: imageStartPoint)
        }
        
        //draw the text
        let attribs = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor.white]
        let textSize = displayText.size(withAttributes: attribs)
        
        let textStartPoint = CGPoint(x: center.x - round(textSize.width / 2), y: center.y - round(textSize.height / 2) + boxHeight / 4)
        
        displayText.draw(at: textStartPoint, withAttributes: attribs)
    }

}
