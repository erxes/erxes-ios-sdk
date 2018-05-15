
import UIKit

public class RegisterVC: UIViewController {

    @IBOutlet var tfEmail:UITextField!
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        if !Erxes.firstRun() {
            Erxes.restore()
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
            
            let vc = self?.storyboard?.instantiateViewController(withIdentifier: "conversations")
            self?.navigationController?.pushViewController(vc!, animated: true)
        }
    }
}
