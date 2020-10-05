//
//  calculateLetterFrame.swift
//  calculateLetterFrame
//
//  Created by Chris Evans on 2020/10/5.
//

import UIKit

func calculateLetterFrame(_ str: String, size: CGSize, attributes: [NSAttributedString.Key : Any]) -> [String] {
    
    var cutStr = str
    
    var tempStrArr: [String] = []
    
    let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
    
    func cut() {
        
        let attStr = NSMutableAttributedString(string: cutStr, attributes: attributes)
        
        let frameSetter = CTFramesetterCreateWithAttributedString(attStr as CFAttributedString)
        let path: CGMutablePath = CGMutablePath()
        path.addRect(CGRect(x: 0, y: 0, width: rect.size.width, height: rect.height * 2), transform: .identity)
        
        let frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, 0), path, nil)
        
        guard var lines = CTFrameGetLines(frame) as? [CTLine] else {return}
        
        var H: CGFloat = 0
        var h: CGFloat = 0
        
        var ascent: CGFloat = 0
        var descent: CGFloat = 0
        var leading: CGFloat = 0
        
        for (i, line) in lines.enumerated() {
            
            CTLineGetTypographicBounds(line, &ascent, &descent, &leading)
            
            h = ascent + descent + leading
            
            H += h
            
            if H > rect.height {
                
                lines = Array(lines[0..<i])
                break
            }
        }
        
        if let lastLine = lines.last {
            
            let cFRange = CTLineGetStringRange(lastLine)
            
            /// Emoji support
            let tempStr = NSAttributedString.init(string: cutStr, attributes: attributes).attributedSubstring(from: NSRange(location: 0, length: cFRange.location + cFRange.length)).string
            
            tempStrArr.append(tempStr)
            cutStr = String(cutStr.suffix(cutStr.count - tempStr.count))
        }
    }
    
    while cutStr.count > 0 {
        
        cut()
    }
    
    return tempStrArr
}
