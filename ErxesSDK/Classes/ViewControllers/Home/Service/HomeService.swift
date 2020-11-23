//
//  HomeService.swift
//  Erxes iOS SDK
//
//  Created by soyombo bat-erdene on 4/30/20.
//  Copyright © 2020 Soyombo bat-erdene. All rights reserved.
//

import Foundation


class HomeService: HomeServiceProtocol {
    // Call protocol function

    func widgetsMessengerSupporters(success: @escaping ([UserModel]) -> (), failure: @escaping (String) -> ()) {
        let query = WidgetsMessengerSupportersQuery(integrationId: integrationId)

        ErxesClient.shared.client.fetch(query: query, cachePolicy: .fetchIgnoringCacheData) { result in

            switch result {

            case .success(let graphQLResult):

                if let response = graphQLResult.data?.widgetsMessengerSupporters?.fragments.messengerSupportersModel.supporters?.compactMap({$0?.fragments.userModel}) {
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

    func widgetsConversations(success: @escaping ([ConversationModel]) -> (), failure: @escaping (String) -> ()) {

        let query = WidgetsConversationsQuery(integrationId: integrationId, customerId: customerId)

        ErxesClient.shared.client.fetch(query: query, cachePolicy: .fetchIgnoringCacheCompletely) { result in

            switch result {

            case .success(let graphQLResult):

                if let response = graphQLResult.data?.widgetsConversations?.compactMap({ $0?.fragments.conversationModel }) {
 
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

    func widgetsLeadConnect(success: @escaping (LeadResponseModel) -> (), failure: @escaping (String) -> ()) {
        let mutation = WidgetsLeadConnectMutation(brandCode: brandCode, formCode: formCode)

        ErxesClient.shared.client.perform(mutation: mutation) { result in

            switch result {

            case .success(let graphQLResult):

                if let response = graphQLResult.data?.widgetsLeadConnect?.fragments.leadResponseModel {

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

    func formDetail(id: String, success: @escaping (FormModel) -> (), failure: @escaping (String) -> ()) {
        let query = FormDetailQuery(_id: id)

        ErxesClient.shared.client.fetch(query: query, cachePolicy: .fetchIgnoringCacheData) { result in

            switch result {

            case .success(let graphQLResult):

                if let response = graphQLResult.data?.formDetail?.fragments.formModel {

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


    func sendForm(formId: String, submissions: [FieldValueInput?]?, success: @escaping (FormResponseModel) -> (), failure: @escaping (String) -> ()) {

        let mutation = WidgetsSaveLeadMutation(integrationId: integrationId, formId: formId, submissions: submissions, browserInfo: ["userAgent": "iOS"], cachedCustomerId: customerId)

        ErxesClient.shared.client.perform(mutation: mutation) { result in

            switch result {

            case .success(let graphQLResult):

                if let response = graphQLResult.data?.widgetsSaveLead?.fragments.formResponseModel {

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

    func unreadCount(conversationId: String, success: @escaping (Int) -> (), failure: @escaping (String) -> ()) {
        let query = WidgetsUnreadCountQuery(conversationId: conversationId)
        ErxesClient.shared.client.fetch(query: query, cachePolicy: .fetchIgnoringCacheData) { result in
            switch result {

            case .success(let graphQLResult):

                if let response = graphQLResult.data?.widgetsUnreadCount {

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

    func knowledgeBaseTopic(topicId: String, success: @escaping (KnowledgeBaseTopicModel) -> (), failure: @escaping (String) -> ()) {
        let query = KnowledgeBaseTopicDetailQuery(id: topicId)

        ErxesClient.shared.client.fetch(query: query, cachePolicy: .fetchIgnoringCacheData) { result in

            switch result {

            case .success(let graphQLResult):

                if let response = graphQLResult.data?.knowledgeBaseTopicDetail?.fragments.knowledgeBaseTopicModel {

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
