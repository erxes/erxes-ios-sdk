import UIKit

@objc public class Erxes: NSObject {
    static var userId:String!
    static var customerId:String!
    static var brandCode:String!
    static var integrationId:String!
    static var email:String!
    static var conversationId:String!
    
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
    }
    
}
