//  
//  AuthtenticationService.swift
//  Erxes iOS SDK
//
//  Created by soyombo bat-erdene on 4/30/20.
//  Copyright © 2020 Soyombo bat-erdene. All rights reserved.
//

import Foundation


class AuthtenticationService: AuthtenticationServiceProtocol {
    // Call protocol function

    func authenticate(type: String, value: String, success: @escaping (Scalar_JSON) -> (), failure: @escaping (String) -> ()) {
        let mutation = WidgetsSaveCustomerGetNotifiedMutation(customerId: customerId, type: type, value: value)
        ErxesClient.shared.client.perform(mutation: mutation) { result in
            switch result {
                
            case .success(let graphQLResult):
                
                if let response = graphQLResult.data?.widgetsSaveCustomerGetNotified{
                    
                    success(response)
                }
                
                if let errors = graphQLResult.errors {
                    
                    let error = errors.compactMap({ $0.localizedDescription }).joined(separator: ", ")
                    failure(error)
                    
                }
            case .failure(let error):
                failure(error.localizedDescription)
            }
            
        }
    }

}
