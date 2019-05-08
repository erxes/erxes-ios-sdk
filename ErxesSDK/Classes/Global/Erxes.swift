import UIKit

var erxesUserId:String!
var erxesCustomerId:String!
var brandCode:String!
var integrationId:String!
var erxesEmail = ""
var erxesPhone = ""
var erxesUserData = Scalar_JSON()
var isUser = false
var emailFirst = true
var conversationId:String!
var erxesColor = UIColor(hexString: "#5629B6")
var erxesColorHex = "#5629B6"
var msgThankyou = ""
var msgWelcome = ""
var msgGreetings = ""
var supporterName:String!
var supporterAvatar:String!
var supporters:[GetSupportersQuery.Data.MessengerSupporter] = []
var isOnline = true
var isSaas = false

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
    
    static func savePhone( item:String) {
        erxesEmail = item
        let defaults = UserDefaults()
        defaults.set(erxesEmail, forKey: "phone")
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
        
        if let email = defaults.string(forKey: "email") {
            erxesEmail = email
        }
        
        if let phone = defaults.string(forKey: "phone") {
            erxesPhone = phone
        }
        
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
    
    @objc public static func startWithUserPhone(phone:String) {
        erxesPhone = phone
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
    
    
    @objc public static func endSession(completionHandler:() -> Void = { }){
        let defaults = UserDefaults()
        defaults.removeObject(forKey: "email")
        defaults.removeObject(forKey: "phone")
        defaults.synchronize()
        erxesEmail = ""
        erxesPhone = ""
        conversationId = nil
        completionHandler()
    }
    
    @objc public static func start(email:String = "", phone:String = "", data:[String:Any] = [:]) {
        
        if email.count > 0 {
            erxesEmail = email
            isUser = true
        }
        
        if phone.count > 0 {
            erxesPhone = phone
            isUser = true
        }
        
        if data.keys.count > 0 {
            var processed = [String:Any]()
            for (key, value) in data {
                processed[key] = forceBridgeFromObjectiveC(value)
            }
            erxesUserData = processed
        }
        
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            Router.toRegister(target: topController)
        }
    }
    
    static func forceBridgeFromObjectiveC(_ value: Any) -> Any {
        
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
            return Dictionary(uniqueKeysWithValues: (value as! NSDictionary).map { ($0.key as! AnyHashable, forceBridgeFromObjectiveC($0.value)) })
        case is NSArray:
            return (value as? NSArray).map { forceBridgeFromObjectiveC($0) }
        default:
            return value
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
        
        let hostString = URL(string: apiHost)?.host
        let hostSeperated = hostString?.components(separatedBy: ".")
        if hostSeperated![1] == "app" && hostSeperated![2] == "erxes" && hostSeperated![3] == "io" {
            isSaas = true
        }else {
            isSaas = false
        }
        
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
