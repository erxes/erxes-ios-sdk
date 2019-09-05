//Spinner.swift
/*
 * TokenUI
 * Created by penumutchu.prasad@gmail.com on 06/04/19
 * Is a product created by abnboys
 * For the TokenUI in the TokenUI
 
 * Here the permission is granted to this file with free of use anywhere in the IOS Projects.
 * Copyright © 2018 ABNBoys.com All rights reserved.
*/

import UIKit

/**
 A Spinner that shows at the center of the window, and the spinner appears on window
 */
struct Spinner {
    
    private var containerView = UIView()
    private var progressView = UIView()
    private var activityIndicator = UIActivityIndicatorView()
    
    init() {
        
    }
    
    /**
     it displays an activity indicator view on center of the window
     */
    func show() {
        
        guard let window = UIApplication.shared.keyWindow else { return }
        
        containerView.frame = window.frame
        containerView.center = window.center
        containerView.backgroundColor = UIColor.init(white: 0.75, alpha: 0.75)
        
        progressView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        progressView.center = window.center
        progressView.backgroundColor = #colorLiteral(red: 0.4039215686, green: 0.4666666667, blue: 0.7215686275, alpha: 1)
        progressView.clipsToBounds = true
        progressView.layer.cornerRadius = 10
        
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        activityIndicator.style = .whiteLarge
        activityIndicator.center = CGPoint(x: progressView.bounds.width / 2, y: progressView.bounds.height / 2)
        activityIndicator.hidesWhenStopped = true
        
        progressView.addSubview(activityIndicator)
        containerView.addSubview(progressView)
        activityIndicator.startAnimating()
        
        window.addSubview(containerView)
    }
    
    /**
     it displays the Activity Indicator view in the passed view, with passed bounds
     - Parameter inView: The view need to show the activity
     - Parameter bounds: Bounds to show the activity
     */
    func showInView(_ inView: UIView, inBounds bounds: CGRect) {
        
        containerView.frame = bounds
        containerView.center = inView.center
        containerView.backgroundColor = UIColor.init(white: 0.75, alpha: 0.75)
        
        progressView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        progressView.center = inView.center
        progressView.backgroundColor = #colorLiteral(red: 0.4039215686, green: 0.4666666667, blue: 0.7215686275, alpha: 1)
        progressView.clipsToBounds = true
        progressView.layer.cornerRadius = 10
        
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        activityIndicator.style = .whiteLarge
        activityIndicator.center = CGPoint(x: progressView.bounds.width / 2, y: progressView.bounds.height / 2)
        
        progressView.addSubview(activityIndicator)
        containerView.addSubview(progressView)
        activityIndicator.startAnimating()
        
        inView.addSubview(containerView)
    }
    
    /** it removes the presented activity indicator from the window */
    func hide(_ completion: (() -> (Void))? = nil) {
        if activityIndicator.isAnimating {
            activityIndicator.stopAnimating()
        }
        containerView.removeFromSuperview()
        completion?()
    }
    
}
