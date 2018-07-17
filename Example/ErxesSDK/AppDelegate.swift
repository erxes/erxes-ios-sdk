
import UIKit
import Apollo
import ErxesSDK

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        Erxes.setBrandCode(code: "P6Cec9")
        Erxes.setHosts(apiHost: "https://api-mobile.crm.nmma.co/graphql", subsHost: "wss://app-api.crm.nmma.co/subscriptions")
        
//        Erxes.setBrandCode(brandCode: "YDEdKj")
//        let host = "192.168.86.29"
//        Erxes.setHosts(apiHost: "http://\(host):3100/graphql", subsHost: "ws://\(host):3300/subscriptions")
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
        let token = deviceToken.map { String(format: "%.2hhx", $0) }.joined()
        Erxes.setDeviceToken(token: token)
        print(token)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print(error)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        Erxes.notificationReceived(userInfo: userInfo)
    }
}
