
import UIKit
import ErxesSDK

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
       
        //if you are Saas user you can setup as following
//        Erxes.setupSaas(companyName: "companyName", brandId: "brandCode")
       
        //if you are OpenSource user you can setup as following
//        Erxes.setup(erxesApiUrl: "http://c38134f7ae61.ngrok.io", brandId: "iGHfGX")
//        Erxes.setup(erxesApiUrl: "https://api.office.erxes.io", brandId: "5fkS4v")
        Erxes.setup(erxesApiUrl: "https://erxesappapi.golomtbank.com", brandId: "H7AQbY")
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        let settings = UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil)
        application.registerUserNotificationSettings(settings)
        application.registerForRemoteNotifications()
    }

    func applicationWillTerminate(_ application: UIApplication) {
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {

    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
      
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        
    }
}
