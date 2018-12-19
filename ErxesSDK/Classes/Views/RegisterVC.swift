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
        
        fillValues()
        
        Erxes.restore()
        
        if !Erxes.firstRun() {
//            getSupporter()
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "conversations")
            self.navigationController?.pushViewController(vc!, animated: false)
            
        } else {
            if erxesEmail.count > 0 || erxesPhone.count > 0 {
                self.tfEmail.text = erxesEmail
                connectMessenger()
            }
        }
        changeColor()
        
        lblTitle.text = "RegVC_lblTitle".localized
        lblDesc.text = "RegVC_lblDesc".localized
        var name = NSNotification.Name.UIKeyboardWillShow
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHandler), name:name, object: nil)
        name = NSNotification.Name.UIKeyboardWillHide
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHandler), name:name, object: nil)
    }
    
    func fillValues() {
        let defaults = UserDefaults()
        
        if let uiOptions = defaults.dictionary(forKey: "uiOptions") {
            print(uiOptions)
            if let color = uiOptions["color"] as? String {
                erxesColor = UIColor(hexString: color)
                erxesColorHex = color
            }
        }
        
        if let messengerData = defaults.dictionary(forKey: "messengerData") {
            if let language = defaults.string(forKey: "languageCode"),
                let messages = messengerData["messages"] as? JSON,
                let msgData = messages[language] as? JSON{
                if let welcome = msgData["welcome"] as? String {
                    msgWelcome = welcome
                }
                
                if let greetings = msgData["greetings"] as? JSON, let msg = greetings["message"] as? String {
                    msgGreetings = msg
                }
                
//                if let welcome = messengerData["messages"] as?
            }
        }
    }
    
    @IBAction public func register() {
        guard tfEmail.text != "" else {
            self.view.viewWithTag(101)?.layer.borderColor = UIColor.red.cgColor
            self.view.viewWithTag(101)?.layer.borderWidth = 1
            return
        }
        
        if emailFirst {
            guard (tfEmail.text?.isValidEmail())! else {
                self.view.viewWithTag(101)?.layer.borderColor = UIColor.red.cgColor
                self.view.viewWithTag(101)?.layer.borderWidth = 1
                return
            }
            erxesEmail = tfEmail.text!
        } else {
            guard (tfEmail.text?.isValidPhone())! else {
                self.view.viewWithTag(101)?.layer.borderColor = UIColor.red.cgColor
                self.view.viewWithTag(101)?.layer.borderWidth = 1
                return
            }
            erxesPhone = tfEmail.text!
        }
        
        connectMessenger()
    }
    
    @IBAction func close(_ sender: Any) {
        self.container.backgroundColor = .clear
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
//    func getSupporter() {
//
//        let query = ConversationDetailQuery(integrationId: integrationId)
//        apollo.fetch(query: query) { [weak self] result, error in
//
//            if let error = error {
//                print(error.localizedDescription)
//                return
//            }
//
//            if let supportersResult = result?.data?.conversationDetail?.supporters as? [ConversationDetailQuery.Data.ConversationDetail.Supporter] {
//                if supportersResult.count == 0 { return }
//                supporters = supportersResult
//                isOnline = (result?.data?.conversationDetail?.isOnline)!
//                let supporter = supporters[0]
//                supporterName = supporter.details?.fullName
//                supporterAvatar = supporter.details?.avatar
//            }
//        }
//    }
    
    func getSupporter() {

        let query = GetSupportersQuery(integrationId: integrationId)
        apollo.fetch(query: query) { [weak self] result, error in

            if let error = error {
                print(error.localizedDescription)
                return
            }

            if let list = result?.data?.messengerSupporters, list.count > 0 {
                supporters = list as! [GetSupportersQuery.Data.MessengerSupporter]
                let supporter = supporters[0]
                supporterName = supporter.details?.fullName
                supporterAvatar = supporter.details?.avatar
            }
        }
    }
    
    public func connectMessenger() {
        
        let mutation = ConnectMutation(brandCode: brandCode, isUser:false)
        
        if erxesEmail.count > 0 {
            mutation.email = erxesEmail
            mutation.isUser = true
        }
        
        if erxesPhone.count > 0 {
            mutation.phone = erxesPhone
            mutation.isUser = true
        }
        
        if erxesUserData.keys.count > 0 {
            mutation.data = erxesUserData
        }
        
        apollo.perform(mutation: mutation) { [weak self] result, error in
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
        
        var keyboardFrame: CGRect
        if let keyBoardInfo = info[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            keyboardFrame = keyBoardInfo.cgRectValue
            
        } else {
            return
        }
        
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
    
    func selectEmail() {
        self.view.viewWithTag(12)?.backgroundColor = .clear
        lblWithTag(13).textColor = erxesColor
        lblWithTag(14).textColor = erxesColor
        self.view.viewWithTag(15)?.backgroundColor = erxesColor
        lblWithTag(16).textColor = .white
        lblWithTag(17).textColor = .white
    }
    
    func selectPhone() {
        self.view.viewWithTag(12)?.backgroundColor = erxesColor
        lblWithTag(13).textColor = .white
        lblWithTag(14).textColor = .white
        self.view.viewWithTag(15)?.backgroundColor = .clear
        lblWithTag(16).textColor = erxesColor
        lblWithTag(17).textColor = erxesColor
    }
    
    func lblWithTag(_ tag:Int) -> UILabel {
        if let lbl = self.view.viewWithTag(tag) as? UILabel {
            return lbl
        }
        return UILabel()
    }
    
    func changeColor() {
        self.header.backgroundColor = erxesColor
        self.view.viewWithTag(11)?.layer.borderColor = erxesColor!.cgColor
        if emailFirst {
            selectEmail()
        } else {
            selectPhone()
        }
    }
    
    @IBAction func selectionChanged() {
        emailFirst = !emailFirst
        changeColor()
        if emailFirst {
            tfEmail.placeholder = "email@domain.com"
        } else {
            tfEmail.placeholder = "phone number".localized
        }
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.register()
        return true
    }
}
