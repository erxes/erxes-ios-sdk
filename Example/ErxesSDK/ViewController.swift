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
        
        //if you are Saas user you can setup as following
        //        Erxes.setupSaas(companyName: "companyName", brandId: "brandCode")
        
        //if you are OpenSource user you can setup as following
//
//        Erxes.setup(erxesApiUrl: "api url", brandId: "brand id", email: "optional", phone: "optional", code: "optional", data: ["key":"value"], companyData: ["key": "value"])
        
        Erxes.setup(organizationName: "ari", brandId: "Q6sMfg", email: "soko@gmail.com", phone: "99331924", code: "optional", data: ["key":"value"], companyData: ["key": "value"])
//        Erxes.setup(erxesApiUrl: "https://api.office.erxes.io", brandId: "5fkS4v")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func btnClick(){
        Erxes.start()
    }
}
