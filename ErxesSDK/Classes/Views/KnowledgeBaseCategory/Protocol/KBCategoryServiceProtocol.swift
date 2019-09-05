//  
//  KBCategoryServiceProtocol.swift
//  erxesiosdk
//
//  Created by Soyombo bat-erdene on 8/28/19.
//  Copyright © 2019 Soyombo bat-erdene. All rights reserved.
//

import Foundation
import Apollo
protocol KBCategoryServiceProtocol {

  
   
    func knowledgeBaseCategoriesDetail(categoryId:String,success: @escaping(_ data: KbModel) -> (), failure: @escaping(_ errorClosure: GraphQLError) -> ())
}
