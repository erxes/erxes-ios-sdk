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
        let path = Router.erxesBundle()?.path(forResource: lang, ofType: "lproj")
        let bundle = Bundle(path: path!)
        return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
    }
}
