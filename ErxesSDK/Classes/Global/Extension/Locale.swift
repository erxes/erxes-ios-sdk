//
//  Locale.swift
//  
//
//  Created by Soyombo bat-erdene on 8/15/19.
//

import Foundation
extension String {
    func localized(_ lang:String) ->String {
       
        
        let path = Erxes.erxesBundle().path(forResource: lang, ofType: "lproj")
        let bundle = Bundle(path: path!)
        return NSLocalizedString(self, tableName: nil, bundle: bundle ?? Erxes.erxesBundle(), value: "", comment: "")
    }}
