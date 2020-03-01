//
//  AbstractViewController.swift
//  ErxesSDK
//
//  Created by Soyombo bat-erdene on 2/19/20.
//  Copyright © 2020 Soyombo bat-erdene. All rights reserved.
//

import UIKit
import SnapKit

class AbstractViewController: UIViewController {

    var topOffset = 0 {
        didSet {
            containerView.snp.makeConstraints { (make) in
                make.left.right.bottom.equalToSuperview()
                make.top.equalToSuperview().offset(topOffset)

            }
            topLine.snp.makeConstraints { (make) in
                make.centerX.equalToSuperview()
                make.bottom.equalTo(containerView.snp.top).offset(-4)
                make.height.equalTo(3)
                make.width.equalToSuperview().dividedBy(3)
            }
        }
    }
    var containerHeight = 0 {
        didSet {
            containerView.snp.makeConstraints { (make) in
                make.left.right.bottom.equalToSuperview()
                make.height.equalTo(containerHeight)

            }
            topLine.snp.makeConstraints { (make) in
                make.centerX.equalToSuperview()
                make.bottom.equalTo(containerView.snp.top).offset(-4)
                make.height.equalTo(3)
                make.width.equalToSuperview().dividedBy(3)
            }
        }
    }


    let backgroundView: UIView = {
        let view = UIView()
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurEffectView)
        return view
    }()
    let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()

    let topLine: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 1.5
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBackgroundView()
        view.addSubview(topLine)
        view.addSubview(containerView)



    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
    }

}



// MARK: UI/UX Functions
extension AbstractViewController {
    fileprivate func setupBackgroundView() {
        view.backgroundColor = .clear
        view.addSubview(backgroundView)
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        backgroundView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        backgroundView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }
}
