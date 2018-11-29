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
        
        var data = [String : Any]()
        data["firstName"] = "Altantgerel"
        data["lastName"] = "Purev-Yondon"
        
//        Erxes.startWithUserEmail(email: "test@test.com")
        Erxes.start(email: "purevyondon.a@nmma.co", phone: "88019634", data: data)
    }

}
