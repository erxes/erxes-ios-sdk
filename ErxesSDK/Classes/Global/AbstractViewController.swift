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
        self.navigationController?.delegate = self


    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.navigationController?.delegate = self
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


extension AbstractViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController,
                              animationControllerFor operation: UINavigationController.Operation,
                              from fromVC: UIViewController,
                              to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {

        //INFO: use UINavigationControllerOperation.push or UINavigationControllerOperation.pop to detect the 'direction' of the navigation

        class FadeAnimation: NSObject, UIViewControllerAnimatedTransitioning {
            func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
                return 0.5
            }

            func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
                let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
                if let vc = toViewController {
                    transitionContext.finalFrame(for: vc)
                    transitionContext.containerView.addSubview(vc.view)
                    vc.view.alpha = 0.0
                    UIView.animate(withDuration: self.transitionDuration(using: transitionContext),
                    animations: {
                        vc.view.alpha = 1.0
                    },
                    completion: { finished in
                        transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                    })
                } else {
                    NSLog("Oops! Something went wrong! 'ToView' controller is nill")
                }
            }
        }

        return FadeAnimation()
    }
}
