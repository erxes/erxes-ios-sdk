//
//  ChatView.swift
//  erxesiosdk
//
//  Created by Soyombo bat-erdene on 8/19/19.
//  Copyright © 2019 Soyombo bat-erdene. All rights reserved.
//

import UIKit
import Fusuma

class ChatView: UIViewController {
    
    // OUTLETS HERE
    //
    //    let fusuma = FusumaViewController()
    //    fusuma.delegate = self
    //    // ...
    //    fusumaCameraRollTitle = "CustomizeCameraRollTitle"
    //    fusumaCameraTitle = "CustomizeCameraTitle" // Camera Title
    //    fusumaTintColor: UIColor // tint color
    
    lazy var picker =  FusumaViewController()
    
    
    var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    lazy var flowLayout: ChatCollectionViewFlowLayout = {
        let layout = ChatCollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.scrollDirection = UICollectionView.ScrollDirection.vertical
        
        return layout
    }()
    
    
    var backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage.erxes(with: .leftarrow3, textColor: .white,size: CGSize(width: 27, height: 27)), for: .normal)
        button.addTarget(self, action: #selector(backAction(sender:)), for: .touchUpInside)
        return button
    }()
    
    var rightButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "ic_more", in: Erxes.erxesBundle(), compatibleWith: nil),for:.normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        button.addTarget(self, action: #selector(moreAction(sender:)), for: .touchUpInside)
        return button
    }()
    
    var textField:UITextField = {
        let field = UITextField()
        field.font = UIFont.systemFont(ofSize: 13)
        field.borderStyle = UITextField.BorderStyle.roundedRect
        field.placeholder = "Write a reply".localized(lang)
        field.backgroundColor = .white
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 3, height: 40))
        
        field.leftView = leftView
        let rightView = UIView(frame:CGRect(x: 0, y: 0, width: 80, height: 40))
        
        let attachButton = UIButton()
        attachButton.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        attachButton.setImage(UIImage.erxes(with: .attach, textColor: UIColor.init(hexString: "#d3d2d2")!,size: CGSize(width: 26, height: 26)), for: .normal)
        attachButton.addTarget(self, action: #selector(attachmentAction(sender:)), for: .touchUpInside)
        rightView.addSubview(attachButton)
        
        let sendButton = UIButton()
        sendButton.frame = CGRect(x: 40, y: 0, width: 40, height: 40)
        sendButton.setImage(UIImage.erxes(with: .send, textColor: UIColor.init(hexString: "#d3d2d2")!,size: CGSize(width: 26, height: 26)), for: .normal)
        sendButton.addTarget(self, action: #selector(sendAction(sender:)), for: .touchUpInside)
        rightView.addSubview(sendButton)
        
        field.rightView = rightView
        field.leftViewMode = .always
        field.rightViewMode = .always
        field.returnKeyType = UIReturnKeyType.send
        field.autocapitalizationType = .none
        field.autocorrectionType = UITextAutocorrectionType.no
        return field
    }()
    
    lazy var chatBackGroundView: UIView = {
        let imageview = UIView()
        imageview.backgroundColor = .white
        self.containerView.addSubview(imageview)
        imageview.snp.makeConstraints({ (make) in
            make.edges.equalToSuperview()
        })
        return imageview
    }()
    
    lazy var collectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: self.flowLayout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.setCollectionViewLayout(self.flowLayout, animated: true)
        collection.dataSource = self
        collection.delegate = self
        collection.backgroundColor = .white
        collection.register(CollectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "CollectionHeader")
        collection.register(CollectionFooter.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "CollectionFooter")
        collection.register(BaseCells.self, forCellWithReuseIdentifier: "BaseCells" )
        collection.register(ChatCell.self, forCellWithReuseIdentifier: ChatCell.identifier)
        collection.register(OperatorChatCell.self, forCellWithReuseIdentifier: OperatorChatCell.identifier)
        collection.register(ImageCell.self, forCellWithReuseIdentifier: ImageCell.identifier)
        self.containerView.addSubview(collection)
        collection.snp.makeConstraints({ (make) in
            make.left.right.bottom.equalToSuperview()
            //            make.top.equalToSuperview().offset(200)
            make.top.equalTo(self.headerView.snp.bottom)
        })
        //        collection.registerClass(MenuViewCell.self, forCellWithReuseIdentifier: "cell")
        return collection
    }()
    
    
    var headerView: ChatHeader = {
        let header = ChatHeader()
        header.rightButton.isHidden = true
        return header
    }()
    
    // VARIABLES HERE
    var collectionViewLoaded = false
    var conversationId = String()
    var viewModel = ChatViewModel()
    var chats = [MessageModel]() {
        didSet {
            
        }
    }
    
    var calculatedHeights: [CGFloat] = []
    var calculatedWidths: [CGFloat] = []
    var containerHeight:CGFloat = 0.0
    var mainTitle: String?
    var subTitle: String?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHandler), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHandler), name:UIResponder.keyboardWillHideNotification, object: nil)
        
        prepareViews()
        self.setupViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.viewModel.conversationDetail(id: conversationId, integrationId: erxesIntegrationId)
        if conversationId.count != 0 {
            self.viewModel.getMessages(conversationId: conversationId)
            self.viewModel.subscribe(conversationId: conversationId)
            self.viewModel.read(conversationId: conversationId)
        }else {
            var h:CGFloat = 0
            if self.viewModel.isOnline {
                if let message = welcome {
                    h = message.height(withWidth: SCREEN_WIDTH - 80, font: UIFont.systemFont(ofSize: 18))
                }
                self.flowLayout.headerReferenceSize = CGSize(width: SCREEN_WIDTH, height: h + 40)
            }else {
                if let message = away {
                    h = message.height(withWidth: SCREEN_WIDTH - 80, font: UIFont.systemFont(ofSize: 18))
                }
                self.flowLayout.footerReferenceSize = CGSize(width: SCREEN_WIDTH, height: h + 40)
            }
            
            self.collectionView.reloadData()
        }
        
        
        
        let height: CGFloat = 150 //whatever height you want to add to the existing height
        let bounds = self.navigationController!.navigationBar.bounds
        self.navigationController?.navigationBar.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height + height)
        
    }
    
    func prepareViews() {
        view.backgroundColor = .clear
        view.addSubview(textField)
        textField.delegate = self
        view.addSubview(containerView)
        containerView.addSubview(headerView)
        headerView.titleLabel.text = titleText
//        headerView.subTitleLabel.text = descriptionText
        headerView.addSubview(backButton)
        headerView.addSubview(rightButton)
        headerView.setSupperters(supporters: supporters)
        if let bg = wallPaper {
            self.collectionView.backgroundColor = UIColor.init(patternImage: UIImage(named: "bg-\(bg)", in: Erxes.erxesBundle(), compatibleWith: nil)!)
            
            self.view.bringSubviewToFront(headerView)
        }
        
        picker.delegate = self
        fusumaTintColor = themeColor!
        fusumaTitleFont = UIFont.boldSystemFont(ofSize: 15)
        picker.allowMultipleSelection = false
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        textField.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(3)
            make.right.equalToSuperview().offset(-3)
            make.bottom.equalTo(bottomLayoutGuide.snp.top)
            make.height.equalTo(40)
        }
        containerView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(topLayoutGuide.snp.bottom).offset(10)
            make.bottom.equalTo(self.textField.snp.top)
        }
        
        headerView.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(150)
        }
        
        backButton.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(8)
            make.width.height.equalTo(40)
            make.top.equalToSuperview().offset(12)
        }
        
        rightButton.snp.makeConstraints { (make) in
            make.width.height.equalTo(40)
            make.top.equalToSuperview().offset(12)
            make.right.equalToSuperview().offset(-8)
        }
        containerView.roundCorners(corners: [.topLeft, .topRight], radius: 8)
        textField.dropShadow()
        
        
        
    }
    
    
    
    
    
    fileprivate func setupViewModel() {
        
        self.viewModel.showAlertClosure = {
            let alert = self.viewModel.alertMessage ?? ""
            print(alert)
        }
        
        self.viewModel.updateLoadingStatus = {
            if self.viewModel.isLoading {
                print("LOADING...")
            } else {
                print("DATA READY")
            }
        }
        
        self.viewModel.internetConnectionStatus = {
            print("Internet disconnected")
            // show UI Internet is disconnected
        }
        
        self.viewModel.serverErrorStatus = {
            print("Server Error / Unknown Error")
            // show UI Server is Error
        }
        
        self.viewModel.didSetIsOnline = { isOnline in
            
            var h:CGFloat = 0
            if isOnline {
                if let message = welcome {
                    h = message.height(withWidth: SCREEN_WIDTH - 80, font: UIFont.systemFont(ofSize: 18))
                }
                self.flowLayout.headerReferenceSize = CGSize(width: SCREEN_WIDTH, height: h + 40)
            }else {
                if let message = away {
                    h = message.height(withWidth: SCREEN_WIDTH - 80, font: UIFont.systemFont(ofSize: 18))
                }
                self.flowLayout.footerReferenceSize = CGSize(width: SCREEN_WIDTH, height: h + 40)
            }
            
            self.collectionView.reloadData()
            //            self.forceScrollToBottom()
        }
        self.viewModel.didGetData = { data in
            // update UI after get data
            
            self.chats = data
            
            
            self.collectionView.reloadData()
            self.forceScrollToBottom()
            
            
        }
        
        
        
        self.viewModel.didReceiveMessage = { data in
            self.conversationId = data.conversationId
            if self.isNewMessage(id: data.id) {
                self.chats.append(data)
                if self.chats.count > 1 {
                    let indexPath = IndexPath(item: self.chats.count - 1, section: 0)
                    self.collectionView.insertItems(at: [indexPath])
                    self.collectionView.reloadData()
                    self.scrollToBottom()
                }else {
                    self.collectionView.reloadData()
                    
                }
                
            }
        }
        
    }
    
    @objc func backAction(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func moreAction(sender:UIButton) {
        let moreView = MoreView()
        moreView.delegate = self
        self.presentViewControllerAsPopover(viewController: moreView, from: sender)
        self.textField.resignFirstResponder()
    }
    
    
    func presentViewControllerAsPopover(viewController: UIViewController, from: UIView) {
        
        
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            viewController.modalPresentationStyle = .popover
            let viewPresentationController = viewController.popoverPresentationController
            if let presentationController = viewPresentationController {
                presentationController.delegate = self
                presentationController.permittedArrowDirections = .up
                presentationController.sourceView = from
                presentationController.sourceRect = from.bounds
            }
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 13)
            label.text = "End conversation".localized(lang)
            label.sizeToFit()
            viewController.preferredContentSize = CGSize(width: label.frame.size.width + 20, height: 80)
            
            topController.present(viewController, animated: true, completion: nil)
        }
        
        
    }
    
    @objc func attachmentAction(sender:UIButton) {
        self.present(self.picker, animated: true, completion: nil)
    }
    
    @objc func sendAction(sender:UIButton) {
        let mutation = InsertMessageMutation(integrationId: erxesIntegrationId, customerId: erxesCustomerId)
        if conversationId.count != 0 {
            mutation.conversationId = conversationId
        }
        mutation.message = textField.text
        self.viewModel.insertMessage(mutation: mutation)
        textField.text = ""
    }
    
    func isNewMessage(id:String) -> Bool {
        let temp = self.chats.filter{$0.id == id}
        if temp.count != 0 {
            return false
        }else {
            return true
        }
    }
    
    
    func startUplaoder(image:UIImage){
        let uploader = UploadView(image: image)
        uploader.tag = 55
        uploader.delegate = self
        self.view.addSubview(uploader)
        
    }
    
    @objc func keyboardHandler(notification: NSNotification) {
        let info = notification.userInfo!
        
        var keyboardFrame: CGRect
        if let keyBoardInfo = info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            keyboardFrame = keyBoardInfo.cgRectValue
        }else {
            return
        }
        
        
        if notification.name == UIResponder.keyboardWillShowNotification{
            UIView.animate(withDuration: 0.3) {
                
                self.headerView.snp.updateConstraints({ (make) in
                    make.height.equalTo(64)
                })
                
                
                self.textField.snp.remakeConstraints { (make) in
                    make.bottom.equalToSuperview().offset(-keyboardFrame.size.height)
                    make.height.equalTo(40)
                    make.left.equalToSuperview().offset(3)
                    make.right.equalToSuperview().offset(-3)
                }
                self.textField.layoutIfNeeded()
                self.collectionView.snp.remakeConstraints({ (make) in
                    make.top.equalToSuperview().offset(64)
                    make.bottom.equalTo(self.textField.snp.top)
                    make.width.equalToSuperview()
                })
                self.collectionView.layoutIfNeeded()
            }
            
        }
        if notification.name == UIResponder.keyboardWillHideNotification {
            UIView.animate(withDuration: 0.3) {
                
                self.headerView.snp.updateConstraints({ (make) in
                    make.height.equalTo(64)
                })
                
                
                self.textField.snp.remakeConstraints { (make) in
                    make.bottom.equalTo(self.bottomLayoutGuide.snp.top)
                    make.height.equalTo(40)
                    make.left.equalToSuperview().offset(3)
                    make.right.equalToSuperview().offset(-3)
                }
                self.textField.layoutIfNeeded()
                self.collectionView.snp.remakeConstraints({ (make) in
                    make.top.equalToSuperview().offset(64)
                    make.bottom.equalTo(self.textField.snp.top)
                    make.width.equalToSuperview()
                })
                self.collectionView.layoutIfNeeded()
            }
        }
        
        if notification.name == UIResponder.keyboardDidShowNotification {
            self.scrollToBottom()
        }
    }
    
}





extension ChatView: AttachmentUploadDelegate {
    func attachmentUploaded(file: AttachmentInput) {
        if let uploadView = self.view.viewWithTag(55) {
            uploadView.removeFromSuperview()
        }
        let mutation = InsertMessageMutation(integrationId: erxesIntegrationId, customerId: erxesCustomerId)
        if conversationId.count != 0 {
            mutation.conversationId = conversationId
        }
        mutation.attachments = [file]
        self.viewModel.insertMessage(mutation: mutation)
        textField.text = ""
    }
}


extension ChatView: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}


extension ChatView: MoreViewDelegate {
    func close() {
       
        self.dismiss(animated: true, completion: nil)
    }
    
    func end() {
        self.dismiss(animated: true) {
            Erxes.endSession()
        }
    }
}
