//
//  HomeViewModel.swift
//  Erxes iOS SDK
//
//  Created by soyombo bat-erdene on 4/30/20.
//  Copyright © 2020 Soyombo bat-erdene. All rights reserved.
//

import Foundation
import Apollo

class HomeViewModel {

    private let service: HomeServiceProtocol
    private var subscription: Cancellable?
    var allKBArticles = [KbArticleModel]()
    var unreadIds = [String]() {
        didSet {
            didSetUnreadCount!(unreadIds)
        }
    }
    private var supporters: [UserModel] = [UserModel]() {
        didSet {

        }
    }

    //MARK: -- Network checking

    /// Define networkStatus for check network connection
    var networkStatus = Reach().connectionStatus()

    /// Define boolean for internet status, call when network disconnected
    var isDisconnected: Bool = false {
        didSet {
            self.alertMessage = "No network connection. Please connect to the internet"
            self.internetConnectionStatus?()
        }
    }

    //MARK: -- UI Status

    /// Update the loading status, use HUD or Activity Indicator UI
    var isLoading: Bool = false {
        didSet {
            self.updateLoadingStatus?()
        }
    }

    /// Showing alert message, use UIAlertController or other Library
    var alertMessage: String? {
        didSet {
            self.showAlertClosure?()
        }
    }

    /// Define selected model


    //MARK: -- Closure Collection
    var showAlertClosure: (() -> ())?
    var updateLoadingStatus: (() -> ())?
    var internetConnectionStatus: (() -> ())?
    var serverErrorStatus: ((_ error: String) -> ())?
    var didGetSupporters: ((_ model: [UserModel]) -> ())?
    var didGetConversations: ((_ model: [ConversationModel]) -> ())?
    var didGetLead: ((_ model: LeadResponseModel) -> ())?
    var didGetFormDetail: ((_ model: FormModel) -> ())?
    var didGetFormResponse: ((_ model: FormResponseModel) -> ())?
    var didReceiveAdminMessage: ((_ model: ConversationAdminMessageInsertedModel) -> ())?
    var didReceiveMessage: ((_ model: MessageModel) -> ())?
    var didSetUnreadCount: ((_ model:[String]) -> ())?
    var didReceiveKnowledgeBase:((_ model:KnowledgeBaseTopicModel) -> ())?

    init(withHome serviceProtocol: HomeServiceProtocol = HomeService()) {
        self.service = serviceProtocol

        NotificationCenter.default.addObserver(self, selector: #selector(self.networkStatusChanged(_:)), name: NSNotification.Name(rawValue: ReachabilityStatusChangedNotification), object: nil)
        Reach().monitorReachabilityChanges()

    }

    //MARK: Internet monitor status
    @objc func networkStatusChanged(_ notification: Notification) {
        self.networkStatus = Reach().connectionStatus()
    }

    func getSupporters() {

        self.service.widgetsMessengerSupporters(success: { (users) in
            self.didGetSupporters!(users)
        }) { (error) in
            self.serverErrorStatus!(error)
        }
    }

    func getConversations() {

        self.service.widgetsConversations(success: { (conversations) in
            self.didGetConversations!(conversations)
            for conversation in conversations {
                
                self.unreadCount(conversationId: conversation._id)
            }
        }) { (error) in
            self.serverErrorStatus!(error)
        }
    }

    func connectLead() {
        self.service.widgetsLeadConnect(success: { (data) in
            self.didGetLead!(data)
        }) { (error) in
            self.serverErrorStatus!(error)
        }
    }

    func formDetail(id: String) {
        self.service.formDetail(id: id, success: { (data) in
            self.didGetFormDetail!(data)
        }) { (error) in
            self.serverErrorStatus!(error)
        }
    }

    func sendForm(formId: String, submissions: [FieldValueInput?]?) {
        self.service.sendForm(formId: formId, submissions: submissions, success: { (data) in
            self.didGetFormResponse!(data)
        }) { (error) in
            self.serverErrorStatus!(error)
        }
    }



    func subscribe(customerId: String) {
        let subscriptionQuery = ConversationAdminMessageInsertedSubscription(customerId: customerId)
        self.subscription = ErxesClient.shared.client.subscribe(subscription: subscriptionQuery) { (result) in
            switch result {

            case .success(let graphQLResult):

                if let response = graphQLResult.data?.conversationAdminMessageInserted?.fragments.conversationAdminMessageInsertedModel {
                    
                    self.didReceiveAdminMessage!(response)
                }

                if let errors = graphQLResult.errors {

                    let error = errors.compactMap({ $0.localizedDescription }).joined(separator: ", ")
                    self.serverErrorStatus!(error)

                }
            case .failure(let error):
                self.serverErrorStatus!(error.localizedDescription)
            }
        }
    }
    
    func getKnowLedgeBase(id:String){
        self.service.knowledgeBaseTopic(topicId: id, success: { (data) in
            self.allKBArticles.removeAll()
            for category in data.categories! {
                for article in (category?.fragments.knowledgeBaseCategoryModel.articles)! {
                    if let model = article?.fragments.kbArticleModel {
                        self.allKBArticles.append(model)
                    }
                    
                }
            }
            self.didReceiveKnowledgeBase!(data)
        }) { (error) in
            self.serverErrorStatus!(error)
        }
    }
    
    func cancelSubscription(){
        
        self.subscription?.cancel()
    }
    
    func subscribeConversationMessage(conversationId:String){
        let subscription = ConversationMessageInsertedSubscription(id: conversationId)
        ErxesClient.shared.client.subscribe(subscription: subscription) { (result) in
            switch result {
                
            case .success(let graphQLResult):
                
                if let response = graphQLResult.data?.conversationMessageInserted?.fragments.messageModel {
                    self.didReceiveMessage!(response)
                }
                
                if let errors = graphQLResult.errors {
                    
                    let error = errors.compactMap({ $0.localizedDescription }).joined(separator: ", ")
                    self.serverErrorStatus!(error)
                    
                }
            case .failure(let error):
                self.serverErrorStatus!(error.localizedDescription)
            }
        }
    }

    func unreadCount(conversationId: String) {
        unreadIds.removeAll()
        self.service.unreadCount(conversationId: conversationId, success: { (count) in
            if count > 0 {
                
                self.unreadIds.append(conversationId)
            }
        }) { (error) in
            self.serverErrorStatus!(error)
        }
    }
}

extension HomeViewModel {

}
