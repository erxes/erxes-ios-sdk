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

//        setupBackgroundView()
        view.addSubview(topLine)
        view.addSubview(containerView)
        self.navigationController?.delegate = self



    }

    @objc func moreAction(sender: UIButton) {
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
            let moreViewWidth = ("End conversation".localized(lang)).widthOfString(usingFont: UIFont.systemFont(ofSize: 13)) + 50
            viewController.preferredContentSize = CGSize(width: moreViewWidth, height: 80)

            topController.present(viewController, animated: true, completion: nil)
        }


    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        containerView.roundCorners(corners: [.topLeft, .topRight], radius: 8)
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


extension AbstractViewController: UINavigationBarDelegate {
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
}


extension AbstractViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}

    extension AbstractViewController: MoreViewDelegate {
        func close() {
            if var topController = UIApplication.shared.keyWindow?.rootViewController {
                while let presentedViewController = topController.presentedViewController {
                    topController = (presentedViewController as? UINavigationController)!
                    topController.dismiss(animated: true, completion: nil)
                    let nav = self.navigationController as? MainNavigationController
                    nav!.backgroundView.removeFromSuperview()
                }

            }
        }

        func end() {
            if var topController = UIApplication.shared.keyWindow?.rootViewController {
                while let presentedViewController = topController.presentedViewController {
                    topController = (presentedViewController as? UINavigationController)!

                    topController.dismiss(animated: true) {
                        Erxes.endSession()
                        let nav = self.navigationController as? MainNavigationController
                        nav!.backgroundView.removeFromSuperview()
                    }
                }

            }
        }
    }
