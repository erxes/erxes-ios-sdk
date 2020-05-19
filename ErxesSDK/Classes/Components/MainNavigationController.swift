//
//  MainNavigationController.swift
//  Erxes iOS SDK
//
//  Created by soyombo bat-erdene on 4/30/20.
//  Copyright © 2020 Soyombo bat-erdene. All rights reserved.
//

import UIKit

class MainNavigationController: UINavigationController {

    var viewTranslation = CGPoint(x: 0, y: 0)

    var panGesture = UIPanGestureRecognizer()

    let backgroundView: UIView = {
        let view = UIView()
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurEffectView)
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(handleDismiss(sender:)))
        view.addGestureRecognizer(panGesture)


        let presentingViewController = self.presentingViewController
        presentingViewController?.view.addSubview(backgroundView)
        backgroundView.frame = presentingViewController?.view.bounds as! CGRect



    }

}

// MARK: Drag dismiss function
extension MainNavigationController {
    @objc func handleDismiss(sender: UIPanGestureRecognizer) {
        switch sender.state {
            
        case .changed:
            viewTranslation = sender.translation(in: view)
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.view.transform = CGAffineTransform(translationX: 0, y: self.viewTranslation.y)
            })
            self.backgroundView.alpha = 1 - (self.view.frame.origin.y / SCREEN_HEIGHT)
        case .ended:
            if viewTranslation.y < 200 {
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    self.view.transform = .identity
                })
            } else {
                dismiss(animated: true, completion: nil)
                backgroundView.alpha = 0.0
            }
        default:
            break
        }
    }
}
