//  
//  RegisterViewModel.swift
//  erxesiosdk
//
//  Created by Soyombo bat-erdene on 7/17/19.
//  Copyright © 2019 Soyombo bat-erdene. All rights reserved.
//

import Foundation
import UIKit

class HomeViewModel {

    private let service: HomeServiceProtocol
    var unreadIds = [String](){
        didSet{
            didSetUnreadCount!()
        }
    }
    private var model: ConnectResponseModel = ConnectResponseModel() {
        didSet {
         
            didGetData!(model)
        }
    }
    
    private var knowledgeBase: KnowledgeBaseTopicModel = KnowledgeBaseTopicModel() {
        didSet {
           
            didGetKnowledgeBase!(knowledgeBase)
        }
    }
    
 
    
    private var conversations: [ConversationModel] = [ConversationModel]() {
        didSet {
           
            didGetConversations!(conversations)
        }
    }

    /// Count your data in model
    var count: Int = 0
    var allKBArticles = [KbArticleModel]()
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
    var selectedObject: ConnectResponseModel?

    //MARK: -- Closure Collection
    var showAlertClosure: (() -> ())?
    var updateLoadingStatus: (() -> ())?
    var internetConnectionStatus: (() -> ())?
    var serverErrorStatus: (() -> ())?
    var didGetData: ((_ model:ConnectResponseModel) -> ())?
    
    var didGetConversations: ((_ model:[ConversationModel]) -> ())?
    var didReceiveAdminMessage: ((_ model:MessageModel) -> ())?
    var didGetKnowledgeBaseTopicId: ((_ model:String) -> ())?
    var didSetUnreadCount: (() -> ())?
    var didGetKnowledgeBase:((_ model:KnowledgeBaseTopicModel) -> ())?
    init(withRegister serviceProtocol: HomeServiceProtocol = HomeService() ) {
        self.service = serviceProtocol

        NotificationCenter.default.addObserver(self, selector: #selector(self.networkStatusChanged(_:)), name: NSNotification.Name(rawValue: ReachabilityStatusChangedNotification), object: nil)
        Reach().monitorReachabilityChanges()

    }

    //MARK: Internet monitor status
    @objc func networkStatusChanged(_ notification: Notification) {
        self.networkStatus = Reach().connectionStatus()
    }

    //MARK: -- Example Func
    func messengerConnect(Email email:String? = "", Phone phone:String? = "",CachedCustomerId customerId:String? = "",data:Scalar_JSON! = nil) {
        self.isLoading = true
        self.service.messengerConnect(brandCode:erxesBrandCode , email:email , phone:phone, customerId: customerId, data: data ,success: { (data) in
            if let messengerData = data.messengerData {
         
                if let messages: Scalar_JSON = (messengerData["messages"] as! Scalar_JSON) {
                    if let greetings: Scalar_JSON = (messages["greetings"] as! Scalar_JSON) {
                        welcomeTitle = greetings["title"] as! String
                        welcomeDescription = greetings["message"] as! String
                    } else {
                        welcomeTitle = "Welcome!".localized(lang)
                        welcomeDescription = "Welcome description".localized(lang)
                    }
                    if let awayMessage = messages["away"] {
                        away = awayMessage as? String
                    }
                    
                    if let welcomeMessage = messages["welcome"] {
                        welcome = welcomeMessage as? String
                    }
                    
                    if let thankMessage = messages["thank"] {
                        thank = thankMessage as? String
                    }
                }
                
                if let links: Scalar_JSON = (messengerData["links"] as! Scalar_JSON) {
                    socialLinks = links
                }
                
                if let _integrationId = data.integrationId {
                    Erxes.storeIntegrationId(value: _integrationId)
                    erxesIntegrationId = _integrationId
                }
                
                if let _customerId = data.customerId {
                    erxesCustomerId = _customerId
                    Erxes.storeCustomerId(value: _customerId)
                }
                if let uiOptions = data.uiOptions {
                    themeColor = UIColor.init(hexString: uiOptions["color"] as! String)
                    if let _wallpaper:String = uiOptions["wallpaper"] as! String , _wallpaper != "5"{
                        wallPaper = _wallpaper
                    }
                }
                
                
                
                if let brandData = data.brand?.fragments.brandModel {
                    titleText = brandData.name
                    descriptionText = brandData.description!
                    
                }
                if let KBTopicID = messengerData["knowledgeBaseTopicId"] as? String{
                    hasKnowledgeBase = true
                    knowledgeBaseTopicId = KBTopicID
                    self.didGetKnowledgeBaseTopicId!(KBTopicID)
                }
            }
            self.isLoading = false
            self.model = data
        }) { (error) in
            print(error)
        }
    }
    
   
    
    func getConversations(integrationId:String,customerId:String) {
        self.service.allConversations(integrationId: integrationId, customerId: customerId, success: { (data) in
            
            self.conversations = data
            self.getKnowledgeBaseTopic(topicId: knowledgeBaseTopicId)
            self.unreadIds.removeAll()
            for conversation in self.conversations {
                self.unreadCount(conversationId: conversation._id)
            }
        }) { (error) in
            print(error)
        }
    }
    
    func formConnect(brandCode:String,formCode:String) {
        self.service.formConnect(brandCode: brandCode, formCode: formCode, success: { (data) in
            print(data)
        }) { (error) in
            print(error)
        }
    }
    
    func getKnowledgeBaseTopic(topicId:String) {
        self.service.knowledgeBaseTopic(topicId: topicId, success: { (data) in
           self.knowledgeBase = data
            for category in data.categories! {
                for article in (category?.fragments.knowledgeBaseCategoryModel.articles)! {
                    if let model = article?.fragments.kbArticleModel {
                        self.allKBArticles.append(model)
                    }
                    
                }
            }
//            self.allKBArticles = data.
        }) { (error) in
            print(error)
        }
    }
    
    func subscribe(customerId:String){
        let subscription = ConversationAdminMessageInsertedSubscription(customerId: customerId)
        ErxesClient.shared.client.subscribe(subscription: subscription) { (result) in
            guard let data = try? result.get().data else { return }
            if let dataModel = data.conversationAdminMessageInserted?.fragments.messageModel {
                self.didReceiveAdminMessage!(dataModel)

            }
            if let errors = try? result.get().errors {
                print("errors = ",errors)
                print(errors[0])
            }
        }
    }
    
    func unreadCount(conversationId:String){
        self.service.unreadCount(conversationId: conversationId, success: { (count) in
            if count > 0 {
                
                self.unreadIds.append(conversationId)
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }

}

