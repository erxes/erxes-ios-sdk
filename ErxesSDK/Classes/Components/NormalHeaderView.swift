//
//  NormalHeaderView.swift
//  Erxes iOS SDK
//
//  Created by soyombo bat-erdene on 5/14/20.
//  Copyright © 2020 Soyombo bat-erdene. All rights reserved.
//

import UIKit

class NormalHeaderView: UIView {

    var didTapHandler: (() -> Void)?
    var backButtonHandler: (() -> Void)?
    var moreButtonHandler: (() -> Void)?

    private let contentWidth = SCREEN_WIDTH - 100
    
    var bgView: UIImageView = {
        let image = UIImage(named: "pattern",in: Erxes.erxesBundle(), compatibleWith: nil)
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor.init(hexString: uiOptions?.color ?? "#6569DF")
        imageView.image = image
        imageView.contentMode = UIView.ContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .white
        label.numberOfLines = 1
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.sizeToFit()
        return label
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 15)
        label.numberOfLines = 1
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.sizeToFit()
        return label
    }()
    
    lazy var backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage.erxes(with: .leftarrow3, textColor: .white, size: CGSize(width: 27, height: 27)), for: .normal)
        button.addTarget(self, action: #selector(backAction(sender:)), for: .touchUpInside)
        return button
    }()
    
    lazy var moreButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "ic_more",in: Erxes.erxesBundle(), compatibleWith: nil), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 12, left: 20, bottom: 12, right: 0)
        button.imageView!.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(moreAction(sender:)), for: .touchUpInside)
        return button
    }()

    

    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        didLoad()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        didLoad()
    }
    
    
    func didLoad() {
        self.backgroundColor = .white
        self.addSubview(bgView)

        self.addSubview(backButton)
        self.addSubview(moreButton)

        self.addSubview(titleLabel)
        self.addSubview(subtitleLabel)

        self.clipsToBounds = true
        
        
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
        
        bgView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(64)
        }
        
        bgView.backgroundColor = UIColor.init(hexString: uiOptions?.color ?? "#6569DF")
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        titleLabel.snp.makeConstraints { (make) in
            make.width.equalTo(contentWidth)
            
            if subtitleLabel.text?.count == 0 {
                make.centerY.equalTo(backButton)
            }else {
                make.top.equalToSuperview().offset(10)
            }
            make.centerX.equalToSuperview()
        }
        
        subtitleLabel.snp.makeConstraints { (make) in
            make.width.equalTo(contentWidth)
            if titleLabel.text?.count == 0 {
                make.centerY.equalTo(backButton)
            }else {
                make.bottom.equalToSuperview().inset(10)
            }
            make.centerX.equalToSuperview()
        }
    }
    

    override func updateConstraints() {
        super.updateConstraints()
        
        
    }
    
    @objc func backAction(sender: UIButton) {
    
        if let handle = backButtonHandler {
   
            handle()
        }
    }
    
    @objc func moreAction(sender: UIButton) {
        if let handle = moreButtonHandler {
            handle()
        }
    }
    
    func setTitles(title:String? = "", subTitle: String? = ""){
        self.titleLabel.text = title
        self.subtitleLabel.text = subTitle
        self.layoutSubviews()
    }

}
