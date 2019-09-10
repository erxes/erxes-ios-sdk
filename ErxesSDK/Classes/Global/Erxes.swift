//
//  Erxes.swift
//  erxesiosdk
//
//  Created by Soyombo bat-erdene on 8/31/19.
//  Copyright © 2019 Soyombo bat-erdene. All rights reserved.
//

import UIKit
import Foundation
import Apollo



var erxesColor = UIColor(hexString: "#5629B6")
var lang = "en"


let screenSize = UIScreen.main.bounds
let SCREEN_WIDTH = screenSize.width
let SCREEN_HEIGHT = screenSize.height

var themeColor = erxesColor
var titleText = ""
var descriptionText = ""
var loaded = false
var erxesCustomerId: String!
var erxesBrandCode: String!
var erxesIntegrationId: String!
var wallPaper: String!
var greetings: String!
var away: String!
var welcome: String!
var thank: String!
var customerEmail = ""
var customerPhoneNumber = ""
var supporters = [UserModel]()
var requireAuth = false
var knowledgeBaseTopicId = ""
var hasKnowledgeBase = false

var welcomeTitle: String!
var welcomeDescription: String!
var socialLinks = Scalar_JSON()
var uploadUrl = ""
var isSaas = false
@objc public class Erxes: NSObject {
    static func isInitialLoad() -> Bool {
        return UserDefaults().value(forKey: "email") == nil
    }
    static func storeEmail(value: String) {
        customerEmail = value
        UserDefaults().set(customerEmail, forKey: "email")
        UserDefaults().synchronize()
    }

    static func storePhoneNumber(value: String) {
        customerPhoneNumber = value
        UserDefaults().set(customerPhoneNumber, forKey: "phone")
        UserDefaults().synchronize()
    }

    static func storeCustomerId(value: String) {

        erxesCustomerId = value
        UserDefaults().set(value, forKey: "customerId")
        UserDefaults().synchronize()
    }

    static func storeIntegrationId(value: String) {
        erxesIntegrationId = value
        UserDefaults().set(value, forKey: "integrationId")
        UserDefaults().synchronize()
    }
    
    static func storeThemeColor(hex:String) {
        themeColor = UIColor.init(hexString: hex)
        UserDefaults().set(hex, forKey: "themeColor")
        UserDefaults().synchronize()
    }

    static func restore() {
        let defaults = UserDefaults()
        
        if let email = defaults.string(forKey: "email") {
            customerEmail = email
        }
        
        if let phone = defaults.string(forKey: "phone") {
            customerPhoneNumber = phone
        }
        if let integrationid = defaults.string(forKey: "integrationId") {
            erxesIntegrationId = integrationid
        }
        
        if let customerid = defaults.string(forKey: "customerId") {
            erxesCustomerId = customerid
        }
        
        if let color = defaults.string(forKey: "themeColor") {
            themeColor = UIColor.init(hexString: color)
        }

    }
    
    static func registerFonts() {
     
        UIFont.registerFontWithFilenameString(filenameString:"erxes.ttf",bundle:erxesBundle())
        
     
    }
    
 

