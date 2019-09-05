//
//  ChatHeader.swift
//  erxesiosdk
//
//  Created by Soyombo bat-erdene on 8/21/19.
//  Copyright © 2019 Soyombo bat-erdene. All rights reserved.
//

import UIKit

class ChatHeader: UIView {
    
    private var isCollapsed = false
    
    
    var rightButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "ic_more"),for:.normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        button.addTarget(self, action: #selector(moreAction(sender:)), for: .touchUpInside)
        return button
    }()
    
    
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .white
        label.textAlignment = .center
        //        label.numberOfLines = 0
        //        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.sizeToFit()
        
        return label
    }()
    
    var subTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 1
        //        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.sizeToFit()
        
        return label
    }()
    
    var suppertersView: SupporterView = {
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
        self.clipsToBounds = false
        //I actually create & place constraints in here, instead of in
        //updateConstraints
        let image = UIImage(named: "pattern")
        let bgView = UIImageView()
        bgView.tag = 100
        bgView.backgroundColor = themeColor
        bgView.image = image
        bgView.contentMode = UIView.ContentMode.scaleAspectFill
        
        self.addSubview(bgView)
        self.addSubview(titleLabel)
        self.addSubview(subTitleLabel)
        self.addSubview(suppertersView)
        self.addSubview(rightButton)
        
        bgView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
    }
    
    
    func setSupperters(supporters:[UserModel]){
        self.suppertersView.setSupprters(supporters: supporters)
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let titleHeight = titleLabel.frame.size.height
        
        if subTitleLabel.text?.count == 0 || subTitleLabel.text?.count == nil {
            titleLabel.snp.makeConstraints { (make) in
                
                make.top.equalToSuperview().offset(32 - titleHeight/2)
                //                make.left.equalToSuperview().offset(50)
                //                make.right.equalToSuperview().offset(-50)
                make.width.equalTo(SCREEN_WIDTH - 100)
                make.centerX.equalToSuperview()
            }
        }else {
            
            titleLabel.snp.makeConstraints { (make) in
                make.top.equalToSuperview().offset(10)
                make.width.equalTo(SCREEN_WIDTH - 100)
                make.centerX.equalToSuperview()
                //                make.left.equalToSuperview().offset(50)
                //                make.right.equalToSuperview().offset(-50)
            }
        }
        
        subTitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.left.equalToSuperview().offset(50)
            make.right.equalToSuperview().offset(-50)
            if subTitleLabel.text?.count != 0 {
                make.height.equalTo(20)
            }
        }
        
        suppertersView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.height.equalTo(50)
            make.top.equalTo(subTitleLabel.snp.bottom).offset(13)
        }
        
        
        rightButton.snp.makeConstraints { (make) in
            make.width.height.equalTo(40)
            make.top.equalToSuperview().offset(12)
            make.right.equalToSuperview().offset(-8)
        }
        
        
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        
        //Disable this if you are adding constraints manually
        //or you're going to have a 'bad time'
        //self.translatesAutoresizingMaskIntoConstraints = false
        
        //Add custom constraint code here
        
        
    }
    
    func fixHeight(){
        
        var totalHeight = titleLabel.frame.size.height + 90 + subTitleLabel.frame.size.height
        if totalHeight == 90 {
            totalHeight = 150
        }
        
        self.snp.remakeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(totalHeight)
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
    
    @objc func closeAction(){
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = (presentedViewController as? UINavigationController)!
                topController.dismiss(animated: true, completion: nil)
            }
            
        }
    }
    
    @objc func endAction(){
        
    }
    
    
    func scrollViewDidScroll(scrollView:UIScrollView) {
        
        let height = self.frame.height
        if (scrollView.contentOffset.y > (scrollView.contentSize.height - scrollView.frame.size.height)) {
            let limit = scrollView.contentSize.height - scrollView.frame.size.height
            
            let offsetY = scrollView.contentOffset.y + scrollView.contentInset.bottom
         
            let change = offsetY - limit
            if !isCollapsed {
                if height > 64 {
                    self.frame.size.height = height - change
                }else {
                    isCollapsed = true
                    self.frame.size.height = 64
                }
            }else {
                self.frame.size.height = 64
            }
            
            
            
        }
        
    }
    
}


extension ChatHeader: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}


extension ChatHeader: MoreViewDelegate {
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
