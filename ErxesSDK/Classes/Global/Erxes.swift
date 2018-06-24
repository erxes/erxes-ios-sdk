import UIKit

@objc public class Erxes: NSObject {
    static var userId:String!
    static var customerId:String!
    static var brandCode:String!
    static var integrationId:String!
    static var email:String!
    static var conversationId:String!
    static var color:UIColor!
    static var colorHex:String!
    static var msgThankyou:String!
    static var msgWelcome:String!
    static var supporterName:String!
    static var supporterAvatar:String!
    static var supporters:[GetSupporterQuery.Data.MessengerSupporter] = []
    
    static func firstRun() -> Bool{
        let defaults = UserDefaults()
        return defaults.value(forKey: "email") == nil
    }
    
    static func saveEmail( item:String){
        email = item
        let defaults = UserDefaults()
        defaults.set(email, forKey: "email")
        defaults.synchronize()
    }
    
    static func saveCustomerId( item:String){
        customerId = item
        let defaults = UserDefaults()
        defaults.set(customerId, forKey: "customerId")
        defaults.synchronize()
    }
    
    static func saveIntegrationId( item:String){
        integrationId = item
        let defaults = UserDefaults()
        defaults.set(integrationId, forKey: "integrationId")
        defaults.synchronize()
    }
    
    static func restore(){
        let defaults = UserDefaults()
        email = defaults.string(forKey: "email")
        integrationId = defaults.string(forKey: "integrationId")
        customerId = defaults.string(forKey: "customerId")
    }
    
    @objc public static func setBrandCode(brandCode:String){
        self.brandCode = brandCode
    }
    
    @objc public static func startWithUserEmail(email:String){
        Erxes.email = email
        start()
    }
    
    @objc public static func start(){
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            Router.toRegister(target: topController)
        }
    }
    
    @objc public static func setDeviceToken(token:String){
    }
    
    @objc public static func notificationReceived(userInfo: [AnyHashable : Any]){
        if let conversationId = userInfo["conversationId"] as? String{
            Erxes.conversationId = conversationId
            Erxes.start()
        }
    }
    
    @objc public static func setHosts(apiHost:String, subsHost:String){
        apiUrl = apiHost
        subsUrl = subsHost
        getConfig()
    }
    
    static func getConfig(){
        
        let bundle = Bundle(for:RegisterVC.self)
        let url = bundle.url(forResource: "ErxesSDK", withExtension: "bundle")
        let b = Bundle(url: url!)
        UIFont.registerFontWithFilenameString(filenameString: "icomoon.ttf", bundle: b!)
        UIFont.registerFontWithFilenameString(filenameString: "erxes.ttf", bundle: b!)
        UIFont.registerFontWithFilenameString(filenameString: "Roboto-Regular.ttf", bundle: b!)
        UIFont.registerFontWithFilenameString(filenameString: "Roboto-Medium.ttf", bundle: b!)
        
        let query = GetConfigQuery(brandCode: Erxes.brandCode!)
        apollo.fetch(query: query){result, error in
            
            if let error = error {
                print(error.localizedDescription)
                return
            }
            let data = result?.data?.getMessengerIntegration
            let defaults = UserDefaults()
            
            
            if let uiOptions = data?.uiOptions{
                defaults.setValue(uiOptions, forKey: "uiOptions")
            }
            if let messengerData = data?.messengerData{
                defaults.setValue(messengerData, forKey: "messengerData")
            }
            if let language = data?.languageCode{
                defaults.setValue(language, forKey: "languageCode")
            }
            defaults.synchronize()
        }
    }
    
    @objc public static func changeLanguage(){
        var selected = "en"
        if let lang = UserDefaults.standard.string(forKey:"languageCode") {
            if lang == "en"{
                selected = "mn"
            }
            else{
                selected = "en"
            }
        }
        UserDefaults.standard.set(selected, forKey: "languageCode")
        UserDefaults.standard.synchronize()
    }
    
}
