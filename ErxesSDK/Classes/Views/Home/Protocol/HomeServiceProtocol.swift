//  
//  RegisterServiceProtocol.swift
//  erxesiosdk
//
//  Created by Soyombo bat-erdene on 7/17/19.
//  Copyright © 2019 Soyombo bat-erdene. All rights reserved.
//

import Foundation
import Apollo
protocol HomeServiceProtocol {

    
   

    func messengerConnect(brandCode: String, email: String!, phone: String!,customerId:String!,data:Scalar_JSON!, success: @escaping(_ data: ConnectResponseModel) -> (), failure: @escaping(_ errorClosure: GraphQLError) -> ())
    func allConversations(integrationId:String, customerId:String,success: @escaping(_ data: [ConversationModel]) -> (), failure: @escaping(_ errorClosure: GraphQLError) -> ())
    func messengerSupporters(integrationId:String ,success: @escaping(_ data: [UserModel]) -> (), failure: @escaping(_ errorClosure: GraphQLError) -> ())
    func formConnect(brandCode:String,formCode:String ,success: @escaping(_ data: FormConnectModel) -> (), failure: @escaping(_ errorClosure: GraphQLError) -> ())
    func knowledgeBaseTopic(topicId:String ,success: @escaping(_ data: KnowledgeBaseTopicModel) -> (), failure: @escaping(_ errorClosure: GraphQLError) -> ())
    func unreadCount(conversationId:String ,success: @escaping(_ data: Int) -> (), failure: @escaping(_ errorClosure: GraphQLError) -> ())
}
