//
//  ConversationsView.swift
//  Erxes iOS SDK
//
//  Created by soyombo bat-erdene on 5/1/20.
//  Copyright © 2020 Soyombo bat-erdene. All rights reserved.
//

import UIKit

class ConversationsView: UIView {

    private var conversations = [ConversationModel]() {
        didSet {
            reloadView()
        }
    }

    var didTapHandler: (() -> Void)?
    var didSelectRowHandler: ((_ row: Int)-> Void)?
    var unreadIds = [String]()

    var conversationsHeader = ConversationsHeader()

    var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)

        label.textColor = .black
        label.textAlignment = .left
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.sizeToFit()

        return label
    }()

    var tableView: UITableView = {
        let tableView = UITableView.init(frame: .zero)
        tableView.layer.cornerRadius = 10
        tableView.tableFooterView = UIView()
        tableView.clipsToBounds = true
        tableView.register(ConversationCell.self, forCellReuseIdentifier: "ConversationCell")
        tableView.register(ConversationUnreadCell.self, forCellReuseIdentifier: "ConversationUnreadCell")
        tableView.separatorColor = .clear
        tableView.rowHeight = 70
        tableView.backgroundColor = UIColor.white
        tableView.isScrollEnabled = false
        return tableView
    }()


    override init(frame: CGRect) {
        super.init(frame: frame)
        didLoad()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        didLoad()
    }

    convenience init() {
        self.init(frame: .zero)
    }

    func reloadView() {

        titleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(16)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
        }

        tableView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.height.equalTo((conversations.count + 1) * 70)
            make.bottom.equalToSuperview()
        }
        tableView.reloadData()
    }

    func didLoad() {

        self.backgroundColor = .white
        self.layer.cornerRadius = 10
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOffset = CGSize(width: 3, height: 3)
        self.layer.shadowOpacity = 0.7
        self.layer.shadowRadius = 4.0

        titleLabel.text = "Recent conversations".localized(lang)

        self.addSubview(titleLabel)

        tableView.delegate = self
        tableView.dataSource = self

        self.addSubview(tableView)

    }

    override func layoutSubviews() {
        super.layoutSubviews()



    }

    override func updateConstraints() {
        super.updateConstraints()

    }


    func setConversations(conversations: [ConversationModel]) {
        self.conversations = conversations
    }
    
    @objc func newConversation(){
        if let handle = didTapHandler {
            handle()
        }
    }
    
    @objc func navigateConversationDetail(indexPath: IndexPath){
          if let handle = didSelectRowHandler {
            handle(indexPath.row)
          }
      }

}


extension ConversationsView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conversations.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {

            let model = conversations[indexPath.row]

            if self.unreadIds.contains(model._id) {

                if let unreadCell = tableView.dequeueReusableCell(withIdentifier: "ConversationUnreadCell", for: indexPath) as? ConversationUnreadCell {
                    unreadCell.setup(viewModel: model)
                    unreadCell.layoutIfNeeded()
                    return unreadCell
                }
            } else {

                if let cell = tableView.dequeueReusableCell(withIdentifier: "ConversationCell", for: indexPath) as? ConversationCell {
                    cell.setup(viewModel: model)
                    cell.layoutIfNeeded()

                    return cell
                }
            }

        }
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(newConversation))

        tapRecognizer.numberOfTapsRequired = 1
        tapRecognizer.numberOfTouchesRequired = 1
        conversationsHeader.addGestureRecognizer(tapRecognizer)
        
        return conversationsHeader
    }

    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.navigateConversationDetail(indexPath: indexPath)
    }
}
