//
//  MainHeaderView.swift
//  Erxes iOS SDK
//
//  Created by soyombo bat-erdene on 4/30/20.
//  Copyright © 2020 Soyombo bat-erdene. All rights reserved.
//

import UIKit
import ErxesFont

class MainHeaderView: UIView {

    private var supporters = [UserModel]() {
        didSet {
            for supporter in supporters {
                let avatarView = AvatarView(frame: .zero)

                avatarView.image = UIImage(named: "ic_avatar",in: Erxes.erxesBundle(), compatibleWith: nil)

                if let avatarUrl = supporter.details?.avatar {
                   
                    avatarView.sd_setImage(with: URL(string: avatarUrl.readFile()), placeholderImage: UIImage(named: "ic_avatar",in: Erxes.erxesBundle(), compatibleWith: nil))
                }
                supportersView.addArrangedSubview(avatarView)

                avatarView.snp.makeConstraints { (make) in
                    make.width.height.equalTo(50)
                }

            }

            let spacerView = UIView()
            spacerView.setContentHuggingPriority(.defaultLow, for: .horizontal)

            supportersView.addArrangedSubview(spacerView)



            self.supportersView.snp.remakeConstraints { (make) in
                make.left.right.equalTo(titleLabel)
                make.top.equalTo(subTitleLabel.snp.bottom).offset(10)
                make.bottom.equalToSuperview().inset(16)
                make.height.equalTo(50)
            }

        }


    }
    
    var moreButtonHandler: (() -> Void)?

