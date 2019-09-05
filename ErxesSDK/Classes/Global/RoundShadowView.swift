//
//  RoundedShadowView.swift
//  erxesiosdk
//
//  Created by Soyombo bat-erdene on 8/19/19.
//  Copyright © 2019 Soyombo bat-erdene. All rights reserved.
//

import UIKit


class RoundShadowView: UIView {
    
    let containerView = UIView()
    let cornerRadius: CGFloat = 6.0
    private var shadowLayer: CAShapeLayer!
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layoutView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func layoutView() {
        
        // set the shadow of the view's layer
//        self.dropShadow(color: .gray, opacity: 1, offSet: CGSize(width: 2, height: 2), radius: 3, scale: true)
        
        // set the cornerRadius of the containerView's layer
        containerView.layer.cornerRadius = cornerRadius
        containerView.layer.masksToBounds = true
        containerView.roundCorners(corners: [.topRight,.topLeft], radius: 8)
        addSubview(containerView)
        
        //
        // add additional views to the containerView here
        //
        
        // add constraints
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        // pin the containerView to the edges to the view
        containerView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        containerView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if shadowLayer == nil {
            shadowLayer = CAShapeLayer()
            
            shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
            shadowLayer.fillColor = UIColor.white.cgColor
            
            shadowLayer.shadowColor = UIColor.init(hexString: "#ededed")?.cgColor
            shadowLayer.shadowPath = shadowLayer.path
            shadowLayer.shadowOffset = CGSize(width: -2, height: 2)
            shadowLayer.shadowOpacity = 1
            shadowLayer.shadowRadius = 3
            shadowLayer.shouldRasterize = true
            layer.insertSublayer(shadowLayer, at: 0)
        }
    }
}
