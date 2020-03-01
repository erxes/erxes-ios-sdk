//
//  KBDetailViewController.swift
//  erxesiosdk
//
//  Created by Soyombo bat-erdene on 8/29/19.
//  Copyright © 2019 Soyombo bat-erdene. All rights reserved.
//

import UIKit

class KBDetailViewController: AbstractViewController {

    var model: KbArticleModel = KbArticleModel() {
        didSet{
            
            self.tableView.reloadData()
//            self.headerView.titleLabel.text = model.title
            
            self.headerView.layoutSubviews()
        }
    }
     
    var backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage.erxes(with: .leftarrow3, textColor: .white,size: CGSize(width: 27, height: 27)), for: .normal)
        button.addTarget(self, action: #selector(backAction(sender:)), for: .touchUpInside)
        return button
    }()
    // VARIABLES HERE
    
    var titleLabel: UILabel = {
       let label = UILabel()
        return label
    }()
    
    var dateLabel: UILabel = {
       let label = UILabel()
        return label
    }()
    
    var subtitleLabel: UILabel = {
       let label = UILabel()
        return label
    }()
    
    var contentLabel: UILabel = {
       let label = UILabel()
        return label
    }()
    



    
    var headerView: ChatHeader = {
        let header = ChatHeader()
        return header
    }()
    
    lazy var tableView: UITableView = {
       let tableview = UITableView()
        self.containerView.addSubview(tableview)
        tableview.delegate = self
        tableview.dataSource = self
        tableview.snp.makeConstraints({ (make) in
            make.left.bottom.right.equalToSuperview()
            make.top.equalToSuperview().offset(64)
        })
        tableview.tableFooterView = UIView()
        tableview.estimatedRowHeight = 100
        tableview.rowHeight = UITableView.automaticDimension
        tableview.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableview.separatorStyle = .none
        tableview.allowsSelection = false
        return tableview
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topOffset = 80
        print("detail load")
        prepareViews()
        
    }
    
    func prepareViews(){
        topOffset = 80
        self.view.backgroundColor = .clear
        
        containerView.addSubview(headerView)
        headerView.addSubview(backButton)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
      
        
      
        
        headerView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(64)
        }
        
        backButton.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(8)
            make.width.height.equalTo(40)
            make.top.equalToSuperview().offset(12)
        }
        containerView.roundCorners(corners: [.topLeft, .topRight], radius: 8)
        headerView.roundCorners(corners: [.topLeft,.topRight], radius: 8)
    }
    
    @objc func backAction(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

}


extension KBDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.value1, reuseIdentifier: "cell")
        switch indexPath.row {
        case 0:
            cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 20)
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.lineBreakMode = .byWordWrapping
            cell.textLabel!.text = self.model.title
        case 1:
            cell.textLabel?.font = UIFont.systemFont(ofSize: 15)
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.lineBreakMode = .byWordWrapping
            cell.textLabel?.textColor = .lightGray
            cell.textLabel!.text = "Created ".localized(lang) + ": " + Utils.fullDateString(value: model.createdDate!,locale: Locale(identifier: lang))
        case 2:
            cell.textLabel?.font = UIFont.systemFont(ofSize: 15)
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.lineBreakMode = .byWordWrapping
            cell.textLabel?.textAlignment = .justified
            cell.textLabel!.text = self.model.summary
        case 3:
            let str = self.model.content?.html2Attributed
            
            var options = [NSAttributedString.Key:Any]()
                options[NSAttributedString.Key.font] = UIFont.systemFont(ofSize: 15)
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 5
            paragraphStyle.paragraphSpacing = 0
            options[NSAttributedString.Key.paragraphStyle] = paragraphStyle
            options[NSAttributedString.Key.foregroundColor] = UIColor.black
            str!.addAttributes(options, range: NSMakeRange(0, str!.length))
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.lineBreakMode = .byWordWrapping
            cell.textLabel!.attributedText = str
        default:
            cell.textLabel!.text = ""
        }
        
        return cell
    }
    
    
}
