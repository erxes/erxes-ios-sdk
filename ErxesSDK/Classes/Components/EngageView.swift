//
//  EngageView.swift
//  Erxes iOS SDK
//
//  Created by soyombo bat-erdene on 4/30/20.
//  Copyright © 2020 Soyombo bat-erdene. All rights reserved.
//


import Foundation
import UIKit
import SnapKit
import SDWebImage

class EngageView {
    static let labelLeftMarging = CGFloat(16)
    static let labelTopMargin = CGFloat(24)
    static let animateDuration = 0.5
    static let bannerAppearanceDuration: TimeInterval = 5

    var didTapHandler: (() -> Void)?
    
    @objc private func tapAction(sender:UIGestureRecognizer){
        
        if let handle = didTapHandler {
            handle()
        }
    }
    
    static func show(_ avatarUrl: String, fullName: String, text: String) {
        
        let superView = UIApplication.shared.keyWindow!.rootViewController!.view!

        let height = CGFloat(120)


        let bannerView = UIView(frame: CGRect(x: 0, y: 0 - height, width: SCREEN_WIDTH, height: height))
        bannerView.layer.opacity = 1
        bannerView.backgroundColor = UIColor.white

        bannerView.layer.cornerRadius = 10

        // shadow
        bannerView.layer.shadowColor = UIColor.lightGray.cgColor
        bannerView.layer.shadowOffset = CGSize(width: 3, height: 3)
        bannerView.layer.shadowOpacity = 0.7
        bannerView.layer.shadowRadius = 4.0

        let avatarView = UIImageView()
        avatarView.layer.cornerRadius = 22
        avatarView.clipsToBounds = true
        avatarView.sd_setImage(with: URL(string: avatarUrl), placeholderImage: UIImage(named: "ic_avatar",in: Erxes.erxesBundle(), compatibleWith: nil))

        let nameLabel = UILabel(frame: CGRect.zero)
        nameLabel.textColor = UIColor.black
        nameLabel.numberOfLines = 0
        nameLabel.text = fullName
        nameLabel.font = UIFont.systemFont(ofSize: 15)

        

        let str = text.html2Attributed

        var options = [NSAttributedString.Key: Any]()
        //        options[NSAttributedString.Key.font] = Font.regular(13)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5
        paragraphStyle.paragraphSpacing = 0
        options[NSAttributedString.Key.paragraphStyle] = paragraphStyle
        options[NSAttributedString.Key.foregroundColor] = UIColor.gray

        let attributes = str!.attributes(at: 0, effectiveRange: nil)
        let font = attributes[NSAttributedString.Key.font] as? UIFont
        let newFont = UIFont.systemFont(ofSize: font!.pointSize + 5.0)
        options[NSAttributedString.Key.font] = newFont

        str!.addAttributes(options, range: NSMakeRange(0, str!.length))

        let contentLabel = UILabel(frame: CGRect.zero)
        contentLabel.textColor = UIColor.lightGray
        contentLabel.numberOfLines = 0
        contentLabel.font = UIFont.systemFont(ofSize: 13)
        contentLabel.attributedText = str


        bannerView.addSubview(avatarView)
        bannerView.addSubview(nameLabel)
        bannerView.addSubview(contentLabel)
        superView.addSubview(bannerView)

        avatarView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().inset(16)
            make.top.equalToSuperview().inset(25)
            make.height.width.equalTo(44)
        }

        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(avatarView.snp.right).offset(16)
            make.centerY.equalTo(avatarView)
            make.right.equalToSuperview().inset(16)
        }

        contentLabel.snp.makeConstraints { (make) in
            make.left.equalTo(avatarView)
            make.top.equalTo(avatarView.snp.bottom).offset(8)
            make.right.equalToSuperview().inset(8)
            make.bottom.equalToSuperview().inset(8)
        }
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapAction(sender:)))
        
        tapRecognizer.numberOfTapsRequired = 1
        tapRecognizer.numberOfTouchesRequired = 1
        bannerView.addGestureRecognizer(tapRecognizer)


        UIView.animate(withDuration: animateDuration) {
//      bannerTopConstraint.constant = 0
            bannerView.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: height)
            superView.layoutIfNeeded()
        }

        //remove subview after time 2 sec
        UIView.animate(withDuration: animateDuration, delay: bannerAppearanceDuration, options: [], animations: {
//      bannerTopConstraint.constant = 0 - bannerView.frame.height
            bannerView.frame = CGRect(x: 0, y: 0 - height, width: SCREEN_WIDTH, height: height)
            superView.layoutIfNeeded()
        }, completion: { finished in
            if finished {
                bannerView.removeFromSuperview()
            }
        })
    }
}
