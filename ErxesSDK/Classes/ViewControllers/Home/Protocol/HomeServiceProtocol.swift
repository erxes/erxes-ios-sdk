//  
//  HomeServiceProtocol.swift
//  Erxes iOS SDK
//
//  Created by soyombo bat-erdene on 4/30/20.
//  Copyright © 2020 Soyombo bat-erdene. All rights reserved.
//

import Foundation

protocol HomeServiceProtocol {

    func widgetsMessengerSupporters(success: @escaping(_ data:[UserModel]) -> (), failure: @escaping(_ errorClosure: String) -> ())
    func widgetsConversations(success: @escaping(_ data:[ConversationModel]) -> (), failure: @escaping(_ errorClosure: String) -> ())
    func widgetsLeadConnect(success: @escaping(_ data:LeadResponseModel) -> (), failure: @escaping(_ errorClosure: String) -> ())
    func formDetail(id:String,success: @escaping(_ data:FormModel) -> (), failure: @escaping(_ errorClosure: String) -> ())
    func sendForm(formId: String,submissions: [FieldValueInput?]?,success: @escaping(_ data:FormResponseModel) -> (), failure: @escaping(_ errorClosure: String) -> ())
    func unreadCount(conversationId:String ,success: @escaping(_ data: Int) -> (), failure: @escaping(_ errorClosure: String) -> ())
     func knowledgeBaseTopic(topicId: String, success: @escaping(_ data: KnowledgeBaseTopicModel) -> (), failure: @escaping(_ errorClosure: String) -> ())
}
