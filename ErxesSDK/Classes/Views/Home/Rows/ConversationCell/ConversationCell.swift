//
//  SegmentedCell.swift
//  erxesiosdk
//
//  Created by Soyombo bat-erdene on 8/16/19.
//  Copyright © 2019 Soyombo bat-erdene. All rights reserved.
//

import UIKit

class ConversationCell: UITableViewCell {

 
    
    lazy var avatarView: UIImageView = {
        let imageview = UIImageView()
        imageview.image = UIImage(named: "ic_avatar", in: Erxes.erxesBundle(), compatibleWith: nil)
        self.contentView.addSubview(imageview)
        imageview.contentMode = .scaleAspectFit
        return imageview
    }()
    
    lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 15)
        self.contentView.addSubview(label)
         label.sizeToFit()
        return label
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 15)
        self.contentView.addSubview(label)
        label.sizeToFit()
        return label
    }()
    
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 13)
        self.contentView.addSubview(label)
         label.sizeToFit()
        return label
    }()
    
    var line: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        
        return view
    }()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layoutSubviews()
        
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.contentView.addSubview(line)
        self.layoutSubviews()
    }
    
    override func layoutSubviews(){
        super.layoutSubviews()
        self.backgroundColor = .white
        avatarView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(8)
            make.width.height.equalTo(44)
            make.centerY.equalToSuperview()
        }
        
        avatarView.layer.cornerRadius = 22
        avatarView.clipsToBounds = true
        
        dateLabel.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-8)
            make.top.equalTo(avatarView)
        }
        
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(avatarView.snp.right).offset(8)
            make.top.equalTo(avatarView)
            make.right.equalTo(dateLabel.snp.left).offset(-8)
        }
      
        messageLabel.snp.makeConstraints { (make) in
            make.left.equalTo(avatarView.snp.right).offset(8)
            make.right.equalToSuperview().offset(-8)
            make.bottom.equalTo(avatarView)
        }
        
        line.snp.makeConstraints { (make) in
            make.right.bottom.equalToSuperview()
            make.height.equalTo(0.7)
            make.left.equalTo(messageLabel)
        }
    }
    
    
    
    func setup(viewModel:ConversationModel) {
        nameLabel.text = "Support staff".localized(lang)
        dateLabel.text = Utils.formatDate(time: viewModel.createdAt!)
        if let users = viewModel.participatedUsers?.compactMap({$0?.fragments.userModel}) {
            if let user = users.last {
                nameLabel.text = user.details?.fullName
                if let avatar = user.details?.avatar {
                    avatarView.sd_setImage(with: URL(string: avatar), placeholderImage:UIImage(named: "ic_avatar", in: Erxes.erxesBundle(), compatibleWith: nil))
                }
            }
        }
        
        messageLabel.text = viewModel.content?.withoutHtml
    
        setNeedsLayout()
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.avatarView.image = UIImage(named: "ic_avatar", in: Erxes.erxesBundle(), compatibleWith: nil)
        self.dateLabel.text = nil
        self.nameLabel.text = nil
        self.messageLabel.text = nil
    }

}
