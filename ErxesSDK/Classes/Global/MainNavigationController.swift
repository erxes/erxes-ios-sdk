//
//  MainNavigationController.swift
//  ErxesSDK
//
//  Created by Soyombo bat-erdene on 2/19/20.
//  Copyright © 2020 Soyombo bat-erdene. All rights reserved.
//

import UIKit

class MainNavigationController: UINavigationController {

        var viewTranslation = CGPoint(x: 0, y: 0)

        var panGesture = UIPanGestureRecognizer()
        
        override func viewDidLoad() {
            super.viewDidLoad()
            panGesture = UIPanGestureRecognizer(target: self, action: #selector(handleDismiss(sender:)))
            view.addGestureRecognizer(panGesture)
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
                    print(self.viewTranslation.y)
                })
                
            case .ended:
                if viewTranslation.y < 200 {
                    UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                        self.view.transform = .identity
                    })
                } else {
                    dismiss(animated: true, completion: nil)
                }
            default:
                break
            }
        }
    }

