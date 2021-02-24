//
//  ConversationDetailHeader.swift
//  Erxes iOS SDK
//
//  Created by soyombo bat-erdene on 5/1/20.
//  Copyright © 2020 Soyombo bat-erdene. All rights reserved.
//

import UIKit


class MessengerHeader: UIView {

    var didTapHandler: (() -> Void)?
    var backButtonHandler: (() -> Void)?
    var moreButtonHandler: (() -> Void)?
    var isCollapsed = false

    let linkTypes = ["facebook",
                     "twitter",
                     "youtube",
                     "linkedIn",
                     "github",
                     "website"]

    var socialButtons = [UIButton]()

    private var participatedUser: UserDetailModel? {
        didSet {
            titleLabel.text = participatedUser?.details?.fullName
            subtitleLabel.text = participatedUser?.details?.position
            supporterAvatarView.image = UIImage(named: "ic_avatar",in: Erxes.erxesBundle(), compatibleWith: nil)
            if let avatarUrl = participatedUser?.details?.avatar {

                supporterAvatarView.sd_setImage(with: URL(string: avatarUrl.readFile()), placeholderImage: UIImage(named: "ic_avatar",in: Erxes.erxesBundle(), compatibleWith: nil))
            }

            if let descriptionText = participatedUser?.details?.description {
                descriptionLabel.text = descriptionText
            }
            
            
            if let links = participatedUser?.links as? [String:String]{
                for type in linkTypes {
                    if let link = links[type], link.count != 0 {
                        let button = SocialButton()
                        let image = UIImage(named: String(format: "icon_%@", type),in: Erxes.erxesBundle(), compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
                        button.setImage(image, for: .normal)
                        button.imageEdgeInsets = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 20)
                        button.tintColor = .white
                        button.params["link"] = link
                        button.addTarget(self, action: #selector(socialButtonAction(sender:)), for: .touchUpInside)
                        linksView.addArrangedSubview(button)

                        button.snp.makeConstraints { (make) in
                            make.width.height.equalTo(40)
                            make.top.equalToSuperview()
                        }
                    }
                }
                let spacerView = UIView()
                spacerView.setContentHuggingPriority(.defaultLow, for: .horizontal)

                linksView.addArrangedSubview(spacerView)
            }

            setupLayoutSupporter()
        }
    }





    private var supporters = [UserModel]() {
        didSet {
            
            if supporters.count == 1 {
                supportersView.addArrangedSubview(UIView())
            }
            
            for (i, supporter) in supporters.enumerated() {
                let avatarView = AvatarView(frame: .zero)
                avatarView.frame.size = CGSize(width: 50, height: 50)
                let avatarViewCollapsed = AvatarView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))

                avatarView.image = UIImage(named: "ic_avatar",in: Erxes.erxesBundle(), compatibleWith: nil)
                avatarViewCollapsed.image = UIImage(named: "ic_avatar",in: Erxes.erxesBundle(), compatibleWith: nil)
                avatarViewCollapsed.layer.borderColor = UIColor.white.cgColor
                avatarViewCollapsed.layer.borderWidth = 0.5
                if let avatarUrl = supporter.details?.avatar {

                    avatarView.sd_setImage(with: URL(string: avatarUrl.readFile()), placeholderImage: UIImage(named: "ic_avatar",in: Erxes.erxesBundle(), compatibleWith: nil))
                    avatarViewCollapsed.sd_setImage(with: URL(string: avatarUrl.readFile()), placeholderImage: UIImage(named: "ic_avatar",in: Erxes.erxesBundle(), compatibleWith: nil))
                }

                let nameLabel = UILabel()
                nameLabel.textColor = .white
                nameLabel.textAlignment = .center
                nameLabel.text = supporter.details?.shortName
                nameLabel.font = UIFont.systemFont(ofSize: 10)
                nameLabel.sizeToFit()
                nameLabel.tag = i + 10

                supportersView.addArrangedSubview(avatarView)
                collapsedSupportersView.addSubview(avatarViewCollapsed)

                avatarView.snp.makeConstraints { (make) in
                    make.width.height.equalTo(50)
                    make.top.equalToSuperview()
                }

                self.addSubview(nameLabel)

                nameLabel.snp.makeConstraints { (make) in
                    make.centerX.equalTo(avatarView)
                    make.top.equalTo(supportersView.snp.bottom).offset(5)
                }
            }
            
            if supporters.count == 1 {
                supportersView.addArrangedSubview(UIView())
            }

            self.setupLayout()
//            self.supportersView.snp.updateConstraints { (make) in
//                make.height.equalTo(250)
//            }

        }
    }



    let contentWidth = SCREEN_WIDTH - 100

    var bgView: UIImageView = {
        let image = UIImage(named: "pattern",in: Erxes.erxesBundle(), compatibleWith: nil)
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor.init(hexString: uiOptions?.color ?? "#6569DF")
        imageView.image = image
        imageView.contentMode = UIView.ContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .white
        label.text = brand?.name
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.sizeToFit()
//        label.backgroundColor = .red
        return label
    }()

    var subtitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 15)
        label.text = brand?.description
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.sizeToFit()
//        label.backgroundColor = .green
        return label
    }()

    var descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 15)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.sizeToFit()
        return label
    }()

    var linksView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .center
