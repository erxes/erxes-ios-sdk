//
//  MessengerViewModel.swift
//  Erxes iOS SDK
//
//  Created by soyombo bat-erdene on 5/1/20.
//  Copyright © 2020 Soyombo bat-erdene. All rights reserved.
//

import Foundation
import Apollo

class MessengerViewModel {

    private let service: MessengerServiceProtocol
    private var subscription: Cancellable?
    private var model: [MessengerModel] = [MessengerModel]() {
        didSet {
            self.count = self.model.count
        }
    }

    /// Count your data in model
    var count: Int = 0
    var isOnline = Bool()
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
    var selectedObject: MessengerModel?

    //MARK: -- Closure Collection
    var showAlertClosure: (() -> ())?
    var updateLoadingStatus: (() -> ())?
    var internetConnectionStatus: (() -> ())?
    var serverErrorStatus: ((_ error: String) -> ())?
    var didGetConversationDetail: ((_ model: ConversationDetailModel) -> ())?
    var didGetSupporters: ((_ model: [UserModel]) -> ())?
    var didReceiveMessage: ((_ model: MessageModel) -> ())?
    var didSetIsOnline: ((_ isOnline: Bool) -> ())?

    init(withMessenger serviceProtocol: MessengerServiceProtocol = MessengerService()) {
        self.service = serviceProtocol

        NotificationCenter.default.addObserver(self, selector: #selector(self.networkStatusChanged(_:)), name: NSNotification.Name(rawValue: ReachabilityStatusChangedNotification), object: nil)
        Reach().monitorReachabilityChanges()

    }

    //MARK: Internet monitor status
    @objc func networkStatusChanged(_ notification: Notification) {
        self.networkStatus = Reach().connectionStatus()
    }

    func conversationDetail(conversationId: String?) {
        self.service.conversationDetail(conversationId: conversationId, success: { (data) in
            self.didGetConversationDetail!(data)
          
            self.didSetIsOnline!(data.isOnline ?? false)
        }) { (error) in
            self.serverErrorStatus!(error)
        }
    }

    func getSupporters() {

        self.service.widgetsMessengerSupporters(success: { (data) in
            self.didGetSupporters!(data)
        }) { (error) in
            self.serverErrorStatus!(error)
        }
    }

    func insertMessage(customerId: String?, visitorId: String?, message: String?, attachments: [AttachmentInput]?, conversationId: String?, contentType: String? = "text") {
        self.service.insertMessage(customerId: customerId,visitorId: visitorId, message: message, attachments: attachments, conversationId: conversationId, contentType: contentType!, success: { (data) in
            self.didReceiveMessage!(data)
        }) { (error) in
            self.serverErrorStatus!(error)
        }
    }



    func subscribe(conversationId: String) {
       
        if isSaas {
            let subscriptionQuery = ConversationMessageInsertedSaasSubscription(id: conversationId)
            self.subscription = ErxesClient.shared.client.subscribe(subscription: subscriptionQuery) { (result) in
                guard let data = try? result.get().data else { return }

                if let dataModel = data.conversationMessageInserted?.fragments.messageSubscriptionModel {
                    var user:UserModel?
                    if let userJson = dataModel.user {
                        let userId = userJson["_id"] as! String
                        let details = userJson["details"] as! [String: Any]
                        user = UserModel.init(_id: userId, details: UserModel.Detail.init(avatar: details["avatar"] as? String, fullName: details["fullName"] as? String))
                    }
                    var message = MessageModel(_id: dataModel.id, conversationId: conversationId)
                    message.customerId = dataModel.customerId
                    message.content = dataModel.content
                    message.createdAt = dataModel.createdAt
                    if user != nil {
                        message.user = try! MessageModel.User.init(jsonObject: user!.jsonObject)
                    }
                    
                    if let file = dataModel.attachments?.first {
                        let attachment = MessageModel.Attachment(url: file!.url, name: (file?.name)!, size: file?.size, type: file!.type)
                        message.attachments = [attachment]
                    }
                  
                   
                    self.didReceiveMessage!(message)
                }
                if let errors = try? result.get().errors {
                    print(errors[0])
                }
            }
        } else {
            let subscriptionQuery = ConversationMessageInsertedSubscription(id: conversationId)
            self.subscription = ErxesClient.shared.client.subscribe(subscription: subscriptionQuery) { (result) in
                guard let data = try? result.get().data else { return }
                if let dataModel = data.conversationMessageInserted?.fragments.messageModel {
                    self.didReceiveMessage!(dataModel)
                }
                if let errors = try? result.get().errors {
                    print(errors[0])
                }
            }
        }
    }

    func cancelSubscription() {
        self.subscription?.cancel()
    }
    
    func readConversation(id:String){
        self.service.readConversation(conversationId: id, success: { (data) in
            
        }) { (error) in
            self.serverErrorStatus!(error)
        }
    }

}

extension MessengerViewModel {


}
