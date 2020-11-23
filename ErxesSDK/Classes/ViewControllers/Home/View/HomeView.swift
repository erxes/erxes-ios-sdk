//
//  HomeView.swift
//  Erxes iOS SDK
//
//  Created by soyombo bat-erdene on 4/30/20.
//  Copyright © 2020 Soyombo bat-erdene. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import Fusuma
import CoreServices
import MobileCoreServices

class HomeView: AbstractViewController {

    // OUTLETS HERE

    var searchField: UITextField = {
        let searchField = UITextField(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH - 20, height: 40))
        let padding = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 40))
        searchField.leftViewMode = .always
        searchField.leftView = padding
        searchField.placeholder = "Search".localized(lang)
        let icon = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        icon.contentMode = .center
        icon.image = UIImage.erxes(with: .magnifyingglass, textColor: .lightGray, size: CGSize(width: 22, height: 22), backgroundColor: .clear)
        searchField.rightViewMode = .always
        searchField.rightView = icon
        searchField.borderStyle = .roundedRect
        searchField.addTarget(self, action: #selector(searchAction(sender:)), for: .editingChanged)
        searchField.addTarget(self, action: #selector(beginSearchAnimation(sender:)), for: .editingDidBegin)
        searchField.addTarget(self, action: #selector(endSearchAnimation(sender:)), for: .editingDidEnd)
        return searchField
    }()

    let headerView = MainHeaderView()
    var scrollView: UIScrollView!
    var stackView: UIStackView!
    var scrollInsetHeight: CGFloat = 0.0
    lazy var picker = FusumaViewController()
    lazy var cameraPicker = FusumaViewController()

    lazy var knowledgeBaseTableView: UITableView = {
        let tableView = UITableView.init(frame: .zero)

        tableView.tableFooterView = UIView()

        tableView.clipsToBounds = true
        tableView.register(KnowledBaseTopicCell.self, forCellReuseIdentifier: "KnowledBaseTopicCell")
        tableView.register(KBCategoryCell.self, forCellReuseIdentifier: "KBCategoryCell")
        tableView.separatorColor = .clear
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.white
        tableView.alpha = 0
        tableView.estimatedRowHeight = 70
        tableView.rowHeight = UITableView.automaticDimension
        return tableView
    }()

    let segmentContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.shadowColor = UIColor.lightGray.cgColor
        view.layer.shadowOffset = CGSize(width: 3, height: 3)
        view.layer.shadowOpacity = 0.7
        view.layer.shadowRadius = 4.0
        return view
    }()

    var segmentedControl: SegmentedControl = {
        let control = SegmentedControl()


        control.selectorTextColor = UIColor(hexString: uiOptions?.color ?? defaultColorCode)!
        control.setButtonTitles(buttonTitles: ["Support".localized(lang).uppercased(), "Faq".localized(lang).uppercased()])
        control.selectorViewColor = UIColor(hexString: uiOptions?.color ?? defaultColorCode)!


        return control
    }()

    var conversationsView = ConversationsView()
    var formView = FormVIew()

    // VARIABLES HERE
    var viewModel = HomeViewModel()
    var supporters = [UserModel]()
    var formDetail: FormModel?
    var formId: String?
    var knowledgeBase: KnowledgeBaseTopicModel = KnowledgeBaseTopicModel() {
        didSet {

            self.knowledgeBaseTableView.reloadData()
        }
    }

    var searchArray = [KbArticleModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        topOffset = 60
        self.view.backgroundColor = .clear
        self.setupViewModel()

        if ((messengerData?.knowledgeBaseTopicId) != nil) && messengerData?.knowledgeBaseTopicId?.count != 0 {
            segmentContainer.isHidden = false
            self.viewModel.getKnowLedgeBase(id: (messengerData?.knowledgeBaseTopicId)!)
        } else {
            segmentContainer.isHidden = true
        }

        self.containerView.addSubview(headerView)
        self.containerView.addSubview(segmentContainer)
        self.segmentContainer.addSubview(segmentedControl)
        segmentedControl.delegate = self
        scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.delegate = self
        containerView.addSubview(scrollView)
        containerView.addSubview(knowledgeBaseTableView)
        stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.spacing = 16.0
        scrollView.addSubview(stackView)

        stackView.addArrangedSubview(conversationsView)

        self.viewModel.getSupporters()


        if (formCode != nil) && formCode.count != 0 {
            stackView.addArrangedSubview(formView)
            self.viewModel.connectLead()
        }

        if let websiteApps = messengerData?.websiteApps {
            for (i, websiteApp) in websiteApps.enumerated() {
                guard let data = websiteApp else { continue }
                let websiteVIew = WebsiteAppView()
                stackView.insertArrangedSubview(websiteVIew, at: stackView.arrangedSubviews.count)
                websiteVIew.setData(data: data)
                websiteVIew.tag = i
                websiteVIew.didTapHandler = {
                    let controller = EmbedWebViewController()
                    controller.data = data
                    self.navigationController?.pushViewController(controller, animated: true)
                }

                websiteVIew.snp.makeConstraints { (make) in
                    make.left.right.equalToSuperview().inset(8)
                    make.width.equalTo(SCREEN_WIDTH - 16)
                }
            }

        }


        picker.delegate = self
        cameraPicker.delegate = self

        fusumaTintColor = UIColor(hexString: (uiOptions?.color) ?? defaultColorCode)!
        fusumaTitleFont = UIFont.boldSystemFont(ofSize: 15)

        picker.allowMultipleSelection = false
        cameraPicker.allowMultipleSelection = false

        headerView.moreButtonHandler = {
            self.moreAction(sender: self.headerView.rightButton)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewModel.getConversations()
        self.containerView.bringSubviewToFront(segmentContainer)
        self.scrollView.setContentOffset(CGPoint(x: 0, y: -scrollInsetHeight), animated: true)
        if customerId != nil {
            self.viewModel.subscribe(customerId: customerId)
        }

        if knowledgeBaseTableView.alpha == 0 {
            segmentedControl.setIndex(index: 0)
        }else{
            segmentedControl.setIndex(index: 1)
        }

    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.viewModel.cancelSubscription()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        headerView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
        }


        segmentContainer.snp.makeConstraints { (make) in
            make.top.equalTo(headerView.snp.bottom)
            make.left.right.equalToSuperview()
            if ((messengerData?.knowledgeBaseTopicId) != nil) && messengerData?.knowledgeBaseTopicId?.count != 0 {
                make.height.equalTo(40)
            } else {
                make.height.equalTo(0)
            }
        }

        segmentedControl.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }

        scrollView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalToSuperview().offset(0)
        }

        stackView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }

        conversationsView.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview().inset(8)
            make.width.equalTo(SCREEN_WIDTH - 16)

        }

        if stackView.arrangedSubviews.contains(formView) {
            formView.snp.makeConstraints { (make) in
                make.left.right.equalToSuperview().inset(8)
                make.width.equalTo(SCREEN_WIDTH - 16)
            }
        }

        scrollInsetHeight = CGFloat(headerView.frame.height + segmentContainer.frame.height + 10)
        scrollView.contentInset = UIEdgeInsets(top: scrollInsetHeight, left: 0, bottom: 0, right: 0)
        scrollView.contentSize = CGSize(width: stackView.frame.width, height: stackView.frame.height)

        knowledgeBaseTableView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(segmentContainer.snp.bottom).offset(2)
        }

    }

    fileprivate func setupViewModel() {

        self.viewModel.showAlertClosure = {
            let alert = self.viewModel.alertMessage ?? ""
           
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

        self.viewModel.didGetSupporters = { users in
            self.supporters = users
            self.headerView.setSupporters(supporters: users)
        }

        self.viewModel.didGetConversations = { conversations in
            self.conversationsView.setConversations(conversations: conversations)
            self.conversationsView.didTapHandler = {
                self.navigateMessenger(nil, nil)
            }
            self.conversationsView.didSelectRowHandler = { row in
                let supporter = conversations[row].participatedUsers?.compactMap({ $0?.fragments.userDetailModel }).last
                self.navigateMessenger(conversations[row]._id, supporter)
            }
        }

        self.viewModel.didGetLead = { data in
            guard let formid = data.form?._id else { return }
            self.formId = formid
            if let leadDataJson = data.integration?.leadData {
                do {
                    leadData = try LeadData(from: leadDataJson) { decoder in
                        decoder.keyDecodingStrategy = .convertFromSnakeCase
                    }
                } catch {
                    print("Error: \(error)")
                }
            }

            self.viewModel.formDetail(id: formid)


        }

        self.viewModel.didGetFormDetail = { data in
            self.formView.titleLabel.text = leadData?.callout?.title
            self.formView.descriptionLabel.text = leadData?.callout?.body
            self.formView.thankMessage = leadData?.thankContent! ?? "Thank you"
            self.formView.button.setTitle(leadData?.callout?.buttonText, for: .normal)
            self.formView.button.addTarget(self, action: #selector(self.openForm(sender:)), for: .touchUpInside)
            self.formView.didTapOpenFile = {
                self.view.endEditing(true)
                let alertContoller = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
                let fileAction = UIAlertAction(title: "Open file browser", style: .default) { (action) in
                    alertContoller.dismiss(animated: true) {

//                        let fileBrowser = UIDocumentPickerViewController(documentTypes: [kUTTypePDF as String], in: .open)
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
            self.formDetail = data
        }

        self.viewModel.didGetFormResponse = { data in
            if data.status == "error" {
                guard let errors = data.errors?.compactMap({ $0?.fragments.fieldError }) else { return }
                self.formView.errors = errors
            } else {
                self.formView.showThankContent()
            }
        }

        self.viewModel.didSetUnreadCount = { data in
            self.conversationsView.unreadIds = data
            self.conversationsView.tableView.reloadData()

        }

        self.viewModel.didReceiveAdminMessage = { data in
            self.viewModel.getConversations()
        }

        self.viewModel.didReceiveKnowledgeBase = { data in
            self.knowledgeBase = data
        }
    }

    func navigateMessenger(_ conversationId: String?, _ supporter: UserDetailModel?) {
        let controller = MessengerView()
        controller.conversationId = conversationId
        if (supporter != nil) {
            controller.participatedUser = supporter
        }else{
            controller.supporters = self.supporters
        }
        
        self.navigationController?.pushViewController(controller, animated: true)
    }

    @objc func openForm(sender: UIButton) {
        if !sender.isSelected {
            sender.isSelected = true
            self.formView.setData(form: self.formDetail!)
            self.view.layoutSubviews()
        } else {
            self.viewModel.sendForm(formId: self.formId ?? "", submissions: self.formView.submissions)
        }

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



}



extension HomeView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
    
        let y = abs(scrollView.contentOffset.y)
        if (y < scrollInsetHeight || scrollView.contentOffset.y >= scrollInsetHeight) {
            self.containerView.sendSubviewToBack(segmentContainer)
            self.containerView.sendSubviewToBack(headerView)
        } else {
            self.containerView.bringSubviewToFront(segmentContainer)
            self.containerView.bringSubviewToFront(headerView)
        }
    }
}


extension HomeView: FusumaDelegate {
    func fusumaMultipleImageSelected(_ images: [UIImage], source: FusumaMode) {

    }

    func fusumaImageSelected(_ image: UIImage, source: FusumaMode) {
        self.startUplaoder(image: image)
    }

    func fusumaVideoCompleted(withFileURL fileURL: URL) {

    }

    func fusumaCameraRollUnauthorized() {

    }


}


extension HomeView: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        controller.dismiss(animated: true) {


            self.startUplaoder(image: UIImage(), filePath: url)
        }
    }
}


extension HomeView: AttachmentUploadDelegate {
    func uploadFailed(errorMessage: String) {

    }

    func attachmentUploaded(file: AttachmentInput) {
        if let uploadView = self.view.viewWithTag(55) {
            uploadView.removeFromSuperview()
        }

        self.formView.fileUploadFinished(file: file)
    }
}


extension HomeView: SegmentedControlDelegate {
    func changeToIndex(index: Int) {
        if index == 1 {


            UIView.animate(withDuration: 0.3) {
                self.knowledgeBaseTableView.alpha = 1
                self.scrollView.alpha = 0
            }
        } else if index == 0 {

            UIView.animate(withDuration: 0.3) {
                self.knowledgeBaseTableView.alpha = 0
                self.scrollView.alpha = 1
            }
        }
    }
}


extension HomeView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {


        if searchField.text?.count == 0 {
            if let count = self.knowledgeBase.categories?.count {
                return count
            } else {
                return 0
            }
        } else {
            return searchArray.count
        }





    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if searchField.text!.isEmpty {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "KnowledBaseTopicCell", for: indexPath) as? KnowledBaseTopicCell {
                if let model = self.knowledgeBase.categories![indexPath.row]?.fragments.knowledgeBaseCategoryModel {
                    cell.setup(model: model)
                    cell.layoutIfNeeded()
                }
                return cell
            }
        } else {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "KBCategoryCell", for: indexPath) as? KBCategoryCell {
                let model = self.searchArray[indexPath.row] 
                    cell.setup(model: model)
                    cell.layoutIfNeeded()
                
                return cell
            }
        }





        return UITableViewCell()
    }



    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {


        if let model = self.knowledgeBase.categories![indexPath.row]?.fragments.knowledgeBaseCategoryModel {
            let controller = KBCategoryView()
            controller.categoryId = model._id!
            controller.mainTitle = model.title
            controller.subTitle = model.description
            self.navigationController?.pushViewController(controller, animated: true)
        }

    }


    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 60))
        headerView.backgroundColor = UIColor.init(hexString: "#f6f4f8")
        headerView.addSubview(searchField)
        searchField.center = headerView.center
        return headerView

        return UIView()
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {

        return 60


    }



    @objc func searchAction(sender: UITextField) {
        self.searchArray.removeAll()
        if sender.text?.count != 0 {
            if let search = sender.text {
                self.searchArray = self.viewModel.allKBArticles.filter({ ($0.content?.contains(search))! || ($0.title?.contains(search))! || ($0.summary?.contains(search))! })

            }

        }
        self.knowledgeBaseTableView.reloadData()
    }

    @objc func beginSearchAnimation(sender: UITextField) {
        self.containerView.bringSubviewToFront(knowledgeBaseTableView)
        UIView.animate(withDuration: 0.3) {
//            self.knowledgeBaseTableView.snp.removeConstraints()
            self.knowledgeBaseTableView.snp.remakeConstraints { (make) in
                make.left.right.bottom.equalToSuperview()
                make.top.equalToSuperview()
            }
            self.knowledgeBaseTableView.layoutIfNeeded()
        }
    }

    @objc func endSearchAnimation(sender: UITextField) {
        UIView.animate(withDuration: 0.3) {
//            self.knowledgeBaseTableView.snp.removeConstraints()
            self.knowledgeBaseTableView.snp.remakeConstraints { (make) in
                make.left.right.bottom.equalToSuperview()
                make.top.equalTo(self.segmentContainer.snp.bottom).offset(2)
            }
            self.knowledgeBaseTableView.layoutIfNeeded()
        }
    }
}
