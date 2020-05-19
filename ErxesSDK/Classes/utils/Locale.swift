//
//  Locale.swift
//
//
//  Created by Soyombo bat-erdene on 8/15/19.
//

import Foundation
extension String {
    func localized(_ lang: String) -> String {
                
        if let path = Erxes.erxesBundle().path(forResource: lang, ofType: "json") {
            do {
                
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)

                if let jsonResult = jsonResult as? [String: String] {
                    if (jsonResult[self] != nil) {
                        return jsonResult[self]!
                    }else {
                        return self
                    }
                    
                }
            } catch {
                print("Failed to load locale: ", lang)
            }
        }
        return ""
    }
}
