//
//  CollectionFooter.swift
//  erxesiosdk
//
//  Created by Soyombo bat-erdene on 8/30/19.
//  Copyright © 2019 Soyombo bat-erdene. All rights reserved.
//

import UIKit

class CollectionFooter: UICollectionReusableView {
    var textView: UITextView = {
        let textview = UITextView()
        textview.font = UIFont.systemFont(ofSize: 15)
        textview.textAlignment = .left
        textview.textContainer.lineBreakMode = .byWordWrapping
        textview.textColor = .black
        textview.layer.cornerRadius = 20
        textview.backgroundColor = UIColor.init(hexString: "#e7e8ea")
        textview.textContainerInset = UIEdgeInsets(top: 10, left: 8, bottom: 0, right: 8)
        textview.isEditable = false
        return textview
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(textView)
        textView.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-40)
            make.left.equalToSuperview().offset(40)
            make.top.equalToSuperview().offset(20)
            make.height.equalToSuperview().offset(-20)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
