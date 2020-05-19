//
//  KBCategoryCell.swift
//  erxesiosdk
//
//  Created by Soyombo bat-erdene on 8/28/19.
//  Copyright © 2019 Soyombo bat-erdene. All rights reserved.
//

import UIKit

class KBCategoryCell: UITableViewCell {

    lazy var iconView: UIImageView = {
        let imageview = UIImageView()
//        imageview.image = UIImage(named: "ic_avatar", in: Erxes.erxesBundle(), compatibleWith: nil)
        self.contentView.addSubview(imageview)
        imageview.backgroundColor = UIColor.init(hexString: "#f6f4f8")
        imageview.contentMode = .center
        return imageview
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 15)
        self.contentView.addSubview(label)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.sizeToFit()
        return label
    }()
    
    lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 15)
        self.contentView.addSubview(label)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
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
        
        self.setupConstraint()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.contentView.addSubview(line)
        self.setupConstraint()
    }
    
    func setupConstraint() {
        self.backgroundColor = .white
        iconView.snp.makeConstraints { (make) in
            make.left.top.equalToSuperview().offset(8)
            make.width.height.equalTo(44)
        }
        
        iconView.layer.cornerRadius = 22
        iconView.clipsToBounds = true
        
        
        
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(iconView.snp.right).offset(8)
            make.right.equalToSuperview().offset(-8)
            make.top.equalTo(iconView)
            
        }
        
    
        
        subtitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(iconView.snp.right).offset(8)
            make.right.equalToSuperview().offset(-8)
            make.bottom.equalToSuperview().offset(-8)
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
        }
        
        line.snp.makeConstraints { (make) in
            make.right.bottom.equalToSuperview()
            make.height.equalTo(0.7)
            make.left.equalTo(titleLabel)
        }
    }
    
    
    
    func setup(model: KbArticleModel) {
        self.titleLabel.text = model.title
        self.subtitleLabel.text = model.summary
        self.iconView.image =  UIImage.erxes(with: .clipboard, textColor: .darkGray, size: CGSize(width: 40, height: 40), backgroundColor: .clear).scale(by: 0.5)

        setNeedsLayout()
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }

}