     @objc public static func setup(erxesWidgetsApiUrl: String, erxesApiUrl: String, brandCode: String) {
        
        UserDefaults.standard.setValue(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
        erxesBrandCode = brandCode
        uploadUrl = erxesApiUrl
        var subscriptionUrl = ""
        
        if erxesApiUrl.contains("http"){
            subscriptionUrl = erxesApiUrl.replacingOccurrences(of: "http", with: "ws") + "/upload-file"
        }else if erxesApiUrl.contains("https") {
            subscriptionUrl = erxesApiUrl.replacingOccurrences(of: "https", with: "wss") + "/upload-file"
        }
        
        ErxesClient.shared.setupClient(widgetsApiUrl: erxesWidgetsApiUrl, apiUrlString: subscriptionUrl)
        self.getMessengerIntegration(brandCode: brandCode)
        restore()
    
    }
    
    @objc public static func setupSaas(companyName: String,brandCode: String) {
         UserDefaults.standard.setValue(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
        isSaas = true
        let erxesWidgetsApiUrl = "https://\(companyName).app.erxes.io/widgets-api"
        let erxesApiUrl = "wss://\(companyName).app.erxes.io/api"
        uploadUrl = "https://\(companyName).app.erxes.io/api/upload-file"
        erxesBrandCode = brandCode
        ErxesClient.shared.setupClient(widgetsApiUrl: erxesWidgetsApiUrl, apiUrlString: erxesApiUrl)
        
        self.getMessengerIntegration(brandCode: brandCode)
        restore()
    }


    private static func getMessengerIntegration(brandCode: String) {
        self.registerFonts()
        
        let query = GetMessengerIntegrationQuery(brandCode: brandCode)
        ErxesClient.shared.client.fetch(query: query) { result in
            guard let data = try? result.get().data else { return }
            if let integrationData = data.getMessengerIntegration {
                erxesIntegrationId = integrationData.id
                let defaults = UserDefaults()

                if let uiOptions = integrationData.uiOptions {
                    defaults.setValue(uiOptions, forKey: "uiOptions")
                    themeColor = UIColor.init(hexString: uiOptions["color"] as! String)
                    if let _wallpaper: String = uiOptions["wallpaper"] as! String, _wallpaper != "5" {
                        wallPaper = _wallpaper
                    }
                }
                if let messengerData = integrationData.messengerData {
                    if let requireAuthentication: Bool = messengerData["requireAuth"] as? Bool {
                        requireAuth = requireAuthentication
                    }
                    defaults.setValue(messengerData, forKey: "messengerData")
                }
                if let language = integrationData.languageCode {
                    lang = language
                    defaults.setValue(language, forKey: "languageCode")
                }
                if let formData = integrationData.formData {
                    defaults.setValue(formData, forKey: "formData")
                }
                defaults.synchronize()
                self.getSupporters(integrationId: integrationData.id)
            }
            if let errors = try? result.get().errors {
                print(errors)
            }
        }
    }

    private static func getSupporters(integrationId: String) {
        let query = MessengerSupportersQuery(integrationId: integrationId)
        ErxesClient.shared.client.fetch(query: query) { result in
            guard let data = try? result.get().data else { return }
            if let dataModel = data.messengerSupporters {
                supporters = (data.messengerSupporters?.compactMap({ $0?.fragments.userModel }))!
            }
            if let errors = try? result.get().errors {
                print(errors[0].localizedDescription)
            }

        }
    }

    @objc public static func start(data: [String: Any]! = nil) {

        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }


            let navigationController = UINavigationController()
            navigationController.modalPresentationStyle = .custom
            navigationController.isNavigationBarHidden = true

            if requireAuth {
                if erxesCustomerId != nil && erxesCustomerId.count != 0 {
                    let controller = HomeView()
                    controller.isResigningCustomer = true
                    controller.data = data
                    navigationController.viewControllers.insert(controller, at: 0)
                } else {
                    let controller = AuthtenticationView()
                    controller.data = data
                    navigationController.viewControllers.insert(controller, at: 0)
                }
            } else {
                let controller = HomeView()
                controller.isResigningCustomer = false
                controller.data = data
                navigationController.viewControllers.insert(controller, at: 0)
            }

            topController.present(navigationController, animated: true, completion: nil)
        }
    }

    @objc private static func sendData(data: [String: Any]) {

        if (erxesCustomerId != nil) {
            var userData = Scalar_JSON()
            if data.keys.count > 0 {
                var processed = [String: Any]()
                for (key, value) in data {
                    processed[key] = forceBridgeObjectiveC(value)
                }
                userData = processed
            }

            let mutation = MessengerConnectMutation(brandCode: erxesBrandCode)
            mutation.cachedCustomerId = erxesCustomerId
            mutation.data = userData
            ErxesClient.shared.client.perform(mutation: mutation) { result in
                guard let data = try? result.get().data else { return }
                if (data.messengerConnect != nil) {
                    Log.d("Send data result: Data has been sent")
                }
                if let errors = try? result.get().errors {
                    Log.e("Error: \(errors[0].localizedDescription)")
                }
            }
        } else {
            Log.e("Error: Customer is not set !!!")
        }

    }

    @objc public static func endSession(completionHandler: () -> Void = { }) {
        let defaults = UserDefaults()
        defaults.removeObject(forKey: "email")
        defaults.removeObject(forKey: "phone")
        defaults.removeObject(forKey: "customerId")
        defaults.removeObject(forKey: "integrationId")
        defaults.synchronize()
        customerEmail = ""
        customerPhoneNumber = ""
        erxesCustomerId = ""
        erxesIntegrationId = ""
        completionHandler()
    }

    static func forceBridgeObjectiveC(_ value: Any) -> Any {

        if value == nil {
            return value
        }

        switch value {

        case is NSString:
            return value as! String

        case is Bool:
            return value as! Bool
        case is Int:
            return value as! Int
        case is Int64:
            return value as! Int64
        case is Double:
            return value as! Double
        case is NSDictionary:
            return Dictionary(uniqueKeysWithValues: (value as! NSDictionary).map { ($0.key as! AnyHashable, forceBridgeObjectiveC($0.value)) })
        case is NSArray:
            return (value as? NSArray).map { forceBridgeObjectiveC($0) }
        default:
            return value
        }
    }
    
    public static func erxesBundle() -> Bundle {
     
        let frameworkBundle = Bundle(for: AuthtenticationView.self)
        let bundleURL = frameworkBundle.resourceURL?.appendingPathComponent("ErxesSDK.bundle")
        let resourceBundle = Bundle(url: bundleURL!)!
        return resourceBundle
    }
}


