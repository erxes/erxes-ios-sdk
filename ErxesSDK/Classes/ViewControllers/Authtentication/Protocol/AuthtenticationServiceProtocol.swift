//  
//  AuthtenticationServiceProtocol.swift
//  Erxes iOS SDK
//
//  Created by soyombo bat-erdene on 4/30/20.
//  Copyright © 2020 Soyombo bat-erdene. All rights reserved.
//

import Foundation

protocol AuthtenticationServiceProtocol {

    func authenticate(type:String,value:String,success: @escaping(_ data: Scalar_JSON) -> (), failure: @escaping(_ errorClosure: String) -> ())

}

