//  
//  AuthtenticationServiceProtocol.swift
//  erxesiosdk
//
//  Created by Soyombo bat-erdene on 8/31/19.
//  Copyright © 2019 Soyombo bat-erdene. All rights reserved.
//

import Foundation
import Apollo
protocol AuthtenticationServiceProtocol {

    /// SAMPLE FUNCTION -* Please rename this function to your real function
    ///
    /// - Parameters:
    ///   - success: -- success closure response, add your Model on this closure.
    ///                 example: success(_ data: YourModelName) -> ()
    ///   - failure: -- failure closure response, add your Model on this closure.  
    ///                 example: success(_ data: APIError) -> ()
    func messengerConnect(brandCode:String,email:String!,phone:String!,data:Scalar_JSON!,success: @escaping(_ data: ConnectResponseModel) -> (), failure: @escaping(_ errorClosure: GraphQLError) -> ())
}
