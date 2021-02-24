//
//  MessengerView.swift
//  Erxes iOS SDK
//
//  Created by soyombo bat-erdene on 5/1/20.
//  Copyright © 2020 Soyombo bat-erdene. All rights reserved.
//

import UIKit
import Fusuma
import CoreServices


class MessengerView: AbstractViewController {

    // OUTLETS HERE
    var messengerHeader = MessengerHeader()
    
    let backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage.erxes(with: .leftarrow3, textColor: .white, size: CGSize(width: 27, height: 27)), for: .normal)
        button.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        return button
    }()
    
    let moreButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "ic_more",in: Erxes.erxesBundle(), compatibleWith: nil), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 12, left: 20, bottom: 12, right: 0)
        button.imageView!.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(moreAction(sender:)), for: .touchUpInside)
        return button
    }()
    
    lazy var picker = FusumaViewController()
    lazy var cameraPicker = FusumaViewController()
    lazy var flowLayout: MessengerFlowLayout = {
        let layout = MessengerFlowLayout()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.scrollDirection = UICollectionView.ScrollDirection.vertical

        return layout
    }()

    var textField: UITextField = {
        let field = UITextField()
        field.font = UIFont.systemFont(ofSize: 13)
//        field.borderStyle = UITextField.BorderStyle.roundedRect
        field.placeholder = "Write a reply".localized(lang)
        field.backgroundColor = .white
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 3, height: 40))

        field.leftView = leftView
        let rightView = UIView(frame: CGRect(x: 0, y: 0, width: 80, height: 40))


        if let showVideoCall = uiOptions?.videoCallUsageStatus, showVideoCall == true {
            let callButton = UIButton()
            callButton.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
            callButton.setImage(UIImage.erxes(with: .videocamera, textColor: .black, size: CGSize(width: 26, height: 26)), for: .normal)
            callButton.addTarget(self, action: #selector(callAction(sender:)), for: .touchUpInside)
            rightView.addSubview(callButton)
        }


        let attachButton = UIButton()
        attachButton.frame = CGRect(x: 40, y: 0, width: 40, height: 40)
        attachButton.setImage(UIImage.erxes(with: .attach, textColor: .black, size: CGSize(width: 26, height: 26)), for: .normal)
        attachButton.addTarget(self, action: #selector(attachmentAction(sender:)), for: .touchUpInside)
        rightView.addSubview(attachButton)


        field.rightView = rightView
        field.leftViewMode = .always
        field.rightViewMode = .always
        field.returnKeyType = UIReturnKeyType.send
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
        collection.register(BaseCells.self, forCellWithReuseIdentifier: "BaseCells")
        collection.register(ChatCell.self, forCellWithReuseIdentifier: ChatCell.identifier)
        collection.register(OperatorChatCell.self, forCellWithReuseIdentifier: OperatorChatCell.identifier)
        collection.register(ImageCell.self, forCellWithReuseIdentifier: ImageCell.identifier)
        collection.register(VideoChatCell.self, forCellWithReuseIdentifier: VideoChatCell.identifier)

        self.containerView.addSubview(collection)
        collection.snp.makeConstraints({ (make) in
            make.left.right.equalToSuperview()
            make.bottom.equalTo(self.textField.snp.top)
            make.top.equalTo(self.messengerHeader.snp.bottom)
        })
        //        collection.registerClass(MenuViewCell.self, forCellWithReuseIdentifier: "cell")
        return collection
    }()

    // VARIABLES HERE
    var conversationId: String?
    var calculatedHeights: [CGFloat] = []
    var calculatedWidths: [CGFloat] = []
    var collectionViewLoaded = false
    var isCollapsed = false
    var headerFullHeight = CGFloat()

    var viewModel = MessengerViewModel()

    var messages = [MessageModel]()

    var participatedUser: UserDetailModel? {
        didSet {
            self.messengerHeader.setSupporter(supporter: self.participatedUser!)
        }
    }
    var supporters = [UserModel]() {
        didSet {
            self.messengerHeader.setSupporters(supporters: supporters)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        topOffset = 60
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHandler), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHandler), name: UIResponder.keyboardWillHideNotification, object: nil)
        self.containerView.addSubview(messengerHeader)
        self.containerView.addSubview(textField)
        self.containerView.addSubview(backButton)
        self.containerView.addSubview(moreButton)
        self.setupViewModel()


        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(animateHeader))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.delegate = messengerHeader
        self.messengerHeader.addGestureRecognizer(tapGesture)

        view.addSubview(textField)
        textField.delegate = self


        if let bg = uiOptions?.wallpaper {
            guard let img = UIImage(named: "bg-\(bg)", in: Erxes.erxesBundle(), compatibleWith: nil) else {
                return
            }
            self.collectionView.backgroundColor = UIColor.init(patternImage: img)
        } else {
            self.collectionView.backgroundColor = .white
        }

        picker.delegate = self
        cameraPicker.delegate = self
        fusumaTintColor = UIColor(hexString: (uiOptions?.color) ?? defaultColorCode)!
        fusumaTitleFont = UIFont.boldSystemFont(ofSize: 15)

        picker.allowMultipleSelection = false
        cameraPicker.allowMultipleSelection = false
    }
    
    @objc func backAction() {

        self.navigationController?.popViewController(animated: true)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
       
        if (conversationId != nil) {
            self.viewModel.conversationDetail(conversationId: conversationId)
            self.viewModel.subscribe(conversationId: conversationId!)
            self.viewModel.readConversation(id: conversationId!)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.viewModel.cancelSubscription()
    }

    fileprivate func setupViewModel() {

        self.viewModel.showAlertClosure = {

        }

        self.viewModel.updateLoadingStatus = {
            if self.viewModel.isLoading {
                
            } else {
                
            }
        }

        self.viewModel.internetConnectionStatus = {
            
            // show UI Internet is disconnected
        }

        self.viewModel.serverErrorStatus = { error in
            
            // show UI Server is Error
        }

        self.viewModel.didGetConversationDetail = {  conversationDetail in

            self.messages = conversationDetail.messages?.compactMap({ $0?.fragments.messageModel }) ?? []

            self.messages = self.messages.filter({$0.botData == nil})
            
            self.collectionView.reloadData()
            self.forceScrollToBottom()
        }

        self.viewModel.didGetSupporters = { supporters in
            self.messengerHeader.setSupporters(supporters: supporters)
        }

        self.viewModel.didSetIsOnline = { isOnline in

            var h: CGFloat = 0
            if isOnline {
                if let message = messengerData?.messages?.welcome {
                    h = message.height(withWidth: SCREEN_WIDTH - 80, font: UIFont.systemFont(ofSize: 18))
                }
                self.flowLayout.headerReferenceSize = CGSize(width: SCREEN_WIDTH, height: h + 40)
            } else {
                if let message = messengerData?.messages?.away {
                    h = message.height(withWidth: SCREEN_WIDTH - 80, font: UIFont.systemFont(ofSize: 18))
                }
                self.flowLayout.footerReferenceSize = CGSize(width: SCREEN_WIDTH, height: h + 40)
            }

            self.collectionView.reloadData()
            //            self.forceScrollToBottom()
        }

        self.viewModel.didReceiveMessage = { data in

            if ((data.customerId != nil) && (customerId == nil)) {
                customerId = data.customerId
            }
            
            if (self.conversationId == nil) || self.conversationId?.count == 0 {
                self.conversationId = data.conversationId!

                self.viewModel.subscribe(conversationId: self.conversationId!)
            }

            if self.isNewMessage(id: data._id) {
                self.messages.append(data)
                if self.messages.count > 1 {
                    let indexPath = IndexPath(item: self.messages.count - 1, section: 0)
                    self.collectionView.insertItems(at: [indexPath])
                    self.collectionView.reloadData()
                    self.scrollToBottom()
                } else {
                    self.collectionView.reloadData()

                }

            }
        }


    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        messengerHeader.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()

        }

        textField.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(40)
        }
        
        backButton.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(8)
            make.top.equalToSuperview().offset(10)
            make.width.height.equalTo(44)
        }
        
        moreButton.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-8)
            make.top.equalToSuperview().offset(10)
            make.width.height.equalTo(44)
        }
    }

    @objc func attachmentAction(sender: UIButton) {

        self.view.endEditing(true)
        
        let alertContoller = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let fileAction = UIAlertAction(title: "Open file browser", style: .default) { (action) in
            alertContoller.dismiss(animated: true) {



                let fileBrowser = UIDocumentPickerViewController(documentTypes: [kUTTypePDF as String], in: .open)
                fileBrowser.delegate = self
                fileBrowser.view.tintColor = UIColor(hexString: uiOptions?.color ?? defaultColorCode)
                self.present(fileBrowser, animated: true, completion: nil)

            }
        }

        let photosAction = UIAlertAction(title: "Choose from library", style: .default) { (action) in

            alertContoller.dismiss(animated: true) {

                self.picker.availableModes = [.library]
                self.present(self.picker, animated: true, completion: nil)
            }
        }

        let cameraAction = UIAlertAction(title: "Take a photo", style: .default) { (action) in
            alertContoller.dismiss(animated: true) {

                self.cameraPicker.availableModes = [.camera]
                self.present(self.cameraPicker, animated: true, completion: nil)
            }
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)

        alertContoller.addAction(fileAction)
        alertContoller.addAction(photosAction)
        alertContoller.addAction(cameraAction)
        alertContoller.addAction(cancelAction)
        self.present(alertContoller, animated: true, completion: nil)

    }

    @objc func callAction(sender: UIButton) {

        self.viewModel.insertMessage(customerId: customerId, visitorId: visitorId, message: "", attachments: nil, conversationId: conversationId, contentType: "videoCallRequest")
        textField.text = ""
    }

    func startUplaoder(image: UIImage, filePath: URL? = nil) {


        if filePath == nil {
            let uploader = UploadView(image: image)
            uploader.tag = 55
            uploader.delegate = self
            self.view.addSubview(uploader)
        } else {
            let uploader = UploadView(image: UIImage(), filePath: filePath!)
            uploader.tag = 55
            uploader.delegate = self
            self.view.addSubview(uploader)
        }
    }





    @objc func animateHeader() {

        if isCollapsed {

            UIView.animate(withDuration: 0.3, animations: {
                self.collectionView.snp.remakeConstraints({ (make) in
                    make.left.right.equalToSuperview()
                    make.bottom.equalTo(self.textField.snp.top)
                    make.top.equalToSuperview().offset(self.headerFullHeight)
                })

                self.view.layoutIfNeeded()

            })

            isCollapsed = false
            self.view.endEditing(true)
        } else {
            headerFullHeight = messengerHeader.frame.height
            UIView.animate(withDuration: 0.3, animations: {
                self.collectionView.snp.remakeConstraints({ (make) in
                    make.left.right.equalToSuperview()
                    make.bottom.equalTo(self.textField.snp.top)
                    make.top.equalToSuperview().offset(64)
                })

                self.view.layoutIfNeeded()

            })
            isCollapsed = true

        }

        self.messengerHeader.animateHeader()
        self.messengerHeader.isCollapsed = isCollapsed
    }

    @objc func keyboardHandler(notification: NSNotification) {
        let info = notification.userInfo!

        var keyboardFrame: CGRect
        if let keyBoardInfo = info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            keyboardFrame = keyBoardInfo.cgRectValue
        } else {
            return
        }


        if notification.name == UIResponder.keyboardWillShowNotification {

            self.messengerHeader.animateHeader()

            UIView.animate(withDuration: 0.3) {
                self.textField.snp.remakeConstraints { (make) in
                    make.bottom.equalToSuperview().offset(-keyboardFrame.size.height)
                    make.height.equalTo(40)
                    make.left.right.equalToSuperview()
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
                self.textField.snp.remakeConstraints { (make) in
                    make.bottom.equalTo(self.view.safeAreaLayoutGuide)
                    make.height.equalTo(40)
                    make.left.right.equalToSuperview()
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

extension MessengerView: AttachmentUploadDelegate {
    func attachmentUploaded(file: AttachmentInput) {
        DispatchQueue.main.async {
            if let uploadView = self.view.viewWithTag(55) {
                uploadView.removeFromSuperview()
            }

            self.viewModel.insertMessage(customerId: customerId, visitorId: visitorId, message: nil, attachments: [file], conversationId: self.conversationId)
            self.textField.text = ""
        }

    }

    func uploadFailed(errorMessage: String) {
        DispatchQueue.main.async {
            if let uploadView = self.view.viewWithTag(55) {
                uploadView.removeFromSuperview()
            }
            let alertController = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "close", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
}


