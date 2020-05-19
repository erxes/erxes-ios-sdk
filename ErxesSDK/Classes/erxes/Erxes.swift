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
import IQKeyboardManagerSwift

var lang = "en"

let screenSize = UIScreen.main.bounds
let SCREEN_WIDTH = screenSize.width
let SCREEN_HEIGHT = screenSize.height


var customerId: String!
var brandCode: String!
var integrationId: String!
var formCode: String!

var customerEmail = ""
var customerPhoneNumber = ""
let defaultColorCode = "#5629B6"

var uploadUrl = ""
var isSaas = false
var sender = UIView()

var messengerData: MessengerData?
var leadData: LeadData?
var uiOptions: UIOptions?
var brand: BrandModel?

@objc public class Erxes: NSObject {
    
 
    
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
        
        customerId = value
        UserDefaults().set(value, forKey: "customerId")
        UserDefaults().synchronize()
    }
    
    static func storeIntegrationId(value: String) {
        integrationId = value
        UserDefaults().set(value, forKey: "integrationId")
        UserDefaults().synchronize()
    }
    
    static func storeThemeColor(hex: String) {
        //        themeColor = UIColor.init(hexString: hex)
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
            integrationId = integrationid
        }
        
        if let customerid = defaults.string(forKey: "customerId") {
            customerId = customerid
        }
        
        
        
    }
    
    @objc public static func setup(erxesApiUrl: String, brandId: String) {
        restore()
        brandCode = brandId
        uploadUrl = erxesApiUrl + "/upload-file"
        var subscriptionUrl = ""
        
        if erxesApiUrl.contains("http") {
            subscriptionUrl = erxesApiUrl.replacingOccurrences(of: "http", with: "ws")
        } else if erxesApiUrl.contains("https") {
            subscriptionUrl = erxesApiUrl.replacingOccurrences(of: "https", with: "wss")
        }
        ErxesClient.shared.setupClient(widgetsApiUrl: erxesApiUrl, apiUrlString: subscriptionUrl)
        self.connect(brandId: brandId)

        //        self.supporter()
        
    }
    
    @objc public static func setupSaas(companyName: String, brandId: String) {
        
        restore()
        isSaas = true
        let erxesWidgetsApiUrl = "https://\(companyName).app.erxes.io/api"
        let erxesApiUrl = "wss://\(companyName).app.erxes.io/api"
        uploadUrl = "https://\(companyName).app.erxes.io/api/upload-file"
        brandCode = brandId
        ErxesClient.shared.setupClient(widgetsApiUrl: erxesWidgetsApiUrl, apiUrlString: erxesApiUrl)
        
        //        self.getMessengerIntegration(brandCode: brandCode)
        self.connect(brandId: brandId)
        //        self.supporter()
    }
    
    @objc public static func setSender(view: UIView) {
        sender = view
    }
    
    
    @objc public static func prepare(parent: UIViewController, senderView: UIView) {
        sender = senderView
        if (integrationId != nil) || (customerId != nil) {
            self.connect(brandId: brandCode)
            
        }
    }
    
    
    private static func connect(brandId: String) {
       UserDefaults.standard.setValue(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
        let mutation = ConnectMutation(brandCode: brandId, cachedCustomerId: customerId)
        mutation.data = Scalar_JSON()
        ErxesClient.shared.client.perform(mutation: mutation) { result in
            switch result {
            case .success(let graphQLResult):
                if let responseModel = graphQLResult.data?.widgetsMessengerConnect?.fragments.connectResponseModel {
                    integrationId = responseModel.integrationId
                    customerId = responseModel.customerId
                    storeCustomerId(value: responseModel.customerId!)
                    if let messengerDataJson = responseModel.messengerData {
                        do {
                            messengerData = try MessengerData(from: messengerDataJson) { decoder in
                                decoder.keyDecodingStrategy = .convertFromSnakeCase
                            }
                            formCode = messengerData?.formCode
                        } catch {
                            print("Error: \(error)")
                        }
                    }
                    if let uiOptionsJson = responseModel.uiOptions {
                        do {
                            uiOptions = try UIOptions(from: uiOptionsJson) { decoder in
                                decoder.keyDecodingStrategy = .convertFromSnakeCase
                            }
                            
                        } catch {
                            print("Error: \(error)")
                        }
                    }
                    if let languageCode = responseModel.languageCode {
                        lang = languageCode
                    }
                    brand = responseModel.brand?.fragments.brandModel
                    saveBrowserInfo()
                }
                if let errors = graphQLResult.errors {
                    print("Errors from server: \(errors)")
                }
            case .failure(let error):
                print("Failure! Error: \(error)")
            }
        }
    }
    
    @objc private static func saveBrowserInfo() {
        let browserInfo = ["userAgent": UIDevice.modelName]
        let mutation = WidgetsSaveBrowserInfoMutation(customerId: customerId, browserInfo: browserInfo)
        
        ErxesClient.shared.client.perform(mutation: mutation) { result in
            
            switch result {
                
            case .success(let graphQLResult):
                
                if let response = graphQLResult.data?.widgetsSaveBrowserInfo?.fragments.messageModel {
                    
                    let avatarUrl = response.user?.fragments.userModel.details?.avatar ?? ""
                    let fullName = response.user?.fragments.userModel.details?.fullName ?? "Operator"
                    guard let content = response.engageData?.content, content.count != 0 else { return }
                    
                    let engageView = EngageView()
                    EngageView.show(avatarUrl, fullName: fullName, text: content)
                    
                }
                
                if let errors = graphQLResult.errors {
                    print("Errors from server: \(errors)")
                }
            case .failure(let error):
                print("Failure! Error: \(error)")
                
            }
        }
    }
    
    
    @objc public static func start() {
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.disabledToolbarClasses.append(MessengerView.self)
        
        if integrationId.count == 0 || integrationId == nil {
            let mutation = ConnectMutation(brandCode: brandCode, cachedCustomerId: customerId)
            mutation.data = Scalar_JSON()
            ErxesClient.shared.client.perform(mutation: mutation) { result in
                switch result {
                case .success(let graphQLResult):
                    if let responseModel = graphQLResult.data?.widgetsMessengerConnect?.fragments.connectResponseModel {
                        integrationId = responseModel.integrationId
                        customerId = responseModel.customerId
                        storeCustomerId(value: responseModel.customerId!)
                        if let messengerDataJson = responseModel.messengerData {
                            do {
                                messengerData = try MessengerData(from: messengerDataJson) { decoder in
                                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                                }
                                formCode = messengerData?.formCode
                            } catch {
                                print("Error: \(error)")
                            }
                        }
                        if let uiOptionsJson = responseModel.uiOptions {
                            do {
                                uiOptions = try UIOptions(from: uiOptionsJson) { decoder in
                                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                                }
                                
                            } catch {
                                print("Error: \(error)")
                            }
                        }
                        if let languageCode = responseModel.languageCode {
                            lang = languageCode
                        }
                        brand = responseModel.brand?.fragments.brandModel
                        saveBrowserInfo()
                        openErxes()
                    }
                    if let errors = graphQLResult.errors {
                        print("Errors from server: \(errors)")
                    }
                case .failure(let error):
                    print("Failure! Error: \(error)")
                }
            }
        } else {
            openErxes()
        }
        
    }
    
    @objc private static func openErxes() {
        
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            
            
            let navigationController = MainNavigationController()
            navigationController.modalPresentationStyle = .custom
            navigationController.isNavigationBarHidden = true
            
            if (messengerData?.requireAuth)! {
                if UserDefaults().bool(forKey: "authenticated") {
                    let controller = HomeView()
                    
                    navigationController.viewControllers.insert(controller, at: 0)
                } else {
                    let controller = AuthtenticationView()
                    
                    navigationController.viewControllers.insert(controller, at: 0)
                }
                
                
            } else {
                let controller = HomeView()
                
                navigationController.viewControllers.insert(controller, at: 0)
            }
            
            topController.present(navigationController, animated: true, completion: nil)
        }
    }
    
    
    
    @objc public static func endSession(completionHandler: () -> Void = { }) {
        let defaults = UserDefaults()
        defaults.removeObject(forKey: "email")
        defaults.removeObject(forKey: "phone")
        defaults.removeObject(forKey: "customerId")
        defaults.removeObject(forKey: "integrationId")
        defaults.removeObject(forKey: "authenticated")
        defaults.synchronize()
        customerEmail = ""
        customerPhoneNumber = ""
        customerId = ""
        integrationId = ""
        IQKeyboardManager.shared.enable = false
       
        completionHandler()
    }
    
 
    
    public static func erxesBundle() -> Bundle {
     
        let frameworkBundle = Bundle(for: AuthtenticationView.self)
        let bundleURL = frameworkBundle.resourceURL?.appendingPathComponent("ErxesSDK.bundle")
        let resourceBundle = Bundle(url: bundleURL!)!
        return resourceBundle
    }
}
