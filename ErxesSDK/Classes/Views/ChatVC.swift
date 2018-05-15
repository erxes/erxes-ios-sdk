
import UIKit
import LiveGQL
import WebKit
import SwiftyJSON

public class ChatVC: UIViewController, UITextFieldDelegate{

    @IBOutlet weak var segment:UISegmentedControl!
    @IBOutlet weak var tfInput:UITextField!
    @IBOutlet weak var tv:UITableView!
    @IBOutlet weak var container:UIView!
    @IBOutlet weak var wvChat:UIWebView!
    var list = [JSON]()
    var containerHeight:CGFloat = 0.0
    let brandCode = "YDEdKj"
    
    var integrationId = ""
    var customerId = ""
    var conversationId:String?
    var totalUnreadCountInt = 0
    var inited = false;
    
    let css = "<style>body{background:#faf9fb;}.root{background:#faf9fb}.row{overflow:hidden;margin-bottom:10px;font-family:'Helvetica Neue',Arial,sans-serif}.row .text a{float:left;padding:8px 10px;background:#fff;border-radius:5px;color:#444;margin-bottom:5px;font-size:14px;box-shadow: 0 1px 1px 0 rgba(0,0,0,0.2)}.row .text{overflow:hidden}.me .text a{float:right;background:#7754b3;color:#fff}.row .date{color:#686868;font-size:11px}.me .date{text-align:right}p{display:inline}.row .img{float:left;margin-right:8px}.row .img img{width:40px;height:40px}.me .img{float:right}.me .img img{margin-right:0;margin-left:8px}</style><script>document.body.innerHTML+=''</script>"
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.configLive()
//        segment.addUnderlineForSelectedSegment()
        self.wvChat.scrollView.bounces = false
        self.wvChat.loadHTMLString(self.css, baseURL: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHandler), name:NSNotification.Name.UIKeyboardWillShow, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHandler), name:NSNotification.Name.UIKeyboardWillHide, object: nil);
//        self.connectMessenger()
        
        if conversationId != nil{
            self.subscribe()
        }
    }
    
    func appendToChat(_ item:JSON){
        if var str = item["payload"]["data"]["conversationMessageInserted"]["content"].string{

            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
            let now = dateFormatter.string(from: Date())

            var me = ""

            if let customerId = item["payload"]["data"]["conversationMessageInserted"]["customerId"].string{
                if customerId == Erxes.customerId{
                    me = "me"
                }
            }

            str = "<div class=\"row \(me)\"><div class=\"img\"><img src=\"https://widgets.crm.nmma.co/static/images/default-avatar.svg\"/></div><div class=\"text\"><a>\(str)</a></div><div class=\"date\">\(now)</div></div>"
            str = "document.body.innerHTML += '\(str)';window.location.href = \"inapp://scroll\""

            self.wvChat.stringByEvaluatingJavaScript(from: str)
        }
    }
    
    let gql = LiveGQL(socket: subsUrl)
    
    func configLive(){
        gql.delegate = self
    }
    
    func loadMessages(){
        
        if conversationId == nil{
            return
        }
        
        Erxes.conversationId = conversationId
        
        let messagesQuery = MessagesQuery(conversationId: self.conversationId!)
        apollo.fetch(query: messagesQuery, cachePolicy: .fetchIgnoringCacheData) { [weak self] result, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            if let allMessages = result?.data?.messages {
                let messagesArray = allMessages.map { ($0?.fragments.messageDetail)! }
                var me = ""
                var str = "";

                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"

                    for item in messagesArray {
                        var created:String! = item.createdAt
                        let tmp = Int64(created)
                        let date = Date(milliseconds:tmp!)
                        let now = dateFormatter.string(from: date)
                        print("");
                        
                        var avatar = "https://widgets.crm.nmma.co/static/images/default-avatar.svg"
                        
//                        if let user = item.user{
//                            if let userAvatar = item.user?.details?.avatar{
//                                avatar = userAvatar
//                            }
//                        }

                        me = ""
                        if let customerId = item.customerId{
                            if customerId == Erxes.customerId{
                                me = "me"
                            }
                        }
                        
                        let chat = item.content?.withoutHtml
                        str = str + "<div class=\"row \(me)\"><div class=\"img\"><img src=\"\(avatar)\"/></div><div class=\"text\"><a>\(chat!)</a></div><div class=\"date\">\(now)</div></div>"
                    }

                self?.inited = true;
                str = "document.body.innerHTML += '\(str)';window.location.href = \"inapp://scroll\""
                self?.wvChat.stringByEvaluatingJavaScript(from: str)
            }
        }
    }
    
    @IBAction func subscribe(){
        gql.subscribe(graphql: "subscription{conversationMessageInserted(_id:\"\(self.conversationId!)\"){content,userId,createdAt,customerId}}", variables: nil, operationName: nil, identifier: "conversationMessageInserted")
    }
    
    @IBAction func typeChanged(_ sender: Any) {
        
        segment.changeUnderlinePosition()
        if segment.selectedSegmentIndex == 0{
            tfInput.placeholder = "email@domain.com"
        }
        else{
            tfInput.placeholder = "phone number ..."
        }
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.sendMessage(self.tfInput.text!)
        return true
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
        }
        
        if notification.name == NSNotification.Name.UIKeyboardWillHide{
            let size = self.view.frame.size
            let frame = CGRect(x: 0, y: 0, width: size.width, height: self.containerHeight)
            self.container.frame = frame
        }
    }

    func sendMessage(_ msg:String){
        
        var mutation  = InsertMessageMutation(integrationId: Erxes.integrationId, customerId: Erxes.customerId, message: msg)
        
        if conversationId != nil{
            mutation  = InsertMessageMutation(integrationId: Erxes.integrationId, customerId: Erxes.customerId, message: msg, conversationId: self.conversationId)
        }

        apollo.perform(mutation: mutation){[weak self] result,error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            self?.tfInput.text = ""
            if self?.conversationId == nil{
                self?.conversationId = result?.data?.insertMessage?.conversationId
                Erxes.conversationId = self?.conversationId
                self?.subscribe()
                self?.loadMessages()
            }
        }
    }
}

extension ChatVC:LiveGQLDelegate{
    public func receivedRawMessage(text: String) {
        do{
            print(text)
            if let dataFromString = text.data(using: .utf8, allowLossyConversion: false) {
                let item = try JSON(data: dataFromString)
                self.list.append(item)
                self.appendToChat(item)
            }
        }
        catch{
        }
    }
}

extension ChatVC:UIWebViewDelegate{

    public func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if request.url?.scheme == "inapp"{
            if request.url?.host == "scroll"{
                let scrollPoint = CGPoint(x: 0, y: self.wvChat.scrollView.contentSize.height - self.wvChat.frame.size.height)
                self.wvChat.scrollView.setContentOffset(scrollPoint, animated: true)//Set false if you doesn't want animation
                return false
            }
        }
        return true
    }

    public func webViewDidFinishLoad(_ webView: UIWebView) {
        if(!inited){
            loadMessages();
        }
    }
}

