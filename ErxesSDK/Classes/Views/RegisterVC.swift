
import UIKit
import SwiftyJSON

public class RegisterVC: UIViewController {

    @IBOutlet var tfEmail:UITextField!
    
    override public func viewDidLoad() {
        super.viewDidLoad()
//        getConfig()
        
        let defaults = UserDefaults()
        
        if let uiOptions = defaults.string(forKey: "uiOptions") {
            if let dataFromString = uiOptions.data(using: .utf8, allowLossyConversion: false) {
                do{
                    let item = try JSON(data: dataFromString)
                    if let color = item["color"].string{
                        Erxes.color = UIColor(hexString: color)
                        Erxes.colorHex = color
                    }
                }
                catch{
                    print("Error info: \(error)")
                }
            }
        }
        
        if let messengerData = defaults.string(forKey: "messengerData"){
            if let dataFromString = messengerData.data(using: .utf8, allowLossyConversion: false) {
                do{
                    let item = try JSON(data: dataFromString)
                    if let msg = item["welcomeMessage"].string{
                        Erxes.msgWelcome = msg
                    }
                }
                catch{
                    print("Error info: \(error)")
                }
            }
        }
        
        if !Erxes.firstRun() {
            Erxes.restore()
            getSupporter()
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "conversations")
            self.navigationController?.pushViewController(vc!, animated: false)
        }
        else{
            if Erxes.email != nil{
                self.tfEmail.text = Erxes.email
                connectMessenger()
            }
        }
    }
    
    @IBAction public func register(){
        guard tfEmail.text != "" else {
            return
        }
        connectMessenger()
    }
    
    func getSupporter(){
        let query = GetSupporterQuery(integrationId: Erxes.integrationId)
        apollo.fetch(query: query){[weak self] result, error in
            
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            if let supporters = result?.data?.messengerSupporters{
                if supporters.count > 0{
                    let supporter = supporters[0]
                    Erxes.supporterName = supporter?.details?.fullName
                    Erxes.supporterAvatar = supporter?.details?.avatar
                }
            }
        }
    }
    
    public func connectMessenger() {
        let connectMutation = ConnectMutation(brandCode: Erxes.brandCode, email: self.tfEmail.text!, isUser: true)
        apollo.perform(mutation: connectMutation) { [weak self] result, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            Erxes.saveIntegrationId(item: (result?.data?.messengerConnect?.integrationId)!)
            Erxes.saveCustomerId(item: (result?.data?.messengerConnect?.customerId)!)
            Erxes.saveEmail(item: (self?.tfEmail.text)!)
            
            self?.getSupporter()
            
            let vc = self?.storyboard?.instantiateViewController(withIdentifier: "conversations")
            self?.navigationController?.pushViewController(vc!, animated: true)
        }
    }
}
