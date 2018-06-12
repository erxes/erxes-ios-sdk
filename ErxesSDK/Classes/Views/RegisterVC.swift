
import UIKit

public class RegisterVC: UIViewController {

    @IBOutlet weak var segment:UISegmentedControl!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    
    @IBOutlet var tfEmail:UITextField!
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        let defaults = UserDefaults()
        
        if let uiOptions = defaults.dictionary(forKey: "uiOptions"){
            print(uiOptions)
            if let color = uiOptions["color"] as? String{
                Erxes.color = UIColor(hexString: color)
                Erxes.colorHex = color
            }
        }
        
        if let messengerData = defaults.dictionary(forKey: "messengerData"){
            if let msg = messengerData["welcomeMessage"] as? String{
                Erxes.msgWelcome = msg
            }
        }
        
        Erxes.restore()
        
        if !Erxes.firstRun() {
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
        
        lblTitle.text = "RegVC_lblTitle".localized
        lblDesc.text = "RegVC_lblDesc".localized
    }
    
    @IBAction public func register(){
        guard tfEmail.text != "" else {
            return
        }
        
        if segment.selectedSegmentIndex == 0{
            guard (tfEmail.text?.isValidEmail())! else {
                return
            }
        }
        else{
            guard (tfEmail.text?.isValidPhone())! else {
                return
            }
        }
        
        connectMessenger()
    }
    
    @IBAction func close(_ sender: Any) {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func changed(_ sender: Any) {
        if segment.selectedSegmentIndex == 0{
            tfEmail.placeholder = "email@domain.com"
        }
        else{
            tfEmail.placeholder = "****-****"
        }
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
        let connectMutation = ConnectMutation(brandCode: Erxes.brandCode, email: self.tfEmail.text!, isUser: false)
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
            self?.navigationController?.pushViewController(vc!, animated: false)
        }
    }
}
