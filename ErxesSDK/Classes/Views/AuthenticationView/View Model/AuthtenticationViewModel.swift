//  
//  AuthtenticationViewModel.swift
//  erxesiosdk
//
//  Created by Soyombo bat-erdene on 8/31/19.
//  Copyright © 2019 Soyombo bat-erdene. All rights reserved.
//

import Foundation
import UIKit

class AuthtenticationViewModel {

    private let service: AuthtenticationServiceProtocol

  
    /// Count your data in model
    var count: Int = 0

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

  
    //MARK: -- Closure Collection
    var showAlertClosure: (() -> ())?
    var updateLoadingStatus: (() -> ())?
    var internetConnectionStatus: (() -> ())?
    var serverErrorStatus: (() -> ())?
   
    var didAthenticate: ((_ data :ConnectResponseModel) -> ())?
    init(withAuthtentication serviceProtocol: AuthtenticationServiceProtocol = AuthtenticationService() ) {
        self.service = serviceProtocol

        NotificationCenter.default.addObserver(self, selector: #selector(self.networkStatusChanged(_:)), name: NSNotification.Name(rawValue: ReachabilityStatusChangedNotification), object: nil)
        Reach().monitorReachabilityChanges()

    }

    //MARK: Internet monitor status
    @objc func networkStatusChanged(_ notification: Notification) {
        self.networkStatus = Reach().connectionStatus()
    }

    //MARK: -- Example Func
    func connect(brandCode:String,Email email:String? = "" ,Phone phone:String? = "", data:Scalar_JSON!) {
        self.service.messengerConnect(brandCode: brandCode, email: email, phone: phone,data:data, success: { (data) in
            let messengerData = data.messengerData
            
            if let messages: Scalar_JSON = (messengerData?["messages"] as! Scalar_JSON) {
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
            
            if let links: Scalar_JSON = (messengerData?["links"] as! Scalar_JSON) {
                socialLinks = links
            }
            
            if let _integrationId = data.integrationId {
                Erxes.storeIntegrationId(value: data.integrationId!)
                erxesIntegrationId = _integrationId
            }
            
            if let _customerId = data.customerId {
                Erxes.storeCustomerId(value: data.customerId!)
                erxesCustomerId = _customerId
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
            
            if let KBTopicID = messengerData!["knowledgeBaseTopicId"] as? String{
                hasKnowledgeBase = true
                knowledgeBaseTopicId = KBTopicID
                
            }
            
            self.didAthenticate!(data)
        }) { (error) in
           
            print(error)
        }
    }

}

extension AuthtenticationViewModel {

}
