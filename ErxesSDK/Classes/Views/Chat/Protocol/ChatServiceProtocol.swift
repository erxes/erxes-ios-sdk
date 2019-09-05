//  
//  ChatServiceProtocol.swift
//  erxesiosdk
//
//  Created by Soyombo bat-erdene on 8/19/19.
//  Copyright © 2019 Soyombo bat-erdene. All rights reserved.
//

import Foundation
import Apollo
protocol ChatServiceProtocol {


    func getMessages(conversationId:String,success: @escaping(_ data: [MessageModel]) -> (), failure: @escaping(_ errorClosure: GraphQLError) -> ())
    func conversationDetail(conversationId:String!,integrationId:String,success: @escaping(_ data: DetailResponse ) -> (), failure: @escaping(_ errorClosure: GraphQLError) -> ())
    func insertMessage(mutation:InsertMessageMutation,success: @escaping(_ data: MessageModel) -> (), failure: @escaping(_ errorClosure: GraphQLError) -> ())
    func readConversation(conversationId:String!,success: @escaping(_ data: Scalar_JSON ) -> (), failure: @escaping(_ errorClosure: GraphQLError) -> ())
}
