
import UIKit
import LiveGQL
import WebKit

public class ChatVC: ChatVCMessage, UITextFieldDelegate{
    
    @IBOutlet weak var ivSupporterAvatar: UIImageView!
    @IBOutlet weak var lblSupporterName: UILabel!
    @IBOutlet weak var lblSupporterStatus: UILabel!
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var header:UIView!;
    
    var containerHeight:CGFloat = 0.0
    var integrationId = ""
    var customerId = ""
    var totalUnreadCountInt = 0
    var uploadUrl = ""
    var uploaded = JSON()
    var sv:UIView?
    var headerInited = false
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        checkOnline()
        setSupporterState()
        initChat()
        self.configLive()
        let bundle = Bundle(for:RegisterVC.self)
        let url = bundle.url(forResource: "ErxesSDK", withExtension: "bundle")
        self.wvChat.scrollView.bounces = false
        self.wvChat.loadHTMLString(self.css, baseURL: url)
        self.lblLoader.text = "loading".localized
        loading()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHandler), name:NSNotification.Name.UIKeyboardWillShow, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHandler), name:NSNotification.Name.UIKeyboardWillHide, object: nil);
        if conversationId != nil{
            self.subscribe()
            readConversation()
        }
        if let color = erxesColor {
            self.header.backgroundColor = color
        }
    }
    
    func loading(){
        self.loader.isHidden = false;
    }
    
    func loadEnd(){
        self.loader.isHidden = true;
    }
    
    func configLive(){
        gql.delegate = self
    }
    
    
    
    @IBAction func close(){
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func back(){
        self.navigationController?.popViewController(animated: true)
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.sendMessage(self.tfInput.text!)
        return true
    }
    
    @IBAction func sendTxt(){
        self.sendMessage(self.tfInput.text!)
    }
    
    @objc func keyboardHandler(notification: NSNotification) {
        let info = notification.userInfo!
        let keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        if  containerHeight == 0{
            self.containerHeight = self.container.frame.height
        }
        if notification.name == NSNotification.Name.UIKeyboardWillShow{
            
            print("keyboardFrame: \(keyboardFrame)")
            let size = self.view.frame.size
            let frame = CGRect(x: 0, y: 0, width: size.width, height: self.containerHeight - keyboardFrame.size.height)
            self.container.frame = frame
            let scrollPoint = CGPoint(x: 0, y: self.wvChat.scrollView.contentSize.height - self.wvChat.frame.size.height)
            self.wvChat.scrollView.setContentOffset(scrollPoint, animated: true)
        }
        if notification.name == NSNotification.Name.UIKeyboardWillHide{
            let size = self.view.frame.size
            let frame = CGRect(x: 0, y: 0, width: size.width, height: self.containerHeight)
            self.container.frame = frame
            let scrollPoint = CGPoint(x: 0, y: self.wvChat.scrollView.contentSize.height - self.wvChat.frame.size.height)
            self.wvChat.scrollView.setContentOffset(scrollPoint, animated: true)
        }
    }
}
