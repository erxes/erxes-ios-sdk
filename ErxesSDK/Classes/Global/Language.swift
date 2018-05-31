//
//  Language.swift
//  ErxesSDK
//
//  Created by purevee on 5/28/18.
//

import UIKit

extension String {
    var localized: String {
        if let _ = UserDefaults.standard.string(forKey: "languageCode") {} else {
            UserDefaults.standard.set("mn", forKey: "languageCode")
            UserDefaults.standard.synchronize()
        }
        let lang = UserDefaults.standard.string(forKey: "languageCode")
        
        let bundle = Bundle(for:RegisterVC.self)
        let url = bundle.url(forResource: "ErxesSDK", withExtension: "bundle")
        let b = Bundle(url: url!)
        
        let path = b?.path(forResource: lang, ofType: "lproj")
        let b2 = Bundle(path: path!)
        
        return NSLocalizedString(self, tableName: nil, bundle: b2!, value: "", comment: "")
    }
}
