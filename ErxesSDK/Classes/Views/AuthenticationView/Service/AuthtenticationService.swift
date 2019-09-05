//  
//  AuthtenticationService.swift
//  erxesiosdk
//
//  Created by Soyombo bat-erdene on 8/31/19.
//  Copyright © 2019 Soyombo bat-erdene. All rights reserved.
//

import Foundation
import Apollo

class AuthtenticationService: AuthtenticationServiceProtocol {
    func messengerConnect(brandCode: String, email: String! = "", phone: String! = "", data:Scalar_JSON! = nil,success: @escaping (ConnectResponseModel) -> (), failure: @escaping (GraphQLError) -> ()) {
        
        let mutation = MessengerConnectMutation(brandCode:brandCode,isUser:false)
        mutation.email = email
        mutation.phone = phone
        mutation.data = data
        ErxesClient.shared.client.perform(mutation: mutation) { result in
            guard let data = try? result.get().data else { return }
            if let dataModel:ConnectResponseModel = data.messengerConnect!.fragments.connectResponseModel {
                success(dataModel)
            }
            if let errors = try? result.get().errors {
                failure(errors[0])
            }
            
        }
    }
    
    // Call protocol function


}
