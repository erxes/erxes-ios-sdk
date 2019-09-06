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



private var fontloaded = false
public func loadFont(){
    if fontloaded {
        return
    }
    fontloaded = true
    let frameworkBundle = Bundle(identifier: "org.cocoapods.ErxesFont")!
    let bundleURL = frameworkBundle.resourceURL?.appendingPathComponent("ErxesFont.bundle")
    let resourceBundle = Bundle(url: bundleURL!)!
    UIFont.registerFontWithFilenameString(filenameString:"erxes.ttf",bundle:resourceBundle)
}


public extension UIFont {
    class func erxes(of size: CGFloat) -> UIFont {
        loadFont()
        let name = "erxes"
        return UIFont(name: name, size: size)!
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


public extension UIFont {
    static func registerFontWithFilenameString(filenameString: String, bundle: Bundle) {
        
        _ = UIFont.familyNames
        guard let pathForResourceString = bundle.path(forResource: filenameString, ofType: nil) else {
            print("UIFont+:  Failed to register font - path for resource not found.")
            return
        }
        
        guard let fontData = NSData(contentsOfFile: pathForResourceString) else {
            print("UIFont+:  Failed to register font - font data could not be loaded.")
            return
        }
        
        guard let dataProvider = CGDataProvider(data: fontData) else {
            print("UIFont+:  Failed to register font - data provider could not be loaded.")
            return
        }
        
        guard let fontRef = CGFont(dataProvider) else {
            print("UIFont+:  Failed to register font - font could not be loaded.")
            return
        }
        
        var errorRef: Unmanaged<CFError>? = nil
        if (CTFontManagerRegisterGraphicsFont(fontRef, &errorRef) == false) {
            print("UIFont+:  Failed to register font - register graphics font failed - this font may have already been registered in the main bundle.")
        }
    }
}
