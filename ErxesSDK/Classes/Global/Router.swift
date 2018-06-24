import UIKit

public class Router: NSObject {
    public static func toRegister(target:UIViewController){
        let bundle = Bundle(for:RegisterVC.self)
        let url = bundle.url(forResource: "ErxesSDK", withExtension: "bundle")
        let b = Bundle(url: url!)
        let storyboard = UIStoryboard(name: "Erxes", bundle: b)
        let vc = storyboard.instantiateViewController(withIdentifier: "start")
        vc.modalPresentationStyle = .overCurrentContext
        target.present(vc, animated: true, completion: nil)
    }
}
