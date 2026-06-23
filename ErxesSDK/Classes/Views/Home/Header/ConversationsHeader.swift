//
//  ConversationHeader.swift
//  erxesiosdk
//
//  Created by Soyombo bat-erdene on 8/19/19.
//  Copyright © 2019 Soyombo bat-erdene. All rights reserved.
//

import UIKit

class ConversationsHeader: UIView {

    
    var mainTitlelabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.text = "Recent conversations".localized(lang)
        label.sizeToFit()
        return label
    }()
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.text = "Start new conversation".localized(lang)
        label.sizeToFit()
        return label
    }()
    
    var subtitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 15)
        label.text = "Talk with support staff".localized(lang)
        label.sizeToFit()
        return label
    }()
    
    var addbutton: UIImageView = {
       let imageview = UIImageView()
        imageview.clipsToBounds = true
        imageview.image = UIImage.erxes(with: .plus, textColor: .gray, size: CGSize(width: 40, height: 40), backgroundColor: .white).scale(by: 0.5)
        imageview.layer.borderColor = UIColor.lightGray.cgColor
        imageview.layer.borderWidth = 0.7
        imageview.contentMode = .center
        return imageview
    }()
    
    var line:UIView = {
       let view = UIView()
        view.backgroundColor = .lightGray
        return view
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
    
    func didLoad() {
        self.backgroundColor = .white
        self.addSubview(mainTitlelabel)
        self.addSubview(addbutton)
        self.addSubview(titleLabel)
        self.addSubview(subtitleLabel)
        self.addSubview(line)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        mainTitlelabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(8)
            make.right.equalToSuperview().offset(-8)
            make.top.equalToSuperview().offset(8)
        }
        
        addbutton.snp.makeConstraints { (make) in
            make.left.equalTo(mainTitlelabel)
            make.top.equalTo(mainTitlelabel.snp.bottom).offset(18)
            make.width.height.equalTo(44)
        }
        
        addbutton.layer.cornerRadius = 22
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(addbutton.snp.right).offset(8)
            make.top.equalTo(addbutton)
            make.right.equalToSuperview().offset(-8)
        }
        
        subtitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(addbutton.snp.right).offset(8)
            make.bottom.equalTo(addbutton)
            make.right.equalToSuperview().offset(-8)
        }
        
        line.snp.makeConstraints { (make) in
            make.bottom.right.equalToSuperview()
            make.height.equalTo(0.7)
            make.left.equalTo(titleLabel)
        }
        
//        self.roundCorners(corners: [.topLeft,.topRight], radius: 8)
        //Custom manually positioning layout goes here (auto-layout pass has already run first pass)
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        
        //Disable this if you are adding constraints manually
        //or you're going to have a 'bad time'
        //self.translatesAutoresizingMaskIntoConstraints = false
        
        //Add custom constraint code here
    }
}
