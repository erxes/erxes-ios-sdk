//
//  ViewController.swift
//  ErxesSDK
//
//  Created by devpurevee on 05/09/2018.
//  Copyright (c) 2018 devpurevee. All rights reserved.
//

import UIKit
import ErxesSDK

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func btnClick(){
        
        var messengerData = [String:Any]()
        messengerData["user data"] = "what ever you want"
        Erxes.start(email: "", phone: "", data: messengerData)
        
    }

    @IBAction func close(){
        Erxes.endSession(completionHandler: {
            // do your stuff
            
        })
        
        Erxes.endSession()
        
    }
    
}
