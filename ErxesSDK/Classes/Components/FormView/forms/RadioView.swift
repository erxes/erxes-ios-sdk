//
//  RadioView.swift
//  Erxes iOS SDK
//
//  Created by soyombo bat-erdene on 5/15/20.
//  Copyright © 2020 Soyombo bat-erdene. All rights reserved.
//

import UIKit
import GDCheckbox


protocol RadioViewDelegate: class {
    func didSelectValue(value: String, sender:UIView)
}

class RadioView: UIView {

    
    weak var delegate: RadioViewDelegate?
    var value = String()
  
    

    private var options = [String?]() {
        didSet {
           

        }
    }

    private var buttons =  [GDCheckbox]()

    private var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)

        label.textColor = .black
        label.textAlignment = .left
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.sizeToFit()

        return label
    }()

     var subTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .gray
        label.textAlignment = .left
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.sizeToFit()

        return label
    }()

    private var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.spacing = 0
        return stackView
    }()

    var didTapHandler: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        didLoad()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        didLoad()
    }

    convenience init(options: [String?], title: String? = "", desc: String? = "") {
        self.init(frame: .zero)
      
        self.options = options
        self.titleLabel.text = title
        self.subTitleLabel.text = desc
        self.buildForm(options: options)
    }


    func didLoad() {
        self.addSubview(titleLabel)
        self.addSubview(subTitleLabel)
        self.addSubview(stackView)

    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(10)
            make.top.equalToSuperview().offset(10)
            if titleLabel.text?.count == 0 {
                make.height.equalTo(0)
            }
        }
        
        subTitleLabel.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(10)
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            if subTitleLabel.text?.count == 0 {
                make.height.equalTo(0)
            }
        }
        
        stackView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().inset(10)
            make.top.equalTo(subTitleLabel.snp.bottom).offset(10)
        }

    }

    private func buildForm(options: [String?]) {
        for (i,option) in options.enumerated() {
         
            let checkbox: GDCheckbox = {
                let checkBox = GDCheckbox()
                checkBox.animationDuration = 0.5
                checkBox.isRadioButton = true
                checkBox.showCheckMark = false
                checkBox.isOn = false
                checkBox.shouldAnimate = true
                checkBox.containerWidth = 2
            
                checkBox.containerColor = UIColor(hexString: uiOptions?.color ?? defaultColorCode)!
                checkBox.checkColor = UIColor(hexString: uiOptions?.color ?? defaultColorCode)!
                return checkBox
            }()

            let titleLabel: UILabel = {
                let label = UILabel()
                label.font = UIFont.systemFont(ofSize: 10)
                label.adjustsFontSizeToFitWidth = true
                label.text = option ?? ""
                label.sizeToFit()
                return label
            }()

            let container = UIView()
            self.stackView.addArrangedSubview(container)
            container.snp.makeConstraints { (make) in
                make.left.right.equalToSuperview()
                make.height.equalTo(30)
            }
            checkbox.tag = i + 1000
            buttons.append(checkbox)
            container.addSubview(checkbox)
            checkbox.addTarget(self, action: #selector(didSelectButton(sender:)), for: .touchUpInside)
            container.addSubview(titleLabel)
            if option == value {
                checkbox.isOn = true
            }
            checkbox.snp.makeConstraints { (make) in
                make.width.height.equalTo(20)
                make.left.equalToSuperview().offset(10)
                make.centerY.equalToSuperview()
            }
            titleLabel.snp.makeConstraints { (make) in
                make.left.equalTo(checkbox.snp.right).offset(16)
                make.right.equalToSuperview().inset(16)
                make.centerY.equalToSuperview()
                make.height.equalToSuperview()
            }
        }
        self.layoutSubviews()
    }


    override func updateConstraints() {
        super.updateConstraints()


    }
    
    @objc func didSelectButton(sender: GDCheckbox) {
        sender.isOn = true
        self.value = self.options[sender.tag - 1000]!
        delegate?.didSelectValue(value: self.value, sender: self)
        for btn in buttons{
            if btn.tag != sender.tag{
                btn.isOn = false
            }
        }
    }



}



