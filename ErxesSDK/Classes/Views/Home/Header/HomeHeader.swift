//
//  RegisterHeader.swift
//  erxesiosdk
//
//  Created by Soyombo bat-erdene on 8/15/19.
//  Copyright © 2019 Soyombo bat-erdene. All rights reserved.
//

import UIKit

class HomeHeader: UIView {

    var facebookLink = "https://www.facebook.com/"
    var twitterLink = "https://twitter.com/"
    var youtubeLink = "https://www.youtube.com/"
    
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
        button.setImage(UIImage(named: "ic_youtube", in: Erxes.erxesBundle(), compatibleWith: nil), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        button.addTarget(self, action: #selector(socialAction(sender:)), for: .touchUpInside)
        return button
    }()
    
    var rightButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "ic_more",in: Erxes.erxesBundle(), compatibleWith: nil),for:.normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        button.addTarget(self, action: #selector(moreAction(sender:)), for: .touchUpInside)
        return button
    }()
    
    var supportersView: SupporterView = {
       let view = SupporterView()
        return view
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
        //Place your initialization code here
        
        //I actually create & place constraints in here, instead of in
        //updateConstraints
        let image = UIImage(named: "pattern",in: Erxes.erxesBundle(), compatibleWith: nil)
        let bgView = UIImageView()
        bgView.tag = 100
        bgView.backgroundColor = themeColor
        bgView.image = image
        bgView.contentMode = UIView.ContentMode.scaleAspectFill
        
        self.addSubview(bgView)
        self.addSubview(rightButton)
        self.addSubview(dateLabel)
        self.addSubview(youtubeButton)
        self.addSubview(twitterButton)
        self.addSubview(facebookButton)
        self.addSubview(titleLabel)
        self.addSubview(subTitleLabel)
        self.addSubview(supportersView)
        
        bgView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        rightButton.snp.makeConstraints { (make) in
            make.height.width.equalTo(30)
            make.top.equalToSuperview().offset(5)
            make.right.equalToSuperview().offset(-8)
        }
        
        youtubeButton.snp.makeConstraints { (make) in
            make.height.width.equalTo(30)
            make.top.equalToSuperview().offset(5)
            make.right.equalTo(rightButton.snp.left).offset(-10)
        }
        
        twitterButton.snp.makeConstraints { (make) in
            make.height.width.equalTo(30)
            make.top.equalToSuperview().offset(5)
            make.right.equalTo(youtubeButton.snp.left).offset(-10)
        }
        
        facebookButton.snp.makeConstraints { (make) in
            make.height.width.equalTo(30)
            make.top.equalToSuperview().offset(5)
            make.right.equalTo(twitterButton.snp.left).offset(-8)
        }
        
        dateLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(10)
            make.centerY.equalTo(facebookButton.snp.centerY)
        }
        
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(facebookButton.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
        }
        subTitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
        }
        
        supportersView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.height.equalTo(50)
            make.top.equalTo(subTitleLabel.snp.bottom).offset(10)
        }

//        let moreViewWidth = ("End conversation".localized(lang)).widthOfString(usingFont: UIFont.systemFont(ofSize: 13)) + 10
//        
//        moreView.snp.makeConstraints { (make) in
//            make.right.equalTo(rightButton)
//            make.top.equalTo(rightButton.snp.bottom)
//            make.width.equalTo(moreViewWidth)
//            make.height.equalTo(80)
//        }
        
      
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.viewWithTag(100)?.backgroundColor = themeColor
        //Custom manually positioning layout goes here (auto-layout pass has already run first pass)
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        
        //Disable this if you are adding constraints manually
        //or you're going to have a 'bad time'
        //self.translatesAutoresizingMaskIntoConstraints = false
        
        //Add custom constraint code here
    }
    
    
    func setTitle(title:String,subtitle:String){
        self.titleLabel.text = title
        self.subTitleLabel.text = subtitle
    }
    
    func setLinks(links:Scalar_JSON) {
        if let fb:String = links["facebook"] as? String {
            self.facebookLink = fb
        }
        
        if let twitter:String = links["twitter"] as? String {
            self.twitterLink = twitter
        }
        
        if let youtube:String = links["youtube"] as? String {
            self.youtubeLink = youtube
        }
    }
    
    func setSupperters(supporters:[UserModel]){
        self.supportersView.setSupprters(supporters: supporters)
    }
    
    @objc func socialAction(sender:UIButton){
        switch sender.tag {
        case 1:
            self.openLink(link: facebookLink)
        case 2:
            self.openLink(link: twitterLink)
        case 3:
            self.openLink(link: youtubeLink)
        default:
            self.openLink(link: facebookLink)
        }
    }
    
    @objc func moreAction(sender:UIButton) {
        let moreView = MoreView()
        moreView.delegate = self
        self.presentViewControllerAsPopover(viewController: moreView, from: sender)

    }
    
    func presentViewControllerAsPopover(viewController: UIViewController, from: UIView) {
      
        
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            viewController.modalPresentationStyle = .popover
            let viewPresentationController = viewController.popoverPresentationController
            if let presentationController = viewPresentationController {
                presentationController.delegate = self
                presentationController.permittedArrowDirections = .up
                presentationController.sourceView = from
                presentationController.sourceRect = from.bounds
            }
            let moreViewWidth = ("End conversation".localized(lang)).widthOfString(usingFont: UIFont.systemFont(ofSize: 13)) + 10
            viewController.preferredContentSize = CGSize(width: moreViewWidth, height: 80)
            
            topController.present(viewController, animated: true, completion: nil)
        }
        
        
    }
    
    func openLink(link:String){
        let validUrlString = link.hasPrefix("http") ? link:"http://\(link)"
        guard let url = URL(string: validUrlString) else { return }
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    func scrollViewDidScroll(scrollView:UIScrollView) {
        
        let offsetY = -(scrollView.contentOffset.y + scrollView.contentInset.top)
        if offsetY > 0 {
            let height = self.frame.height
//
            let bgView = self.viewWithTag(100)
            bgView!.frame.size.height = height + offsetY
        }
    }
}


extension HomeHeader: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}


extension HomeHeader: MoreViewDelegate {
    func close() {
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = (presentedViewController as? UINavigationController)!
                topController.dismiss(animated: true, completion: nil)
            }
            
        }
    }
    
    func end() {
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = (presentedViewController as? UINavigationController)!
                
                topController.dismiss(animated: true) {
                    Erxes.endSession()
                }
            }
            
        }
    }
}
