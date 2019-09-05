//
//  ErxesFontKit.swift
//  erxes-ios
//
//  Created by Soyombo bat-erdene on 8/20/18.
//  Copyright © 2018 Erxes Inc. All rights reserved.
//

import Foundation
import UIKit
import CoreText





public extension UIFont {
    class func erxes(of size: CGFloat) -> UIFont {
//        UIFont.registerFontWithFilenameString(filenameString:"erxes.ttf",bundle:erxesBundle())
        
        return UIFont(name: "erxes", size: size)!
    }
}

public extension String {

    static func erxes(with name: ErxesFont) -> String {
        let substr = name.rawValue[..<name.rawValue.index(name.rawValue.startIndex, offsetBy: 1)]
        return String(substr)
        
    }
    
}

public extension UIImage {

    static func erxes(with name: ErxesFont,
                               textColor: UIColor,
                               size: CGSize = CGSize(width: 20, height: 20),
                               backgroundColor: UIColor = UIColor.clear) -> UIImage {
        
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = NSTextAlignment.center
        let fontSize = min(size.width, size.height) - 6
        let attributedString = NSAttributedString(
            string: String.erxes(with: name),
            attributes: [
                NSAttributedString.Key.font: UIFont.erxes(of: fontSize),
                NSAttributedString.Key.foregroundColor: textColor,
                NSAttributedString.Key.backgroundColor: backgroundColor,
                NSAttributedString.Key.paragraphStyle: paragraph
            ]
        )
        
        UIGraphicsBeginImageContextWithOptions(size, false , 0.0)
        attributedString.draw(in:
            CGRect(
                x: 0,
                y: (size.height - fontSize) / 2,
                width: size.width,
                height: fontSize
            )
        )
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
    
}
