//
//  WebsiteAppView.swift
//  Erxes iOS SDK
//
//  Created by soyombo bat-erdene on 5/14/20.
//  Copyright © 2020 Soyombo bat-erdene. All rights reserved.
//

import UIKit

class WebsiteAppView: UIView {

    private var data:WebsiteApp? {
        didSet {
            reloadView()
        }
    }
    
    var didTapHandler: (() -> Void)?
    
    
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
    
    var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        
        label.textColor = .lightGray
        label.textAlignment = .left
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.sizeToFit()
        
        return label
    }()
    
    var button: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(hexString: uiOptions?.color ?? defaultColorCode)
        button.layer.cornerRadius = 8
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(openUrl(sender:)), for: .touchUpInside)
        button.layer.shadowColor = UIColor.lightGray.cgColor
        button.layer.shadowOffset = CGSize(width: 3, height: 3)
        button.layer.shadowOpacity = 0.7
        button.layer.shadowRadius = 4.0
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
    
    convenience init(data: WebsiteApp) {
        self.init(frame: .zero)
        self.data = data
    }
    
    func reloadView() {
        
        titleLabel.text = data?.credentials?.description
        
        titleLabel.snp.makeConstraints { (make) in
            
            if titleLabel.text?.count == 0 {
                make.top.equalToSuperview()
            }else {
                make.top.equalToSuperview().offset(16)
            }
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
        }
        
       
        button.setTitle(data?.credentials?.buttonText, for: .normal)
        
        button.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.height.equalTo(40)
            make.bottom.equalToSuperview().inset(16)
        }
    }
    
    func didLoad() {
        
        self.backgroundColor = .white
        self.layer.cornerRadius = 10
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOffset = CGSize(width: 3, height: 3)
        self.layer.shadowOpacity = 0.7
        self.layer.shadowRadius = 4.0
        
        self.addSubview(titleLabel)
        self.addSubview(button)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
        
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        
    }
    
    
    func setData(data: WebsiteApp) {
        self.data = data
    }
    
    
    @objc func openUrl(sender:UIButton){
        if let handle = didTapHandler {
            handle()
        }
    }

}
