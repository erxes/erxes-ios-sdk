//
//  ImageCell.swift
//  erxesiosdk
//
//  Created by Soyombo bat-erdene on 8/21/19.
//  Copyright © 2019 Soyombo bat-erdene. All rights reserved.
//

import UIKit

class ImageCell: BaseCells {
    static let identifier = String(describing: ImageCell.self)

    var indicator = UIActivityIndicatorView()

    override func layoutSubviews() {
        super.layoutSubviews()
     
    }

    override func updateView() {
        super.updateView()
        indicator.hidesWhenStopped = true
        indicator.style = .whiteLarge
        indicator.color = .black
//        imageView.layer.cornerRadius = 8
        imageView.layer.borderWidth = 5
        self.contentView.addSubview(indicator)
//        self?.configs = configs.map { ($0?.fragments.notificationConf)! }
        if let attachments = self.model?.attachments, attachments.count > 0 {


            if let attachment = attachments.first {
                
                if let file = attachment {
                    if let url:String = file.url {
                        if url.count != 0 {
                            let imageURL = URL(string: url)
                            indicator.startAnimating()
                            imageView.sd_setImage(with: imageURL, placeholderImage: UIImage(named: "placeholder", in: Erxes.erxesBundle(), compatibleWith: nil), completed: { image, error, cacheType, imageUrl in
                                self.indicator.stopAnimating()
                            })
                        }
                    }
                }
               
            }

        }

        if ((self.model?.customerId) != nil) {
           setupCustomerLayout()
        } else {
           setupAdminLayout()
        }
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(showImage))
        
        tapRecognizer.numberOfTapsRequired = 1
        tapRecognizer.numberOfTouchesRequired = 1
        self.imageView.addGestureRecognizer(tapRecognizer)
    }
    
    @objc func showImage(){
        let viewer = ImageViewer.init(attachmentUrl: (self.model?.attachments?.first?!.url)!)
        viewer.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            topController.view.addSubview(viewer)
        }
        
    }
    
    
    private func setupCustomerLayout(){
        imageView.layer.borderColor = themeColor?.cgColor
        dateLabel.textAlignment = .right
        dateLabel.snp.remakeConstraints { (make) in
            make.right.equalToSuperview().offset(-5)
            make.bottom.equalTo(contentView.snp.bottom).offset(0)
            make.height.equalTo(20)
            make.width.equalTo(50)
        }
        imageView.snp.remakeConstraints { (make) in
            make.right.equalToSuperview().offset(-5)
            make.width.equalTo(150)
            make.height.equalTo(150)
        }
        
        
        indicator.snp.makeConstraints { (make) in
            make.edges.equalTo(imageView.snp.edges)
        }
        
        imageView.roundCorners(corners: [.topLeft,.topRight,.bottomLeft], radius: 8)
   
    }
    
    private func setupAdminLayout(){
        imageView.layer.borderColor = UIColor.init(hexString: "#e7e8ea")?.cgColor
        dateLabel.textAlignment = .left
        
       
        
        dateLabel.snp.remakeConstraints { (make) in
            make.left.equalToSuperview().offset(40)
            make.bottom.equalTo(contentView.snp.bottom).offset(0)
            make.height.equalTo(20)
            make.width.equalTo(50)
        }
        imageView.snp.remakeConstraints { (make) in
            make.left.equalToSuperview().offset(40)
            make.width.equalTo(150)
            make.height.equalTo(150)
        }
        
        avatarView.snp.remakeConstraints { (make) in
            make.left.equalTo(contentView.snp.left).offset(5)
            make.bottom.equalTo(imageView)
            make.width.height.equalTo(30)
        }
        
        
        indicator.snp.makeConstraints { (make) in
            make.edges.equalTo(imageView.snp.edges)
        }
        
        imageView.roundCorners(corners: [.topLeft,.topRight,.bottomRight], radius: 8)
        self.contentView.bringSubviewToFront(imageView)
    }

    override func layoutView() {

    }
}
