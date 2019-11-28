//
//  RegisterView.swift
//  erxesiosdk
//
//  Created by Soyombo bat-erdene on 7/17/19.
//  Copyright © 2019 Soyombo bat-erdene. All rights reserved.
//

import UIKit





class HomeView: UIViewController {

    // OUTLETS HERE
    var searchField: UITextField = {
        let searchField = UITextField(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH-20, height: 40))
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
        return searchField
    }()
    lazy var backdropView: UIView = {
        let bdView = UIView(frame: self.view.bounds)
        bdView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        return bdView
    }()
    
    var containerView: UIView = {
        let container = UIView()
        container.backgroundColor = .white
//        container.clipsToBounds = true
        return container
    }()

    var headerView: HomeHeader = {
        let header = HomeHeader()
        return header
    }()

    var conversationsHeader: ConversationsHeader = {
        let header = ConversationsHeader()

        header.clipsToBounds = true
        
        return header
    }()
    
    var tableContainer: RoundShadowView = {
       let view = RoundShadowView()
        view.backgroundColor = UIColor.white
        return view
    }()
    
 

     var conversationsTableView: UITableView = {
        let tableView = UITableView.init(frame: .zero, style: .grouped)
     
        tableView.tableFooterView = UIView()
        
        tableView.layer.cornerRadius = 8.0
        tableView.layer.borderWidth = 0.1
        tableView.layer.borderColor = UIColor.gray.cgColor
        tableView.clipsToBounds = true
        tableView.register(ConversationCell.self, forCellReuseIdentifier: "ConversationCell")
        tableView.register(ConversationUnreadCell.self, forCellReuseIdentifier: "ConversationUnreadCell")
        tableView.separatorColor = .clear
       
        tableView.backgroundColor = UIColor.clear
        return tableView
    }()
    
    lazy var knowledgeBaseTableView: UITableView = {
        let tableView = UITableView.init(frame: .zero, style: .grouped)
  
        tableView.tableFooterView = UIView()
 
        tableView.clipsToBounds = true
        tableView.register(KnowledBaseTopicCell.self, forCellReuseIdentifier: "KnowledBaseTopicCell")
        tableView.register(KBCategoryCell.self, forCellReuseIdentifier: "KBCategoryCell")
        tableView.separatorColor = .clear
     
        tableView.backgroundColor = UIColor.white
        tableView.isHidden = true
        tableView.estimatedRowHeight = 70
        tableView.rowHeight = UITableView.automaticDimension
        return tableView
    }()

    var segmentedControl: SegmentedControl = {
        let control = SegmentedControl()
        
        control.isHidden = true
        
       
        control.setButtonTitles(buttonTitles: ["Support".localized(lang).uppercased(), "Faq".localized(lang).uppercased()])
       
        return control
    }()

    // VARIABLES HERE
    var isResigningCustomer = false
    var searchArray = [KbArticleModel]()
    var viewModel = HomeViewModel()
    var data:Scalar_JSON! = nil

    var conversations:[ConversationModel] = [ConversationModel]() {
        didSet{
        
            self.conversationsTableView.reloadData()
        }
    }
    
    var knowledgeBase: KnowledgeBaseTopicModel = KnowledgeBaseTopicModel() {
        didSet{
            self.knowledgeBaseTableView.reloadData()
        }
    }
    
    
    
    let menuHeight = UIScreen.main.bounds.height-80
    var isPresenting = false


    init() {
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .custom
        transitioningDelegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.prepareViews()
        self.setupViewModel()
        if !requireAuth || isResigningCustomer{
            if isResigningCustomer {
                self.viewModel.messengerConnect(Email: customerEmail, Phone: customerPhoneNumber, CachedCustomerId: erxesCustomerId,data: self.data)
            }else {
                self.viewModel.messengerConnect(data: self.data)
            }
        }
        
    }

    override func viewWillAppear(_ animated: Bool) {
        self.view.backgroundColor = .clear

        if (erxesIntegrationId != nil) && (erxesCustomerId != nil){
            
            self.viewModel.getConversations(integrationId: erxesIntegrationId, customerId: erxesCustomerId)
            self.viewModel.subscribe(customerId: erxesCustomerId)
        }
//        if knowledgeBaseTopicId.count != 0 {
//            self.viewModel.getKnowledgeBaseTopic(topicId: knowledgeBaseTopicId)
//        }
    }

    func prepareViews() {

        self.modalPresentationStyle = .custom
        self.view.backgroundColor = .clear
//        self.view.addSubview(backdropView)
        self.view.addSubview(containerView)
        containerView.addSubview(headerView)
        containerView.addSubview(tableContainer)
        containerView.addSubview(segmentedControl)
        segmentedControl.delegate = self
        segmentedControl.clipsToBounds = true
        tableContainer.addSubview(conversationsTableView)
        conversationsTableView.dataSource  = self
        conversationsTableView.delegate = self
        containerView.addSubview(knowledgeBaseTableView)
        knowledgeBaseTableView.delegate = self
        knowledgeBaseTableView.dataSource = self
        knowledgeBaseTableView.contentInset = .zero
        
        if #available(iOS 11.0, *) {
            knowledgeBaseTableView.contentInsetAdjustmentBehavior = .automatic
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        knowledgeBaseTableView.contentInset = UIEdgeInsets(top: -30, left: 0, bottom: 0, right: 0)
        searchField.delegate = self
        self.headerView.setSupperters(supporters: supporters)
        self.headerView.setLinks(links: socialLinks)
        self.headerView.titleLabel.text = welcomeTitle
        self.headerView.subTitleLabel.text = welcomeDescription
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
 
        containerView.snp.makeConstraints({ (make) in
            make.bottom.left.right.equalToSuperview()
            make.top.equalTo(topLayoutGuide.snp.bottom).offset(10)
        })

        headerView.snp.makeConstraints({ (make) in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(200)
        })
        
        segmentedControl.snp.makeConstraints({ (make) in
            make.top.equalTo(self.headerView.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(40)
        })
        
        if hasKnowledgeBase {
            
            tableContainer.snp.makeConstraints { (make) in
                make.left.equalToSuperview().offset(8)
                make.right.equalToSuperview().offset(-8)
                make.bottom.equalToSuperview()
                make.top.equalTo(segmentedControl.snp.bottom).offset(10)
            }
            segmentedControl.isHidden = false
        }else {
            
            tableContainer.snp.makeConstraints { (make) in
                make.left.equalToSuperview().offset(8)
                make.right.equalToSuperview().offset(-8)
                make.bottom.equalToSuperview()
                make.top.equalTo(headerView.snp.bottom).offset(10)
            }
        }
        
        conversationsTableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        
        
        knowledgeBaseTableView.snp.makeConstraints { (make ) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(segmentedControl.snp.bottom).offset(2)
        }
        segmentedControl.backgroundColor = .white
        segmentedControl.dropShadow(color: .gray, opacity: 1, offSet: CGSize(width: -1, height: 1), radius: 3, scale: true)
        containerView.roundCorners(corners: [.topLeft, .topRight], radius: 8)
        headerView.roundCorners(corners: [.topLeft,.topRight], radius: 8)
    }

    fileprivate func setupViewModel() {

        self.viewModel.showAlertClosure = {
            let alert = self.viewModel.alertMessage ?? ""
            print(alert)
        }

        self.viewModel.updateLoadingStatus = {
            self.conversationsTableView.activityIndicatorView.center = self.conversationsTableView.center
            if self.viewModel.isLoading {
                self.conversationsTableView.activityIndicatorView.startAnimating()
            } else {
                self.conversationsTableView.activityIndicatorView.stopAnimating()
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

        self.viewModel.didGetData = { data in
          
            self.headerView.setLinks(links: socialLinks)
            self.headerView.titleLabel.text = welcomeTitle
            self.headerView.subTitleLabel.text = welcomeDescription
            self.headerView.layoutSubviews()
            
            self.segmentedControl.selectorViewColor = themeColor!
            self.segmentedControl.selectorTextColor = themeColor!
            self.segmentedControl.setNeedsDisplay()
            
        }

    
        
        
        self.viewModel.didGetConversations = { data in
            self.conversations = data
        }
        
        self.viewModel.didReceiveAdminMessage = { data in
            if let index = self.conversations.firstIndex(where: {$0.id == data.conversationId}) {
                var conversation = self.conversations[index]
                conversation.content = data.content
                self.viewModel.unreadIds.append(conversation.id)
                self.conversations[index] = conversation
            }
        }
        
        self.viewModel.didGetKnowledgeBase = { data in
            self.knowledgeBase = data
        }
        
        self.viewModel.didGetKnowledgeBaseTopicId = { topicId in
            self.segmentedControl.isHidden = false
            self.tableContainer.snp.remakeConstraints { (make) in
                make.left.equalToSuperview().offset(8)
                make.right.equalToSuperview().offset(-8)
                make.bottom.equalToSuperview()
                make.top.equalTo(self.segmentedControl.snp.bottom).offset(10)
            }
            self.viewModel.getKnowledgeBaseTopic(topicId: topicId)
           
        }
        
        self.viewModel.didSetUnreadCount = {
            self.conversationsTableView.reloadData()
        }
    }

    @objc func newConversation(){
  
        let controller = ChatView()
        controller.mainTitle = "title"
        controller.subTitle = "subtitle"
        
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
}


extension UIView {
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        DispatchQueue.main.async {
            let path = UIBezierPath(roundedRect: self.bounds,
                                    byRoundingCorners: corners,
                                    cornerRadii: CGSize(width: radius, height: radius))
            let maskLayer = CAShapeLayer()
            maskLayer.frame = self.bounds
            maskLayer.path = path.cgPath
            self.layer.mask = maskLayer
        }
    }
}


extension HomeView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.conversationsTableView {
            if section == 0 {
                return conversations.count
            }else {
                return 0
            }
        }else {
            
            if searchField.text?.count == 0 {
                if let count = self.knowledgeBase.categories?.count {
                    return count
                }else {
                    return 0
                }
            }else {
                return searchArray.count
            }
            
           
            
        }
      
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.conversationsTableView {
            if indexPath.section == 0 {
                
                
                let model = conversations[indexPath.row]
                
                
                if self.viewModel.unreadIds.contains(model.id) {
                    
                    if let unreadCell = tableView.dequeueReusableCell(withIdentifier: "ConversationUnreadCell", for: indexPath) as? ConversationUnreadCell {
                        unreadCell.setup(viewModel: model)
                        unreadCell.layoutIfNeeded()
                        return unreadCell
                    }
                }else {
                    
                    if let cell = tableView.dequeueReusableCell(withIdentifier: "ConversationCell", for: indexPath) as? ConversationCell {
                        cell.setup(viewModel: model)
                        cell.layoutIfNeeded()
                        
                        return cell
                    }
                }

                
                
                
                
            }
        }else {
            if searchField.text!.isEmpty {
                if let cell = tableView.dequeueReusableCell(withIdentifier: "KnowledBaseTopicCell", for: indexPath) as? KnowledBaseTopicCell {
                    if let model = self.knowledgeBase.categories![indexPath.row]?.fragments.knowledgeBaseCategoryModel {
                        cell.setup(model: model)
                        cell.layoutIfNeeded()
                    }
                    return cell
                }
            }else {
                if let cell = tableView.dequeueReusableCell(withIdentifier: "KBCategoryCell", for: indexPath) as? KBCategoryCell {
                    if let model:KbArticleModel = self.searchArray[indexPath.row] {
                        cell.setup(model: model)
                        cell.layoutIfNeeded()
                    }
                    return cell
                }
            }
          
        }

   

        return UITableViewCell()
    }

    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        let cornerRadius = 8
        var corners: UIRectCorner = []
    
        
        if indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1
        {
            corners.update(with: .bottomLeft)
            corners.update(with: .bottomRight)
            cell.dropShadow(color: .gray, opacity: 1, offSet: CGSize(width: 1, height: 1), radius: 3, scale: true)
        }
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = UIBezierPath(roundedRect: cell.bounds,
                                      byRoundingCorners: corners,
                                      cornerRadii: CGSize(width: cornerRadius, height: cornerRadius)).cgPath
        cell.layer.mask = maskLayer
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.conversationsTableView {
            let conversation = self.conversations[indexPath.row]
            let controller = ChatView()
            controller.conversationId = conversation.id
            controller.mainTitle = "title"
            controller.subTitle = "subtitle"
            
            self.navigationController?.pushViewController(controller, animated: true)
        }else {
           
            if let model = self.knowledgeBase.categories![indexPath.row]?.fragments.knowledgeBaseCategoryModel {
                let controller = KBCategoryView()
                controller.categoryId = model.id!
                controller.mainTitle = model.title
                controller.subTitle = model.description
                self.navigationController?.pushViewController(controller, animated: true)
            }
        }
    }
    

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if tableView == self.conversationsTableView {
            if section == 0 {
                let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(newConversation))
                
                tapRecognizer.numberOfTapsRequired = 1
                tapRecognizer.numberOfTouchesRequired = 1
                conversationsHeader.addGestureRecognizer(tapRecognizer)
            }
            return conversationsHeader
        }else {
            let headerView = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 60))
            headerView.backgroundColor = UIColor.init(hexString: "#f6f4f8")
            headerView.addSubview(searchField)
            searchField.center = headerView.center
            return headerView
        }
      return UIView()
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView == self.conversationsTableView {
            return 110
        }else {
            return 60
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 70
        }else {
            return 0
        }
    }

    @objc func searchAction(sender:UITextField){
        self.searchArray.removeAll()
        if sender.text?.count != 0 {
            if let search = sender.text {
                self.searchArray = self.viewModel.allKBArticles.filter({($0.content?.contains(search))! || ($0.title?.contains(search))! || ($0.summary?.contains(search))!})
               
            }
            
        }
        self.knowledgeBaseTableView.reloadData()
    }

}

extension HomeView: UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
        guard let toVC = toViewController else { return }
        isPresenting = !isPresenting
        
        if isPresenting == true {
            containerView.addSubview(toVC.view)
            
            self.containerView.frame.origin.y += menuHeight
            backdropView.alpha = 0
            
            UIView.animate(withDuration: 0.4, delay: 0, options: [.curveEaseOut], animations: {
                self.containerView.frame.origin.y -= self.menuHeight
                self.backdropView.alpha = 1
            }, completion: { (finished) in
                transitionContext.completeTransition(true)
            })
        } else {
            UIView.animate(withDuration: 0.4, delay: 0, options: [.curveEaseOut], animations: {
                self.containerView.frame.origin.y += self.menuHeight
                self.backdropView.alpha = 0
            }, completion: { (finished) in
                transitionContext.completeTransition(true)
            })
        }
    }
}


extension HomeView: SegmentedControlDelegate {
    func changeToIndex(index: Int) {
        if index == 1 {
            
            self.knowledgeBaseTableView.isHidden = false
            self.tableContainer.isHidden = true
            
        }else if index == 0 {
            self.tableContainer.isHidden = false
            self.knowledgeBaseTableView.isHidden = true
        }
    }
}

extension HomeView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}


