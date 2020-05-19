//
//  OperatorChatCell.swift
//  erxesiosdk
//
//  Created by Soyombo bat-erdene on 8/20/19.
//  Copyright © 2019 Soyombo bat-erdene. All rights reserved.
//

import UIKit

class OperatorChatCell: BaseCells {
    static let identifier = String(describing: OperatorChatCell.self)
    
    override func updateView() {
        
        super.updateView()
        
        dateLabel.textAlignment = .left
        
        guard let content = model?.content else {
            return
        }
        
        guard let str = content.html2Attributed else { return }
        
        var options = [NSAttributedString.Key:Any]()
//        options[NSAttributedString.Key.font] = Font.regular(13)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5
        paragraphStyle.paragraphSpacing = 0
        options[NSAttributedString.Key.paragraphStyle] = paragraphStyle
        options[NSAttributedString.Key.foregroundColor] = UIColor.black
        
        let attributes = str.attributes(at: 0, effectiveRange: nil)
        let font = attributes[NSAttributedString.Key.font] as? UIFont
        let newFont = UIFont.systemFont(ofSize: font!.pointSize + 5.0)
        
        options[NSAttributedString.Key.font] = newFont
        
        str.addAttributes(options, range: NSMakeRange(0, str.length))
        
        DispatchQueue.main.async {
            self.textView.attributedText = str
            self.textView.snp.removeConstraints()
            self.textView.snp.makeConstraints { (make) in
                make.left.equalTo(self.avatarView.snp.right).offset(5)
                make.top.equalToSuperview()
                make.bottom.equalToSuperview().offset(-20)
                make.width.equalTo(self.width + 20)
            }
        }
    }
    
    override func layoutView() {
        avatarView.snp.remakeConstraints { (make) in
            make.left.equalTo(contentView.snp.left).offset(5)
            make.top.equalTo(contentView.snp.top)
            make.width.height.equalTo(30)
        }
        
        textView.snp.removeConstraints()
        textView.snp.makeConstraints { (make) in
            make.left.equalTo(avatarView.snp.right).offset(5)
            make.top.equalToSuperview()
            make.bottom.equalToSuperview().offset(-20)
            make.width.equalTo(width + 20)
        }
        
       
        
        dateLabel.snp.remakeConstraints { (make) in
            make.left.equalTo(avatarView.snp.right).offset(5)
            make.bottom.equalTo(contentView.snp.bottom).offset(0)
            make.height.equalTo(20)
            make.width.equalTo(50)
        }
        edgeView.snp.remakeConstraints { (make) in
            make.top.equalTo(textView.snp.top)
            make.left.equalTo(textView.snp.left)
            make.width.height.equalTo(15)
        }
        textView.backgroundColor = UIColor.init(hexString: "#e7e8ea")
        edgeView.backgroundColor = UIColor.init(hexString: "#e7e8ea")
        self.contentView.bringSubviewToFront(textView)
    }
}
