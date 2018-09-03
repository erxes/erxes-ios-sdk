import UIKit

var erxesUserId:String!
var erxesCustomerId:String!
var brandCode:String!
var integrationId:String!
var erxesEmail:String!
var conversationId:String!
var erxesColor = UIColor(hexString: "#5629B6")
var erxesColorHex = "#5629B6" as String!
var msgThankyou:String!
var msgWelcome:String!
var supporterName:String!
var supporterAvatar:String!
var supporters:[ConversationDetailQuery.Data.ConversationDetail.Supporter] = []
var isOnline = false

@objc public class Erxes: NSObject {

    static func firstRun() -> Bool {
        let defaults = UserDefaults()
        return defaults.value(forKey: "email") == nil
    }
    
    static func saveEmail( item:String) {
        erxesEmail = item
        let defaults = UserDefaults()
        defaults.set(erxesEmail, forKey: "email")
        defaults.synchronize()
    }
    
    static func saveCustomerId( item:String) {
        erxesCustomerId = item
        let defaults = UserDefaults()
        defaults.set(erxesCustomerId, forKey: "customerId")
        defaults.synchronize()
    }
    
    static func saveIntegrationId( item:String) {
        integrationId = item
        let defaults = UserDefaults()
        defaults.set(integrationId, forKey: "integrationId")
        defaults.synchronize()
    }
    
    static func restore() {
        let defaults = UserDefaults()
        erxesEmail = defaults.string(forKey: "email")
        integrationId = defaults.string(forKey: "integrationId")
        erxesCustomerId = defaults.string(forKey: "customerId")
    }
    
    @objc public static func setBrandCode(code:String) {
        brandCode = code
    }
    
    @objc public static func startWithUserEmail(email:String) {
        erxesEmail = email
        start()
    }
    
    @objc public static func start() {
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            Router.toRegister(target: topController)
        }
    }
    
    @objc public static func setDeviceToken(token:String){
    }
    
    @objc public static func notificationReceived(userInfo: [AnyHashable : Any]) {
        if let id = userInfo["conversationId"] as? String{
            conversationId = id
            Erxes.start()
        }
    }
    
    @objc public static func setHosts(apiHost:String, subsHost:String, uploadUrl url: String) {
        apiUrl = apiHost
        subsUrl = subsHost
        uploadUrl = url
        getConfig()
    }

    static func registerFonts() {
        let b = Router.erxesBundle()
        UIFont.registerFontWithFilenameString(filenameString: "icomoon.ttf", bundle: b)
        UIFont.registerFontWithFilenameString(filenameString: "erxes.ttf", bundle: b)
        UIFont.registerFontWithFilenameString(filenameString: "Roboto-Regular.ttf", bundle: b)
        UIFont.registerFontWithFilenameString(filenameString: "Roboto-Medium.ttf", bundle: b)
    }

    static func getConfig() {

        registerFonts()
        let query = GetConfigQuery(brandCode: brandCode!)
        apollo.fetch(query: query) { result, error in
            
            if let error = error {
                print(error.localizedDescription)
                return
            }
            let data = result?.data?.getMessengerIntegration
            let defaults = UserDefaults()
            
            
            if let uiOptions = data?.uiOptions {
                defaults.setValue(uiOptions, forKey: "uiOptions")
            }
            if let messengerData = data?.messengerData {
                defaults.setValue(messengerData, forKey: "messengerData")
            }
            if let language = data?.languageCode {
                defaults.setValue(language, forKey: "languageCode")
            }
            defaults.synchronize()
        }
    }
    
    @objc public static func changeLanguage() {
        var selected = "en"
        if let lang = UserDefaults.standard.string(forKey:"languageCode") {
            if lang == "en" {
                selected = "mn"
        }
            else {
                selected = "en"
            }
        }
        UserDefaults.standard.set(selected, forKey: "languageCode")
        UserDefaults.standard.synchronize()
    }
    
}
