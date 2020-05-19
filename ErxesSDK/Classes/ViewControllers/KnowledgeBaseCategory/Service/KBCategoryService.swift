//  
//  KBCategoryService.swift
//  erxesiosdk
//
//  Created by Soyombo bat-erdene on 8/28/19.
//  Copyright © 2019 Soyombo bat-erdene. All rights reserved.
//

import Foundation


class KBCategoryService: KBCategoryServiceProtocol {
  
    // Call protocol function

    func knowledgeBaseCategoriesDetail(categoryId:String,success: @escaping (KbModel) -> (),failure: @escaping(_ errorClosure: String) -> ()) {
        let query = KnowledgeBaseCategoryDetailQuery(id: categoryId)
        ErxesClient.shared.client.fetch(query: query) { result in
            switch result {
                
            case .success(let graphQLResult):
                
                if let response = graphQLResult.data?.knowledgeBaseCategoryDetail?.fragments.kbModel {
                    
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
