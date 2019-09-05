//
//  SupporterView.swift
//  erxesiosdk
//
//  Created by Soyombo bat-erdene on 8/15/19.
//  Copyright © 2019 Soyombo bat-erdene. All rights reserved.
//

import UIKit
import SDWebImage

class AvatarView: UIImageView{
    override init(image: UIImage?) {
        super.init(image: image)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.frame.size.height / 2
        self.clipsToBounds = true
    }
}


class SupporterView: UIView {

    
    private var supporters = [UserModel]() {
        didSet{
            if supporters.count != 0 {
                for (i, supporter) in self.supporters.enumerated() {
                    let imageview = AvatarView(frame: CGRect(x: i + (60*i), y: 0, width: 50, height: 50))
                    self.addSubview(imageview)
                    imageview.sd_setImage(with: URL(string: (supporter.details?.avatar)!), placeholderImage:UIImage(named: "ic_avatar", in: Erxes.erxesBundle(), compatibleWith: nil))
                }
               
            }
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
    
    convenience init() {
        self.init(frame: .zero)
    }
    
    func setSupprters(supporters:[UserModel]){
        self.supporters = supporters
    }
    
    func didLoad() {
        //Place your initialization code here
        
        //I actually create & place constraints in here, instead of in
        //updateConstraints
   
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        //Custom manually positioning layout goes here (auto-layout pass has already run first pass)
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        
        //Disable this if you are adding constraints manually
        //or you're going to have a 'bad time'
        //self.translatesAutoresizingMaskIntoConstraints = false
        
        //Add custom constraint code here
    }

}
