
import UIKit
import LiveGQL
import WebKit
import Photos
import Alamofire

public class ChatVC: UIViewController, UITextFieldDelegate{

    @IBOutlet weak var segment:UISegmentedControl!
    @IBOutlet weak var tfInput:UITextField!
    @IBOutlet weak var tv:UITableView!
    @IBOutlet weak var container:UIView!
    @IBOutlet weak var wvChat:UIWebView!
    @IBOutlet weak var ivSupporterAvatar: UIImageView!
    @IBOutlet weak var lblSupporterName: UILabel!
    @IBOutlet weak var lblSupporterStatus: UILabel!
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var lblStatus: UILabel!
    
    @IBOutlet weak var progress: UIProgressView!
    @IBOutlet weak var btnSend: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var uploadView: UIView!
    @IBOutlet weak var ivPicked: UIImageView!
    @IBOutlet weak var lblFilesize: UILabel!
    @IBOutlet weak var loader: UIView!
    
    var attachments = [JSON]()
    
    var containerHeight:CGFloat = 0.0
    
    var integrationId = ""
    var customerId = ""
    var conversationId:String?
    var totalUnreadCountInt = 0
    var inited = false;
    var bg = "#7754b3"
    var css = ""
    var uploadUrl = ""
    var uploaded = JSON()
    
    var sv:UIView?
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        checkOnline()
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        if let supporterAvatar = Erxes.supporterAvatar{
            self.ivSupporterAvatar.downloadedFrom(link: supporterAvatar)
        }
        else{
            Erxes.supporterAvatar = "avatar.png"
        }
        if let supporterName = Erxes.supporterName{
            self.lblSupporterName.text = supporterName
        }
        else{
            Erxes.supporterAvatar = "Хэрэглэгчид туслах"
        }
        initChat()
        
        self.configLive()
//        segment.addUnderlineForSelectedSegment()
        
        let bundle = Bundle(for:RegisterVC.self)
        let url = bundle.url(forResource: "ErxesSDK", withExtension: "bundle")
        
        self.wvChat.scrollView.bounces = false
        self.wvChat.loadHTMLString(self.css, baseURL: url)
        
        loading()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHandler), name:NSNotification.Name.UIKeyboardWillShow, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHandler), name:NSNotification.Name.UIKeyboardWillHide, object: nil);
        
        if conversationId != nil{
            self.subscribe()
            readConversation()
        }
        
