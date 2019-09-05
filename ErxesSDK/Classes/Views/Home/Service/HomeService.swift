//  
//  RegisterService.swift
//  erxesiosdk
//
//  Created by Soyombo bat-erdene on 7/17/19.
//  Copyright © 2019 Soyombo bat-erdene. All rights reserved.
//

import Foundation
import Apollo


class HomeService: HomeServiceProtocol {
    func formConnect(brandCode: String, formCode: String, success: @escaping (FormConnectModel) -> (), failure: @escaping (GraphQLError) -> ()) {
//        let mutation = FormConnectMutation(brandCode:"ftnq6K",formCode: "yKPpuu")
//        ErxesClient.shared.client.perform(mutation: mutation) { result in
//            guard let data = try? result.get().data else { return }
//            if let dataModel:FormConnectModel = data.formConnect!.fragments.formConnectModel {
//                success(dataModel)
//            }
//            if let errors = try? result.get().errors {
//                failure(errors[0])
//            }
//            
//        }
    }
    
    func allConversations(integrationId: String, customerId: String, success: @escaping ([ConversationModel]) -> (), failure: @escaping (GraphQLError) -> ()) {
        let query = AllConversationsQuery(integrationId: integrationId,customerId: customerId)
        ErxesClient.shared.client.fetch(query: query,cachePolicy: .fetchIgnoringCacheData) { result in
            guard let data = try? result.get().data else { return }
            if let dataModel = data.conversations {
                success(dataModel.map{($0?.fragments.conversationModel)!})
            }
            if let errors = try? result.get().errors {
                failure(errors[0])
            }
            
        }
    }
    
 

    
    func messengerSupporters(integrationId: String, success: @escaping ([UserModel]) -> (), failure: @escaping (GraphQLError) -> ()) {
        let query = MessengerSupportersQuery(integrationId: integrationId)
        ErxesClient.shared.client.fetch(query: query) { result in
            guard let data = try? result.get().data else { return }
            if let dataModel = data.messengerSupporters {
                success(dataModel.map{(($0?.fragments.userModel)!)})
            }
            if let errors = try? result.get().errors {
                failure(errors[0])
            }
            
        }
    }
    
 
   
  
    
    
    func messengerConnect(brandCode: String, email: String! = "", phone: String! = "",customerId:String! = "",data:Scalar_JSON! = nil, success: @escaping (ConnectResponseModel) -> (), failure: @escaping (GraphQLError) -> ()) {
        let mutation = MessengerConnectMutation(brandCode:brandCode,isUser:false)
        mutation.email = email
        mutation.phone = phone
        mutation.cachedCustomerId = customerId
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
    
  
    func knowledgeBaseTopic(topicId: String, success: @escaping (KnowledgeBaseTopicModel) -> (), failure: @escaping (GraphQLError) -> ()) {
        let query = KnowledgeBaseTopicsDetailQuery(topicId: topicId)
        ErxesClient.shared.client.fetch(query: query) { result in
            guard let data = try? result.get().data else { return }
            if let dataModel = data.knowledgeBaseTopicsDetail?.fragments.knowledgeBaseTopicModel {
                success(dataModel)
            }
            if let errors = try? result.get().errors {
                failure(errors[0])
            }
            
        }
    }
 
    func unreadCount(conversationId: String, success: @escaping (Int) -> (), failure: @escaping (GraphQLError) -> ()) {
        let query = UnreadCountQuery(conversationId: conversationId)
        ErxesClient.shared.client.fetch(query: query, cachePolicy: .fetchIgnoringCacheData) { result in
            guard let data = try? result.get().data else { return }
            if let dataModel = data.unreadCount{
                success(dataModel)
            }
            if let errors = try? result.get().errors {
                failure(errors[0])
            }
            
        }
    }
    
}
