//  
//  KBCategoryService.swift
//  erxesiosdk
//
//  Created by Soyombo bat-erdene on 8/28/19.
//  Copyright © 2019 Soyombo bat-erdene. All rights reserved.
//

import Foundation
import Apollo

class KBCategoryService: KBCategoryServiceProtocol {
  
    // Call protocol function

    func knowledgeBaseCategoriesDetail(categoryId:String,success: @escaping (KbModel) -> (), failure: @escaping (GraphQLError) -> ()) {
        let query = KnowledgeBaseCategoriesDetailQuery(categoryId: categoryId)
        ErxesClient.shared.client.fetch(query: query) { result in
            guard let data = try? result.get().data else { return }
            if let dataModel = data.knowledgeBaseCategoriesDetail?.fragments.kbModel {
                success(dataModel)
            }
            if let errors = try? result.get().errors {
                failure(errors[0])
            }
            
        }
    }

}
