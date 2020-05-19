//
//  EmbedWebViewController.swift
//  Erxes iOS SDK
//
//  Created by soyombo bat-erdene on 5/14/20.
//  Copyright © 2020 Soyombo bat-erdene. All rights reserved.
//

import UIKit
import WebKit

class EmbedWebViewController: AbstractViewController {

    let header = NormalHeaderView()
    
    var data: WebsiteApp?
    
    var webViewContainer: UIView = {
       let view = UIView()
    
        return view
    }()
    
    let webView = WKWebView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.topOffset = 60
        self.containerView.addSubview(header)
        self.containerView.addSubview(webViewContainer)
        self.containerView.addSubview(webView)
        header.setTitles(title: data?.credentials?.description)
        header.backButtonHandler = {
            self.navigationController?.popViewController(animated: true)
        }
        
        header.moreButtonHandler = {
            self.moreAction(sender: self.header.moreButton)
        }
        
//        self.webViewContainer = webView
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard let urlString = data?.credentials?.url else {
            return
        }
        
        let validUrlString = urlString.hasPrefix("http") ? urlString : "http://\(urlString)"
        let url = URL(string: validUrlString);
        let request = URLRequest(url: url!)
        webView.load(request)
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        header.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(64)
        }
        
        webView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(header.snp.bottom)
        }
    }
}


extension EmbedWebViewController: UIWebViewDelegate {
    func webViewDidFinishLoad(_ webView: UIWebView) {
        
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        
    }
}
