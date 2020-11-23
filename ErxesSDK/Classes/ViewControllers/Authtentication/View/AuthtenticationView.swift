//  
//  AuthtenticationView.swift
//  Erxes iOS SDK
//
//  Created by soyombo bat-erdene on 4/30/20.
//  Copyright © 2020 Soyombo bat-erdene. All rights reserved.
//

import UIKit

class AuthtenticationView: AbstractViewController {

    // OUTLETS HERE

    let header = NormalHeaderView()
    var textField: UITextField = {
        let textfield = UITextField()
        
        textfield.placeholder = "email@domain.com".localized(lang)
        let leftPadding = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 40))
        textfield.leftViewMode = .always
        textfield.leftView = leftPadding
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        button.setImage(UIImage.erxes(with: .chevron, textColor: .white), for: .normal)
        button.addTarget(self, action: #selector(loginAction), for: .touchUpInside)
        button.backgroundColor = UIColor(hexString: uiOptions?.color ?? defaultColorCode)
        let rightView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        rightView.addSubview(button)
        textfield.rightViewMode = .always
        textfield.rightView = rightView
        textfield.rightView?.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        textfield.layer.cornerRadius = 6
        textfield.layer.borderColor = UIColor.lightGray.cgColor
        textfield.layer.borderWidth = 0.75
        textfield.clipsToBounds = true
        textfield.autocapitalizationType = .none
        textfield.autocorrectionType = UITextAutocorrectionType.no
        
        return textfield
    }()
    
    
    
    lazy var segmentedControl: SegmentedControl = {
        let control = SegmentedControl()
        
        control.delegate = self
        self.containerView.addSubview(control)
        
        control.snp.makeConstraints({ (make) in
            make.top.equalTo(self.header.snp.bottom).offset(15)
            make.left.equalToSuperview().offset(10)
            make.height.equalTo(40)
            make.width.equalTo(120)
        })
        return control
    }()
    
    // VARIABLES HERE
    var viewModel = AuthtenticationViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        header.backButton.isHidden = true
        header.setTitles(title: "Contact".localized(lang), subTitle: "Give us your contact information".localized(lang))
        header.moreButtonHandler = {
            self.moreAction(sender: self.header.moreButton)
        }
        containerHeight = 240
        self.containerView.addSubview(header)
        segmentedControl.setButtonTitles(buttonTitles: ["Email".localized(lang), "SMS".localized(lang)])
        self.containerView.addSubview(textField)
        textField.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHandler), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHandler), name: UIResponder.keyboardWillHideNotification, object: nil)
        self.setupViewModel()
    }
    
    fileprivate func setupViewModel() {

        self.viewModel.showAlertClosure = {
            let alert = self.viewModel.alertMessage ?? ""
            print(alert)
        }
        
        self.viewModel.updateLoadingStatus = {
            if self.viewModel.isLoading {
                print("LOADING...")
            } else {
                 print("DATA READY")
            }
        }

        self.viewModel.internetConnectionStatus = {
            print("Internet disconnected")
            // show UI Internet is disconnected
        }

        self.viewModel.serverErrorStatus = { error in
            print("Server Error / Unknown Error")
            // show UI Server is Error
        }

        self.viewModel.didAuthenticate = { data in
            UserDefaults().set(true, forKey: "authenticated")
            UserDefaults().synchronize()
            let controller = HomeView()
            self.navigationController?.pushViewController(controller, animated: true)
        }

    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        header.snp.makeConstraints { (make) in
            make.height.equalTo(64)
            make.left.right.top.equalToSuperview()
            
        }
        textField.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(10)
            make.height.equalTo(40)
            make.top.equalTo(self.segmentedControl.snp.bottom).offset(20)
        }
    }
    
    @objc func keyboardHandler(notification: NSNotification) {
        let info = notification.userInfo!
        
        var keyboardFrame: CGRect
        if let keyBoardInfo = info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            keyboardFrame = keyBoardInfo.cgRectValue
        } else {
            return
        }
        
        
        if notification.name == UIResponder.keyboardWillShowNotification {
            UIView.animate(withDuration: 0.3) {
                
                self.containerView.snp.remakeConstraints({ (make) in
                    make.left.right.equalToSuperview()
                    make.height.equalTo(240)
                    make.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-keyboardFrame.size.height)
                })
                self.containerView.layoutSubviews()
                
            }
            
        }
        if notification.name == UIResponder.keyboardWillHideNotification {
            
        }
        
        if notification.name == UIResponder.keyboardDidShowNotification {
            
        }
        
        self.header.layoutSubviews()
    }
    
    @objc func loginAction() {
        if segmentedControl.selectedIndex == 0 {
            if self.textField.validate([isEmailValid]) {
                self.textField.layer.borderColor = UIColor.lightGray.cgColor
                self.viewModel.authenticate(type: "email", value: textField.text!)
            } else {
                self.textField.layer.borderColor = UIColor.red.cgColor
            }
        } else {
            if self.textField.validate([isPhoneNumberValid]) {
                self.textField.layer.borderColor = UIColor.lightGray.cgColor
                self.viewModel.authenticate(type: "phone", value: textField.text!)
            } else {
                self.textField.layer.borderColor = UIColor.red.cgColor
            }
        }
        
    }
    
}


extension AuthtenticationView: SegmentedControlDelegate {
    func changeToIndex(index: Int) {
        self.textField.text = ""
        self.textField.layer.borderColor = UIColor.lightGray.cgColor
        if index == 1 {
            textField.placeholder = "phone number".localized(lang)
            textField.keyboardType = .decimalPad
        } else if index == 0 {
            textField.keyboardType = .emailAddress
            textField.placeholder = "email@domain.com".localized(lang)
        }
        textField.reloadInputViews()
    }
}

extension AuthtenticationView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.loginAction()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        
        let start = textField.position(from: textField.beginningOfDocument, offset: range.location)
        
        let cursorOffset = textField.offset(from: textField.beginningOfDocument, to: start!) + string.count
        
        
        textField.text = (textField.text as NSString?)!.replacingCharacters(in: range, with: string)
        
        let newCursorPosition = textField.position(from: textField.beginningOfDocument, offset:cursorOffset)
        
        let newSelectedRange = textField.textRange(from: newCursorPosition!, to: newCursorPosition!)
        
        textField.selectedTextRange = newSelectedRange
        
        return false
    }
}



