import UIKit

public class Router: NSObject {

    public static func erxesBundle() -> Bundle{
        let bundle = Bundle(for:RegisterVC.self)
        let url = bundle.url(forResource: "ErxesSDK", withExtension: "bundle")
        return Bundle(url: url!)
    }

    public static func toRegister(target:UIViewController){
        let storyboard = UIStoryboard(name: "Erxes", bundle: Router.erxesBundle())
        let vc = storyboard.instantiateViewController(withIdentifier: "start")
        vc.modalPresentationStyle = .overCurrentContext
        target.present(vc, animated: true, completion: nil)
    }
}
