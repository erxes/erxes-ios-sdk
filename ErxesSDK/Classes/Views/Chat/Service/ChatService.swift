//
//  ChatService.swift
//  erxesiosdk
//
//  Created by Soyombo bat-erdene on 8/19/19.
//  Copyright © 2019 Soyombo bat-erdene. All rights reserved.
//

import Foundation
import Apollo

class ChatService: ChatServiceProtocol {




    func conversationDetail(conversationId: String!, integrationId: String, success: @escaping (DetailResponse) -> (), failure: @escaping (GraphQLError) -> ()) {
        let query = ConversationDetailQuery(id: conversationId, integrationId: integrationId)
        ErxesClient.shared.client.fetch(query: query, cachePolicy: .fetchIgnoringCacheCompletely) { result in
            guard let data = try? result.get().data else { return }
            if let dataModel = data.conversationDetail {

                success(dataModel.fragments.detailResponse)
            }
            if let errors = try? result.get().errors {
                failure(errors[0])
            }
        }
    }

    func insertMessage(mutation: InsertMessageMutation, success: @escaping (MessageModel) -> (), failure: @escaping (GraphQLError) -> ()) {
        ErxesClient.shared.client.perform(mutation: mutation) { result in
            guard let data = try? result.get().data else { return }
            if let model = data.insertMessage?.fragments.messageModel {
                success(model)
            }

            if let errors = try? result.get().errors {
                failure(errors[0])
            }
        }
    }


    func getMessages(conversationId: String, success: @escaping ([MessageModel]) -> (), failure: @escaping (GraphQLError) -> ()) {
        let query = MessagesQuery(conversationId: conversationId)
        ErxesClient.shared.client.fetch(query: query, cachePolicy: .fetchIgnoringCacheCompletely) { result in
            guard let data = try? result.get().data else { return }
            if let dataModel = data.messages {
                
                success(dataModel.map { ($0?.fragments.messageModel)! })
            }
            if let errors = try? result.get().errors {
                failure(errors[0])
            }

        }
    }



    func readConversation(conversationId: String!, success: @escaping (Scalar_JSON) -> (), failure: @escaping (GraphQLError) -> ()) {
        let mutation = ReadConversationMessagesMutation(conversationId: conversationId)
        ErxesClient.shared.client.perform(mutation: mutation) { result in
            guard let data = try? result.get().data else { return }
            if let model = data.readConversationMessages {
                success(model)
            }

            if let errors = try? result.get().errors {
                failure(errors[0])
            }
        }

    }
}
