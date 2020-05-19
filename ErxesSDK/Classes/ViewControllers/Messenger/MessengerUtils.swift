//
//  MessengerUtils.swift
//  Erxes iOS SDK
//
//  Created by soyombo bat-erdene on 5/13/20.
//  Copyright © 2020 Soyombo bat-erdene. All rights reserved.
//

import Foundation

extension MessengerView {
    
    func isNewMessage(id: String) -> Bool {
        let temp = self.messages.filter { $0._id == id }
        if temp.count != 0 {
            return false
        } else {
            return true
        }
    }
    
}
