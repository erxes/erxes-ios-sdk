//  
//  KBCategoryView.swift
//  erxesiosdk
//
//  Created by Soyombo bat-erdene on 8/28/19.
//  Copyright © 2019 Soyombo bat-erdene. All rights reserved.
//

import UIKit

class KBCategoryView: AbstractViewController {

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
    

    // VARIABLES HERE
    var articles = [KbArticleModel?](){
        didSet{
            tableView.reloadData()
        }
    }
    
    var mainTitle: String?
    var subTitle: String?
    var categoryId = String()
    var searchArray = [KbArticleModel]()
  
    
   let header = NormalHeaderView()
    
     var tableView: UITableView = {
        let tableView = UITableView()
       
        tableView.register(KBCategoryCell.self, forCellReuseIdentifier: "KBCategoryCell")
        tableView.tableFooterView = UIView()
        
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        return tableView
    }()
    // VARIABLES HERE
    
    
  
    
   
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
     
        header.snp.makeConstraints { (make) in
            make.top.equalTo(containerView)
            make.left.right.equalToSuperview()
            make.height.equalTo(64)
        }
        
   
        
        tableView.snp.makeConstraints({ (make) in
            make.bottom.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(64)
        })
        
        containerView.roundCorners(corners: [.topLeft, .topRight], radius: 8)
        
    }
    
    
    var viewModel = KBCategoryViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        topOffset = 60
        self.prepareViews()
        self.setupViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.viewModel.knowledgeBaseCategoriesDetail(categoryId: self.categoryId)
    }
    
    func prepareViews(){
        self.view.backgroundColor = .clear
        
        self.containerView.addSubview(tableView)
        

        self.searchField.delegate = self
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.view.addSubview(header)
        header.setTitles(title: mainTitle, subTitle: subTitle)
        header.backButtonHandler = {
            self.navigationController?.popViewController(animated: true)
        }
        
        header.moreButtonHandler = {
            self.moreAction(sender: self.header.moreButton)
        }
    }
    
    fileprivate func setupViewModel() {

        self.viewModel.showAlertClosure = {
            let alert = self.viewModel.alertMessage ?? ""
            print(alert)
        }
        
        self.viewModel.updateLoadingStatus = {
            self.tableView.activityIndicatorView.center = self.tableView.center
            if self.viewModel.isLoading {
                self.tableView.activityIndicatorView.startAnimating()
            } else {
                self.tableView.activityIndicatorView.stopAnimating()
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
   
            if let _articles = data.articles?.map({$0?.fragments.kbArticleModel}) {
                self.articles = _articles
            }
            
        }

    }
    
    @objc func backAction(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func searchAction(sender:UITextField){
        self.searchArray.removeAll()
        if sender.text?.count != 0 {
            if let search = sender.text {
                self.searchArray = self.articles.filter({($0?.content?.contains(search))! || ($0?.title?.contains(search))! || ($0?.summary?.contains(search))!}) as! [KbArticleModel]
                
            }
            
        }
        self.tableView.reloadData()
    }
    
}


extension KBCategoryView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searchField.text?.count == 0 {
            return self.articles.count
        }else {
            return self.searchArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "KBCategoryCell", for: indexPath) as? KBCategoryCell {
            if searchField.text?.count == 0 {
                if let model = self.articles[indexPath.row] {
                    
                    cell.setup(model: model)
                    cell.layoutIfNeeded()
                }
                return cell
            }else {
                if let model:KbArticleModel = self.searchArray[indexPath.row] {
                    
                    cell.setup(model: model)
                    cell.layoutIfNeeded()
                }
                return cell
            }
            
        }
        return UITableViewCell()
    }
    
 
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let model = self.articles[indexPath.row] {
            
            let controller = KBDetailViewController()
            controller.model = model
            self.navigationController?.pushViewController(controller, animated: true)
        }

    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 60))
        headerView.backgroundColor = UIColor.init(hexString: "#f6f4f8")
        headerView.addSubview(searchField)
        searchField.center = headerView.center
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
      return 60
        
    }
}
extension KBCategoryView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}