//        self.attachments
    }
    
    func loading(){
        self.loader.isHidden = false;
    }
    
    func loadEnd(){
        self.loader.isHidden = true;
    }
    
    func readConversation(){
        if let conversationId = self.conversationId{
            let mutation = ReadConversationMessagesMutation(conversationId: conversationId)
            apollo.perform(mutation: mutation){result,error in
                if let error = error{
                    print(error)
                    return
                }
                print(result)
            }
        }
    }
    
    func checkOnline(){
        let query = IsSupporterOnlineQuery(integrationId: Erxes.integrationId)
        apollo.fetch(query: query){ [weak self] result, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            if let isOnline = result?.data?.isMessengerOnline{
                if isOnline{
                    self?.statusView.backgroundColor = UIColor(hexString: "#67B04F")
                    self?.lblStatus.text = "Онлайн"
                }
                else{
                    self?.statusView.backgroundColor = UIColor(hexString: "#DDDDDD")
                    self?.lblStatus.text = "Оффлайн"
                }
            }
        }
    }
    
    func initChat(){
        
        if let color = Erxes.colorHex{
            bg = color
        }
        
        var str = ""
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
//        let now = dateFormatter.string(from: Date())
        let now = NMFormatter.now()
        str = "<div class=\"row\"><div class=\"img\"><img src=\"\(Erxes.supporterAvatar!)\"/></div><div class=\"text\"><a>\(Erxes.msgWelcome ?? "")</a></div><div class=\"date\">\(now!)</div></div>"
//        str = "document.body.innerHTML += '\(str)';window.location.href = \"inapp://scroll\""
//        self.wvChat.stringByEvaluatingJavaScript(from: str)
        
        css = "<style>body{background:url('bg-1.png');}.root{background:#faf9fb}.row{overflow:hidden;margin-bottom:10px;font-family:'Helvetica Neue',Arial,sans-serif}.row .text a{float:left;padding:8px 10px;background:#fff;border-radius:5px;color:#444;margin-bottom:5px;font-size:14px;box-shadow: 0 1px 1px 0 rgba(0,0,0,0.2)}.row .text{overflow:hidden}.me .text a{float:right;background:\(bg);color:#fff}.row .text img{max-width:100%; height:auto!; padding-top:3px;} .row .date{color:#686868;font-size:11px}.me .date{text-align:right}p{display:inline}.row .img{float:left;margin-right:8px}.row .img img{width:40px;height:40px;border-radius:20px;}.me .img{float:right}.me .img img{margin-right:0;margin-left:8px}</style>\(str)"
    }
    
    func appendToChat(_ item:MessageSubs){
        
        if let message = item.payload?.data?.conversationMessageInserted{
            
            var str = ""
            
            if let content = message.content{
                str = content
            }
            
            let now = NMFormatter.now()

            var me = ""

            if let customerId = message.customerId{
                if customerId == Erxes.customerId{
                    me = "me"
                }
            }
            
            var avatar = "avatar.png"
            
            if let userAvatar = message.user?.details?.avatar{
                avatar = userAvatar
            }
            
            var image = ""
            
            if message.attachments.count > 0{
                let attachment = message.attachments[0]
                if let img = attachment!.url{
                    image = img
                }
            }

            str = "<div class=\"row \(me)\"><div class=\"img\"><img src=\"\(avatar)\"/></div><div class=\"text\"><a>\(str)<img src=\"\(image)\"/></a></div><div class=\"date\">\(now!)</div></div>"
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

                    for item in messagesArray {
                        let created:String! = item.createdAt
                        let now = Utils.formatDate(time: created)
                        print("");
                        
                        var avatar = "avatar.png"
                        
                        if let user = item.user{
                            if let userAvatar = user.details?.avatar{
                                avatar = userAvatar
                            }
                        }

                        me = ""
                        if let customerId = item.customerId{
                            if customerId == Erxes.customerId{
                                me = "me"
                            }
                        }
                        
                        var image = ""
                        
                        if let attachments = item.attachments{
                            if attachments.count > 0{
                                let attachment = attachments[0]
                                
                                if let url = attachment!["url"] as? String{
                                    image = url
                                }
                                
//                                if let dataFromString = attachment?.data(using: .utf8, allowLossyConversion: false) {
//                                    do{
//                                        let item = try JSONDecoder().decode(Attachment.self, from: dataFromString)
//                                        image = item.url!
//                                    }
//                                    catch{
//                                        print("Error info: \(error)")
//                                    }
//                                }
                            }
                        }
                        
                        let chat = item.content?.withoutHtml
                        str = str + "<div class=\"row \(me)\"><div class=\"img\"><img src=\"\(avatar)\"/></div><div class=\"text\"><a>\(chat!)<img src=\"\(image)\"/></a></div><div class=\"date\">\(now!)</div></div>"
                    }

                self?.inited = true;
                str = "document.body.innerHTML += '\(str)';window.location.href = \"inapp://scroll\""
                self?.wvChat.stringByEvaluatingJavaScript(from: str)
            }
        }
    }
    
    @IBAction func subscribe(){
        gql.subscribe(graphql: "subscription{conversationMessageInserted(_id:\"\(self.conversationId!)\"){content,userId,createdAt,customerId,user{details{avatar}},attachments}}", variables: nil, operationName: nil, identifier: "conversationMessageInserted")
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
            mutation  = InsertMessageMutation(integrationId: Erxes.integrationId, customerId: Erxes.customerId, message: msg, conversationId: self.conversationId, attachments:attachments)
        }

        apollo.perform(mutation: mutation){[weak self] result,error in
            self?.uploadView.isHidden = true
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
    
    @IBAction func btnAttachClick(){
        checkPermission()
    }
    
    func checkPermission(){
        
        let photos = PHPhotoLibrary.authorizationStatus()
        if photos == .notDetermined {
            PHPhotoLibrary.requestAuthorization({status in
                if status == .authorized{
                    self.openGallery()
                } else {
                }
            })
        }
        else{
            self.openGallery()
        }
    }
    
    func uploadFile(image:UIImage){
        
        self.uploadView.isHidden = false;
        
        let url = "http://localhost:3300/upload-file"
        let imgData = UIImageJPEGRepresentation(image, 0.5)!
        let size = imgData.count
        let bcf = ByteCountFormatter()
        bcf.allowedUnits = [.useKB] // optional: restricts the units to MB only
        bcf.countStyle = .file
        self.lblFilesize.text = bcf.string(fromByteCount: Int64(size))
        
//        let parameters = ["name": rname] //Optional for extra parameter
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imgData, withName: "file",fileName: "file.jpg", mimeType: "image/jpg")
//            for (key, value) in parameters {
//                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
//            } //Optional for extra parameters
        },
                         to:url)
        { (result) in
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (progress) in
                    print("Upload Progress: \(progress.fractionCompleted)")
                    self.progress.progress = Float(progress.fractionCompleted)
                })
                
                upload.responseString { response in
                    print(response)
                    self.uploadUrl = response.value!
                    self.uploaded = ["url" : self.uploadUrl, "size" : size, "type" : "image/jpeg"]
                }
                
            case .failure(let encodingError):
                print(encodingError)
            }
        }
        
    }
    
    func sendAttachment(){
        
    }
    
    func openGallery()
    {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
//        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func btnSendClick(_ sender: Any) {
        self.uploadView.isHidden = false;
        self.attachments = [JSON]()
        self.attachments.append(self.uploaded)
        sendMessage("")
    }
    
    @IBAction func btnCancelClick(_ sender: Any) {
        self.uploadView.isHidden = false;
    }
    
}

extension ChatVC:UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true, completion: nil)
        print(info)
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        ivPicked.image = chosenImage
        uploadFile(image: chosenImage)
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

extension ChatVC:LiveGQLDelegate{
    
    public func receivedRawMessage(text: String) {
        do{
            print(text)
            if let dataFromString = text.data(using: .utf8, allowLossyConversion: false) {
                let item = try JSONDecoder().decode(MessageSubs.self, from: dataFromString)
                self.appendToChat(item)
            }
        }
        catch{
            print(error)
        }
    }
}

extension ChatVC:UIWebViewDelegate{

    public func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if request.url?.scheme == "inapp"{
            if request.url?.host == "scroll"{
                let scrollPoint = CGPoint(x: 0, y: self.wvChat.scrollView.contentSize.height - self.wvChat.frame.size.height)
                self.wvChat.scrollView.setContentOffset(scrollPoint, animated: true)
                return false
            }
        }
        return true
    }

    public func webViewDidFinishLoad(_ webView: UIWebView) {
        
        loadEnd()
        
        if(!inited){
            loadMessages();
        }
    }
}

