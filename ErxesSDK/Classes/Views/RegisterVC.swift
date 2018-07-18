import UIKit

public class RegisterVC: UIViewController {

    @IBOutlet weak var segment:UISegmentedControl!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var header:UIView!
    @IBOutlet var tfEmail:UITextField!
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        UIView.animate(withDuration: 0.2, delay: 0.3, options: .curveLinear, animations: {
            self.container.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
        }, completion:nil)
        
        let defaults = UserDefaults()
        
        if let uiOptions = defaults.dictionary(forKey: "uiOptions") {
            print(uiOptions)
            if let color = uiOptions["color"] as? String {
                erxesColor = UIColor(hexString: color)
                erxesColorHex = color
            }
        }
        
        if let messengerData = defaults.dictionary(forKey: "messengerData") {
            if let msg = messengerData["welcomeMessage"] as? String {
                msgWelcome = msg
            }
        }
        
        Erxes.restore()
        
        if !Erxes.firstRun() {
            getSupporter()
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "conversations")
            self.navigationController?.pushViewController(vc!, animated: false)
        }
        else {
            if erxesEmail != nil {
                self.tfEmail.text = erxesEmail
                connectMessenger()
            }
        }
        
        changeColor()
        
        lblTitle.text = "RegVC_lblTitle".localized
        lblDesc.text = "RegVC_lblDesc".localized
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHandler), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHandler), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @IBAction public func register() {
        guard tfEmail.text != "" else {
            self.view.viewWithTag(101)?.layer.borderColor = UIColor.red.cgColor
            self.view.viewWithTag(101)?.layer.borderWidth = 1
            return
        }
        
        if emailSelected {
            guard (tfEmail.text?.isValidEmail())! else {
                self.view.viewWithTag(101)?.layer.borderColor = UIColor.red.cgColor
                self.view.viewWithTag(101)?.layer.borderWidth = 1
                return
            }
        }
        else {
            guard (tfEmail.text?.isValidPhone())! else {
                self.view.viewWithTag(101)?.layer.borderColor = UIColor.red.cgColor
                self.view.viewWithTag(101)?.layer.borderWidth = 1
                return
            }
        }
        
        connectMessenger()
    }
    
    @IBAction func close(_ sender: Any) {
        self.container.backgroundColor = .clear
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    func getSupporter() {
        let query = GetSupporterQuery(integrationId: integrationId)
        apollo.fetch(query: query) { [weak self] result, error in
            
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            if let supportersResult = result?.data?.messengerSupporters as? [GetSupporterQuery.Data.MessengerSupporter]{
                if supportersResult.count > 0 {
                    supporters = supportersResult
                    let supporter = supporters[0]
                    supporterName = supporter.details?.fullName
                    supporterAvatar = supporter.details?.avatar
                }
            }
        }
    }
    
    public func connectMessenger() {
        let connectMutation = ConnectMutation(brandCode: brandCode, email: self.tfEmail.text!, isUser: false)
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
    
    var containerHeight:CGFloat = 0.0
    @IBOutlet weak var container:UIView!
    
    @objc func keyboardHandler(notification: NSNotification) {
        
        let info = notification.userInfo!
        let keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        if  containerHeight == 0 {
            self.containerHeight = self.container.frame.height
        }
        
        if notification.name == NSNotification.Name.UIKeyboardWillShow {
            print("keyboardFrame: \(keyboardFrame)")
            let size = self.view.frame.size
            let frame = CGRect(x: 0, y: 0, width: size.width, height: self.containerHeight - keyboardFrame.size.height)
            self.container.frame = frame
        }
        
        if notification.name == NSNotification.Name.UIKeyboardWillHide {
            let size = self.view.frame.size
            let frame = CGRect(x: 0, y: 0, width: size.width, height: self.containerHeight)
            self.container.frame = frame
        }
    }
    
    var emailSelected = true
    
    func changeColor() {
        self.header.backgroundColor = erxesColor
        self.view.viewWithTag(11)?.layer.borderColor = erxesColor!.cgColor
        if emailSelected {
            self.view.viewWithTag(12)?.backgroundColor = .clear
            (self.view.viewWithTag(13) as? UILabel)?.textColor = erxesColor
            (self.view.viewWithTag(14) as? UILabel)?.textColor = erxesColor
            self.view.viewWithTag(15)?.backgroundColor = erxesColor
            (self.view.viewWithTag(16) as? UILabel)?.textColor = .white
            (self.view.viewWithTag(17) as? UILabel)?.textColor = .white
        }
        else {
            self.view.viewWithTag(12)?.backgroundColor = erxesColor
            (self.view.viewWithTag(13) as? UILabel)?.textColor = .white
            (self.view.viewWithTag(14) as? UILabel)?.textColor = .white
            self.view.viewWithTag(15)?.backgroundColor = .clear
            (self.view.viewWithTag(16) as? UILabel)?.textColor = erxesColor
            (self.view.viewWithTag(17) as? UILabel)?.textColor = erxesColor
        }
    }
    
    @IBAction func selectionChanged() {
        emailSelected = !emailSelected
        changeColor()
        if emailSelected {
            tfEmail.placeholder = "email@domain.com"
        }
        else {
            tfEmail.placeholder = "phone number".localized
        }
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.register()
        return true
    }
}
