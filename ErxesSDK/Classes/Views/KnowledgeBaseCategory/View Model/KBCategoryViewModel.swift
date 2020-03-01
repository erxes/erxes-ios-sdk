//  
//  KBCategoryViewModel.swift
//  erxesiosdk
//
//  Created by Soyombo bat-erdene on 8/28/19.
//  Copyright © 2019 Soyombo bat-erdene. All rights reserved.
//

import Foundation
import Apollo
class KBCategoryViewModel {

    private let service: KBCategoryServiceProtocol

    private var model: KbModel = KbModel() {
        didSet {
          
        }
    }

    /// Count your data in model
    var count: Int = 0

    //MARK: -- Network checking

    /// Define networkStatus for check network connection
    var networkStatus = Reach().connectionStatus()

    /// Define boolean for internet status, call when network disconnected
    var isDisconnected: Bool = false {
        didSet {
            self.alertMessage = "No network connection. Please connect to the internet"
            self.internetConnectionStatus?()
        }
    }

    //MARK: -- UI Status

    /// Update the loading status, use HUD or Activity Indicator UI
    var isLoading: Bool = false {
        didSet {
            self.updateLoadingStatus?()
        }
    }

    /// Showing alert message, use UIAlertController or other Library
    var alertMessage: String? {
        didSet {
            self.showAlertClosure?()
        }
    }

    /// Define selected model
    var selectedObject: KbModel?

    //MARK: -- Closure Collection
    var showAlertClosure: (() -> ())?
    var updateLoadingStatus: (() -> ())?
    var internetConnectionStatus: (() -> ())?
    var serverErrorStatus: (() -> ())?
     var didGetData: ((_ model:KbModel) -> ())?

    init(withKBCategory serviceProtocol: KBCategoryServiceProtocol = KBCategoryService() ) {
        self.service = serviceProtocol

        NotificationCenter.default.addObserver(self, selector: #selector(self.networkStatusChanged(_:)), name: NSNotification.Name(rawValue: ReachabilityStatusChangedNotification), object: nil)
        Reach().monitorReachabilityChanges()

    }

    //MARK: Internet monitor status
    @objc func networkStatusChanged(_ notification: Notification) {
        self.networkStatus = Reach().connectionStatus()
    }

    //MARK: -- Example Func
    func knowledgeBaseCategoriesDetail(categoryId:String) {
        switch networkStatus {
        case .offline:
            self.isDisconnected = true
            self.internetConnectionStatus?()
        case .online:
            self.isLoading = true
            self.service.knowledgeBaseCategoriesDetail(categoryId: categoryId, success: { (data) in
                self.didGetData!(data)
                self.isLoading = false
            }) { (error) in
                print(error)
            }
        default:
            break
        }
    }

}

extension KBCategoryViewModel {

}
