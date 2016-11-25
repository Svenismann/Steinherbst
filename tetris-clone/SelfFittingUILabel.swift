//
//  SelfFittingUILabel.swift
//  tetris-clone
//
//  Created by Sven Forstner on 19.11.16.
//  Copyright © 2016 Sven Forstner. All rights reserved.
//

import Foundation
import UIKit

class LabelWithAdaptiveTextHeight: UILabel {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        font = fontToFitHeight()
    }
    
    // Returns an UIFont that fits the new label's height.
    private func fontToFitHeight() -> UIFont {
        
        var minFontSize: CGFloat = 15.0 // CGFloat 18
        var maxFontSize: CGFloat = 30.0     // CGFloat 67
        var fontSizeAverage: CGFloat = 0
        var textAndLabelHeightDiff: CGFloat = 0
        
        while (minFontSize <= maxFontSize) {
            
            fontSizeAverage = minFontSize + (maxFontSize - minFontSize) / 2
            
            // Abort if text happens to be nil
            guard (text?.characters.count)! > 0 else {
                break
            }
            
            if let labelText: NSString = text as NSString? {
                let labelHeight = frame.size.height
                
                let testStringHeight = labelText.size(
                    attributes: [NSFontAttributeName: font.withSize(fontSizeAverage)]
                    ).height
                
                textAndLabelHeightDiff = labelHeight - testStringHeight
                
                if (fontSizeAverage == minFontSize || fontSizeAverage == maxFontSize) {
                    if (textAndLabelHeightDiff < 0) {
                        return font.withSize(fontSizeAverage - 1)
                    }
                    return font.withSize(fontSizeAverage)
                }
                
                if (textAndLabelHeightDiff < 0) {
                    maxFontSize = fontSizeAverage - 1
                    
                } else if (textAndLabelHeightDiff > 0) {
                    minFontSize = fontSizeAverage + 1
                    
                } else {
                    return font.withSize(fontSizeAverage)
                }
            }
        }
        return font.withSize(fontSizeAverage)
    }
}