//        stackView.spacing = .eq
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
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

    var supportersView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false

        return stackView
    }()

    var supporterAvatarView = AvatarView()

    var collapsedSupportersView: UIView = {
        let stackView = UIView()

        stackView.alpha = 0.0
        return stackView
    }()

    func setCenter() {

        if supporters.count == 2 {
            let imageView1 = collapsedSupportersView.subviews.last
            imageView1?.frame = CGRect(x: (contentWidth / 2 - 20) + 15, y: 0, width: 40, height: 40)
            let imageView2 = collapsedSupportersView.subviews.first
            imageView2?.frame = CGRect(x: (contentWidth / 2 - 20) - 15, y: 0, width: 40, height: 40)
        } else if supporters.count == 3 {
            let imageView1 = collapsedSupportersView.subviews.last
            imageView1?.frame = CGRect(x: (contentWidth / 2 - 20) + 30, y: 0, width: 40, height: 40)
            let imageView2 = collapsedSupportersView.subviews[1]
            imageView2.frame = CGRect(x: (contentWidth / 2 - 20), y: 0, width: 40, height: 40)
            let imageView3 = collapsedSupportersView.subviews.first
            imageView3?.frame = CGRect(x: (contentWidth / 2 - 20) - 30, y: 0, width: 40, height: 40)
        } else if supporters.count == 1 {
            let imageView = collapsedSupportersView.subviews.first
            imageView?.frame = CGRect(x: (contentWidth / 2 - 20), y: 0, width: 40, height: 40)
        }
    }


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
        self.addSubview(collapsedSupportersView)
        self.addSubview(backButton)
        self.addSubview(moreButton)
        self.addSubview(supporterAvatarView)
        self.addSubview(titleLabel)
        self.addSubview(subtitleLabel)
        self.addSubview(supportersView)
        self.addSubview(descriptionLabel)
        self.addSubview(linksView)
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

        bgView.backgroundColor = UIColor.init(hexString: uiOptions?.color ?? "#6569DF")

    }

    override func layoutSubviews() {
        super.layoutSubviews()

        bgView.frame = self.frame
    }

    func setupLayout() {

        collapsedSupportersView.snp.makeConstraints { (make) in
            make.centerY.equalTo(backButton)
            make.centerX.equalToSuperview()
            make.width.equalTo(contentWidth)
            make.height.equalTo(40)
        }

        if !isCollapsed {
            titleLabel.snp.makeConstraints { (make) in
                make.width.equalTo(contentWidth)
                make.centerY.equalTo(backButton)
                make.centerX.equalToSuperview()
            }

            subtitleLabel.snp.makeConstraints { (make) in
                make.width.equalTo(contentWidth)
                make.top.equalTo(titleLabel.snp.bottom).offset(18)
                make.centerX.equalToSuperview()
            }

            supportersView.snp.makeConstraints { (make) in
                make.left.equalTo(titleLabel)
                make.width.equalTo(contentWidth)
                make.top.equalTo(subtitleLabel.snp.bottom).offset(10)
                make.height.equalTo(50)
                make.bottom.equalToSuperview().inset(26)
            }

            self.layoutSubviews()


        } else {
            bgView.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 64)
        }

    }


    func setupLayoutSupporter() {

        if (participatedUser?.details?.avatar) != nil {
            supporterAvatarView.snp.makeConstraints { (make) in
                make.left.equalTo(backButton.snp.right).offset(10)
                make.top.equalToSuperview().offset(10)
                make.width.height.equalTo(44)
            }
        } else {
            supporterAvatarView.snp.makeConstraints { (make) in
                make.height.equalTo(44)
                make.width.equalTo(0)
                make.left.equalTo(backButton.snp.right).offset(10)
                make.top.equalToSuperview().offset(10)
            }

        }

        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(supporterAvatarView.snp.right).offset(10)
            make.right.equalTo(moreButton.snp.left).inset(10)
            make.top.equalTo(supporterAvatarView)
            if subtitleLabel.text?.count == 0 {
                make.centerY.equalTo(supporterAvatarView)
            }
        }

        subtitleLabel.snp.makeConstraints { (make) in
            make.left.right.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(5)

        }

        descriptionLabel.snp.makeConstraints { (make) in
            make.width.equalTo(contentWidth)
            if descriptionLabel.text?.count == 0 {
                make.top.equalTo(supporterAvatarView.snp.bottom).offset(0)
            } else {
                make.top.equalTo(supporterAvatarView.snp.bottom).offset(16)
            }
            make.left.equalTo(supporterAvatarView)
        }


        linksView.snp.makeConstraints { (make) in
            make.width.equalTo(contentWidth)
            make.top.equalTo(descriptionLabel.snp.bottom).offset(0)
            make.height.equalTo(0)
            make.bottom.equalToSuperview().inset(16)
            make.left.equalTo(supporterAvatarView)
        }

        if let links = participatedUser?.links as? [String:String]{
            for type in linkTypes {
                if let link = links[type], link.count != 0 {
                    linksView.snp.remakeConstraints { (make) in
                        make.width.equalTo(contentWidth)
                        make.top.equalTo(descriptionLabel.snp.bottom).offset(10)
                        make.height.equalTo(40)
                        make.bottom.equalToSuperview().inset(16)
                        make.left.equalTo(supporterAvatarView)
                    }
                }
            }
        }

        self.layoutSubviews()


    }

    override func updateConstraints() {
        super.updateConstraints()


    }

    func setSupporters(supporters: [UserModel]) {
        self.supporters = supporters
    }
    
    func setBackButtonHandler(handler: @escaping () -> Void) {
        self.backButtonHandler = handler
    }

    func setSupporter(supporter: UserDetailModel) {
        
        self.participatedUser = supporter
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

    @objc func animateHeader() {
        if isCollapsed {
            UIView.animate(withDuration: 0.3, animations: {
                
                self.collapsedSupportersView.alpha = 0
           
            }) { (flag) in
                if flag {
                    if let handle = self.didTapHandler {
                        handle()
                    }
                    
                    if (self.participatedUser == nil) {
                        if self.supporters.count != 0 {
                            self.titleLabel.alpha = 1.0
                        }
                        
                        self.supportersView.alpha = 1.0
                        
                        self.subtitleLabel.alpha = 1.0
                        
                        for (i, _) in self.supporters.enumerated() {
                            self.viewWithTag(i + 10)?.alpha = 1.0
                        }
                    }
                    self.layoutIfNeeded()
                }
            }
        }else {
            UIView.animate(withDuration: 0.3, animations: {
                
                
                if (self.participatedUser == nil) {
                    if self.supporters.count != 0 {
                        self.titleLabel.alpha = 0.0
                    }
                    
                    self.supportersView.alpha = 0.0
                    
                    self.subtitleLabel.alpha = 0.0
                    
                    for (i, _) in self.supporters.enumerated() {
                        self.viewWithTag(i + 10)?.alpha = 0.0
                    }
                }
                
                self.layoutIfNeeded()
            }) { (flag) in
                if flag {
                    if let handle = self.didTapHandler {
                        handle()
                    }
                    self.isCollapsed = true
                    self.animateSupportersToTitle()
                }
            }
        }
    }

    func animateSupportersToTitle() {
        self.setCenter()
        UIView.animate(withDuration: 0.3, animations: {
            self.collapsedSupportersView.alpha = 1
            self.bgView.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 64)
            self.frame = self.bgView.frame
            self.layoutIfNeeded()
        })
    }

    @objc func socialButtonAction(sender: SocialButton) {
        self.openLink(link: sender.params["link"] as! String)
    }

    private func openLink(link: String) {
        let validUrlString = link.hasPrefix("http") ? link : "http://\(link)"
        guard let url = URL(string: validUrlString) else { return }
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
}

extension MessengerHeader: UIGestureRecognizerDelegate {
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {

        if gestureRecognizer.view == backButton || gestureRecognizer.view == moreButton {
            return false
        }

        return true
    }
}


