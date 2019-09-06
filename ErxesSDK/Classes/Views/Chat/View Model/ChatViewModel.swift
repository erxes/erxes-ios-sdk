//
//  ChatViewModel.swift
//  erxesiosdk
//
//  Created by Soyombo bat-erdene on 8/19/19.
//  Copyright © 2019 Soyombo bat-erdene. All rights reserved.
//

import Foundation

class ChatViewModel {

    private let service: ChatServiceProtocol

    private var model: [MessageModel] = [MessageModel]() {
        didSet {
            self.count = self.model.count

            self.didGetData!(model)
        }
    }

    /// Count your data in model
    var count: Int = 0
    var isOnline: Bool = false
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
    var selectedObject: MessageModel?

    //MARK: -- Closure Collection
    var showAlertClosure: (() -> ())?
    var updateLoadingStatus: (() -> ())?
    var internetConnectionStatus: (() -> ())?
    var serverErrorStatus: (() -> ())?

    var didGetData: ((_ model: [MessageModel]) -> ())?
    var didReceiveMessage: ((_ model: MessageModel) -> ())?
    var didSetIsOnline: ((_ isOnline: Bool) -> ())?
    init(withChat serviceProtocol: ChatServiceProtocol = ChatService()) {
        self.service = serviceProtocol

        NotificationCenter.default.addObserver(self, selector: #selector(self.networkStatusChanged(_:)), name: NSNotification.Name(rawValue: ReachabilityStatusChangedNotification), object: nil)
        Reach().monitorReachabilityChanges()

    }

    //MARK: Internet monitor status
    @objc func networkStatusChanged(_ notification: Notification) {
        self.networkStatus = Reach().connectionStatus()
    }

    //MARK: -- Example Func
    func getMessages(conversationId: String) {
        
        switch networkStatus {
        case .offline:
            self.isDisconnected = true
            self.internetConnectionStatus?()
        case .online:
            self.isLoading = true
            self.service.getMessages(conversationId: conversationId, success: { (data) in
                self.model = data
                self.isLoading = false
            }) { (error) in
                print(error)
            }
        default:
            break
        }
    }


    func conversationDetail(id: String!, integrationId: String) {
        self.service.conversationDetail(conversationId: id, integrationId: integrationId, success: { (data) in
            if let flag = data.isOnline {
                self.isOnline = flag
                self.didSetIsOnline!(flag)
            }
        }) { (error) in
            print(error)
        }
    }

    func insertMessage(mutation: InsertMessageMutation) {
        self.service.insertMessage(mutation: mutation, success: { (data) in

            self.didReceiveMessage!(data)
        }) { (error) in
            print(error)
        }
    }

    func subscribe(conversationId: String) {
        if isSaas {
            let subscription = ConversationMessageInsertedSaasSubscription(id: conversationId)
            ErxesClient.shared.client.subscribe(subscription: subscription) { (result) in
                guard let data = try? result.get().data else { return }
                if let dataModel = data.conversationMessageInserted?.fragments.messageSubscriptionModel {
                    var message = MessageModel(id: dataModel.id, conversationId: conversationId)
                    message.customerId = dataModel.customerId
                    message.content = dataModel.content
                    message.createdAt = dataModel.createdAt
                    if let file = dataModel.attachments?.first {
                        let attachment = MessageModel.Attachment(url: file!.url, name: (file?.name)!, type: file!.type, size: file?.size)
                        message.attachments = [attachment]
                    }
                    if let user = dataModel.user {
                        let details:Scalar_JSON = user["details"] as! Scalar_JSON
                        let userModel = UserModel(details: UserModel.Detail.init(fullName: details["fullName"] as? String , avatar: details["avatar"] as? String))
                        message.user?.fragments.userModel = userModel
                    }
                    self.didReceiveMessage!(message)
                }
                if let errors = try? result.get().errors {
                    print(errors[0])
                }
            }
        } else {
            let subscription = ConversationMessageInsertedSubscription(id: conversationId)
            ErxesClient.shared.client.subscribe(subscription: subscription) { (result) in
                guard let data = try? result.get().data else { return }
                if let dataModel = data.conversationMessageInserted?.fragments.messageModel {

                    self.didReceiveMessage!(dataModel)
                }
                if let errors = try? result.get().errors {
                    print(errors[0])
                    print("errors = ", errors)
                }
            }
        }
    }

    func messageExists(id: String) {

    }

    func read(conversationId: String) {
        self.service.readConversation(conversationId: conversationId, success: { (data) in
            print(data)
        }) { (error) in
            print(error.localizedDescription)
        }
    }

}

extension ChatViewModel {

}
