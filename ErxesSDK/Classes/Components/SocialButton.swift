//
//  SocialButton.swift
//  Erxes iOS SDK
//
//  Created by soyombo bat-erdene on 5/12/20.
//  Copyright © 2020 Soyombo bat-erdene. All rights reserved.
//

import UIKit

class SocialButton: UIButton {

    var params: Dictionary<String, Any>
    
    override init(frame: CGRect) {
        self.params = [:]
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.params = [:]
        super.init(coder: aDecoder)
    }
}
