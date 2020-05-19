//
//  VideoChatCell.swift
//  Erxes iOS SDK
//
//  Created by soyombo bat-erdene on 5/13/20.
//  Copyright © 2020 Soyombo bat-erdene. All rights reserved.
//

import UIKit

class VideoChatCell: BaseCells {

    static let identifier = String(describing: VideoChatCell.self)

    lazy var blueBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBlue
        view.layer.cornerRadius = 10
        self.contentView.insertSubview(view, at: 0)
        return view
    }()
    
    lazy var joinButton: UIButton = {
        let button = UIButton()
        button.setTitle("Join a call".localized(lang), for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(joinAction(sender:)), for: .touchUpInside)
        return button
    }()
    
    override func updateView() {

        super.updateView()
        edgeView.isHidden = true

        textView.textColor = .black
        var str = NSMutableAttributedString()

        if model?.contentType == "videoCallRequest" {
            str = String(format: "📞  %@", "Video call request sent".localized(lang)).html2Attributed!
        } else if (model?.contentType == "videoCall") {
            if model?.videoCallData?.status == "ongoing" {
                str = String(format: "%@ \n👏", "You are invited to a video call".localized(lang)).html2Attributed!
            } else {
                str = String(format: "📞 %@", "Video call ended".localized(lang)).html2Attributed!
            }

        }


        var options = [NSAttributedString.Key: Any]()
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5
        paragraphStyle.paragraphSpacing = 0
        options[NSAttributedString.Key.paragraphStyle] = paragraphStyle

        textView.backgroundColor = .white

        options[NSAttributedString.Key.foregroundColor] = UIColor.black

        let attributes = str.attributes(at: 0, effectiveRange: nil)
        let font = attributes[NSAttributedString.Key.font] as? UIFont
        let newFont = UIFont.systemFont(ofSize: font!.pointSize + 5.0)
        options[NSAttributedString.Key.font] = newFont

        str.addAttributes(options, range: NSMakeRange(0, str.length))

        
        
        if model?.contentType == "videoCallRequest" {
            setupCustomerLayout()
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
        } else if (model?.contentType == "videoCall") {
            if model?.videoCallData?.status == "ongoing" {
                self.contentView.addSubview(self.joinButton)
                DispatchQueue.main.async {
                    
                    self.textView.attributedText = str
                    self.textView.snp.removeConstraints()
              
                    self.textView.snp.makeConstraints { (make) in
                        make.left.equalTo(self.avatarView.snp.right).offset(5)
                        make.top.equalToSuperview()
                        make.width.equalTo(self.width + 20)
                        make.bottom.equalToSuperview().offset(-20)
                    }
                    
                    self.joinButton.snp.makeConstraints { (make) in
                        make.left.right.equalTo(self.textView).inset(10)
                        make.height.equalTo(40)
                        make.bottom.equalTo(self.textView).inset(10)
                    }
                }
            } else {
                setupVideoCallEndedLayout()
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
            
        }
        
   
    }
    
    @objc func joinAction(sender:UIButton){
        if let link = self.model?.videoCallData?.url {
            let validUrlString = link.hasPrefix("http") ? link : "http://\(link)"
            guard let url = URL(string: validUrlString) else { return }
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }

    override func layoutView() {

        blueBackgroundView.snp.makeConstraints { (make) in
            make.left.right.equalTo(textView)
            make.top.bottom.equalTo(textView).offset(-3)
        }
    }

    func setupVideoCallEndedLayout() {

        dateLabel.textAlignment = .left

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


        self.contentView.bringSubviewToFront(textView)
    }
    


    func setupCustomerLayout() {

        dateLabel.textAlignment = .right

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

        self.contentView.bringSubviewToFront(textView)
    }
}


