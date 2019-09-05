//
//  ChatCellCollectionViewCell.swift
//  erxesiosdk
//
//  Created by Soyombo bat-erdene on 8/20/19.
//  Copyright © 2019 Soyombo bat-erdene. All rights reserved.
//

import UIKit

class ChatCell: BaseCells {
    static let identifier = String(describing: ChatCell.self)
    
    override func updateView() {
        
        super.updateView()
        dateLabel.textAlignment = .right
        avatarView.isHidden = true
        guard let content = self.model?.content else {
            return
        }
        

        let str = content.html2Attributed
        
        var options = [NSAttributedString.Key:Any]()
//        options[NSAttributedString.Key.font] = UIFont.systemFont(ofSize: 13)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5
        paragraphStyle.paragraphSpacing = 0
        options[NSAttributedString.Key.paragraphStyle] = paragraphStyle
        
      
            textView.backgroundColor = themeColor
            edgeView.backgroundColor = themeColor
            options[NSAttributedString.Key.foregroundColor] = UIColor.white
        
        let attributes = str!.attributes(at: 0, effectiveRange: nil)
        let font = attributes[NSAttributedString.Key.font] as? UIFont
        let newFont = font?.withSize(font!.pointSize + 5.0)
        options[NSAttributedString.Key.font] = newFont
        
        
        
        str!.addAttributes(options, range: NSMakeRange(0, str!.length))
        
        DispatchQueue.main.async {
            self.textView.attributedText = str
            self.textView.snp.removeConstraints()
            self.textView.snp.remakeConstraints { (make) in
                make.right.equalToSuperview().offset(-5)
                make.top.equalToSuperview()
                make.bottom.equalToSuperview().offset(-20)
               
                if self.height <= 59 {
                    make.width.equalTo(self.width + 20)
                    
                } else {
                    make.left.equalToSuperview().offset(55)
                }
            }
        }
    }
    
    override func layoutView() {
        avatarView.snp.remakeConstraints { (make) in
            make.right.equalTo(contentView.snp.right).offset(-10)
            make.top.equalTo(contentView.snp.top)
            make.width.height.equalTo(30)
        }
        
        textView.snp.removeConstraints()
        
        textView.snp.remakeConstraints { (make) in
            make.right.equalToSuperview().offset(-5)
            make.top.equalToSuperview()
            make.bottom.equalToSuperview().offset(-20)
            if height <= 59 {
                make.width.equalTo(width + 20)
                
            } else {
                make.left.equalToSuperview().offset(55)
            }
        }
        dateLabel.snp.remakeConstraints { (make) in
            make.right.equalToSuperview().offset(-5)
            make.bottom.equalTo(contentView.snp.bottom).offset(0)
            make.height.equalTo(20)
            make.width.equalTo(50)
        }
        edgeView.snp.remakeConstraints { (make) in
            make.top.equalTo(textView.snp.top)
            make.right.equalTo(textView.snp.right)
            make.width.height.equalTo(15)
        }
       self.contentView.bringSubviewToFront(textView)
    }
}