    var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)

        label.textColor = .white
        label.textAlignment = .left
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.sizeToFit()

        return label
    }()

    var subTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .white
        label.textAlignment = .left
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.sizeToFit()

        return label
    }()

    var dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .white
        label.textAlignment = .left
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.sizeToFit()
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, yyyy h:mm a"
        formatter.locale = Locale(identifier: lang)
        label.text = formatter.string(from: date)
        return label
    }()

    var facebookButton: UIButton = {
        let button = UIButton()
        button.tag = 1
        button.setImage(UIImage.erxes(with: .facebookSquared, textColor: .white, size: CGSize(width: 30, height: 30), backgroundColor: .clear), for: .normal)
        button.addTarget(self, action: #selector(socialAction(sender:)), for: .touchUpInside)
        return button
    }()

    var twitterButton: UIButton = {
        let button = UIButton()
        button.tag = 2
        button.setImage(UIImage.erxes(with: .twitterSquared, textColor: .white, size: CGSize(width: 30, height: 30), backgroundColor: .clear), for: .normal)
        button.addTarget(self, action: #selector(socialAction(sender:)), for: .touchUpInside)
        return button
    }()

    var youtubeButton: UIButton = {
        let button = UIButton()
        button.tag = 3
        //        button.setImage(UIImage.erxes(with: .youtubePlay, textColor: .white, size: CGSize(width: 30, height: 30), backgroundColor: .clear), for: .normal)
        button.setImage(UIImage(named: "ic_youtube",in: Erxes.erxesBundle(), compatibleWith: nil), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        button.addTarget(self, action: #selector(socialAction(sender:)), for: .touchUpInside)
        return button
    }()

    var linksView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.spacing = 16
        stackView.semanticContentAttribute = .forceLeftToRight
        //        stackView.spacing = .eq
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    var rightButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "ic_more",in: Erxes.erxesBundle(), compatibleWith: nil), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        button.addTarget(self, action: #selector(moreAction(sender:)), for: .touchUpInside)
        return button
    }()

    var bgView: UIImageView = {
        let image = UIImage(named: "pattern",in: Erxes.erxesBundle(), compatibleWith: nil)
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor.init(hexString: uiOptions?.color ?? "#6569DF")
        imageView.image = image
        imageView.contentMode = UIView.ContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    var supportersView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.spacing = 10.0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
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

        titleLabel.text = messengerData?.messages?.greetings?.title ?? "Welcome!".localized(lang)
        subTitleLabel.text = messengerData?.messages?.greetings?.message ?? "Welcome description".localized(lang)

        if messengerData?.messages?.greetings?.title?.count == 0 {
            titleLabel.text = "Welcome!".localized(lang)
        }

        if messengerData?.messages?.greetings?.message?.count == 0 {
            subTitleLabel.text = "Welcome description".localized(lang)
        }

        self.addSubview(bgView)
        self.addSubview(rightButton)
        self.addSubview(dateLabel)
        self.addSubview(linksView)
       
        self.addSubview(titleLabel)
        self.addSubview(subTitleLabel)
        self.addSubview(supportersView)
        self.backgroundColor = UIColor(patternImage: UIImage(named: "pattern",in: Erxes.erxesBundle(), compatibleWith: nil)!)
        self.backgroundColor = UIColor.init(hexString: uiOptions?.color ?? "#6569DF")
        
        
        let spacerView = UIView()
        spacerView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        
        linksView.addArrangedSubview(spacerView)
        
        if ((messengerData?.links?.facebook) != nil) || (messengerData?.links?.facebook?.count != 0) {
            self.linksView.addArrangedSubview(facebookButton)
            facebookButton.snp.makeConstraints { (make) in
                make.height.width.equalTo(30)
            }
        }
        if ((messengerData?.links?.twitter) != nil) || (messengerData?.links?.twitter?.count != 0) {
            self.linksView.addArrangedSubview(twitterButton)
            twitterButton.snp.makeConstraints { (make) in
                make.height.width.equalTo(30)
            }
        }
        if ((messengerData?.links?.youtube) != nil) || (messengerData?.links?.youtube?.count != 0) {
            self.linksView.addArrangedSubview(youtubeButton)
            youtubeButton.snp.makeConstraints { (make) in
                make.height.width.equalTo(30)
            }
        }

    }

    override func layoutSubviews() {
        super.layoutSubviews()

        bgView.backgroundColor = UIColor.init(hexString: uiOptions?.color ?? "#6569DF")

        rightButton.snp.makeConstraints { (make) in
            make.height.width.equalTo(30)
            make.top.equalToSuperview().offset(5)
            make.right.equalToSuperview().offset(-8)
        }


        dateLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(16)
            make.centerY.equalTo(facebookButton.snp.centerY)
        }
        
        linksView.snp.makeConstraints { (make) in
            make.left.equalTo(dateLabel.snp.right).offset(8)
            make.right.equalTo(rightButton.snp.left).offset(-16)
            make.top.equalToSuperview().offset(5)
            make.height.equalTo(30)
        }


        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(linksView.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
        }

        subTitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)

        }

        supportersView.snp.makeConstraints { (make) in
            make.left.right.equalTo(titleLabel)
            make.top.equalTo(subTitleLabel.snp.bottom).offset(10)
            make.bottom.equalToSuperview().inset(16)
        }

        bgView.frame = self.frame
    }

    override func updateConstraints() {
        super.updateConstraints()

    }


    func setSupporters(supporters: [UserModel]) {
        self.supporters = supporters
    }

    @objc func socialAction(sender: UIButton) {
        switch sender.tag {
        case 1:
            self.openLink(link: messengerData?.links?.facebook ?? "https://facebook.com")
        case 2:
            self.openLink(link: messengerData?.links?.twitter ?? "https://twitter.com")
        case 3:
            self.openLink(link: messengerData?.links?.youtube ?? "https://youtube.com")
        default:
            self.openLink(link: messengerData?.links?.facebook ?? "https://facebook.com")
        }
    }

    @objc func moreAction(sender: UIButton) {
        if let handle = moreButtonHandler {
            handle()
        }
    }



    func openLink(link: String) {
        let validUrlString = link.hasPrefix("http") ? link : "http://\(link)"
        guard let url = URL(string: validUrlString) else { return }
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url)
        } else {
            UIApplication.shared.openURL(url)
        }
    }


}








