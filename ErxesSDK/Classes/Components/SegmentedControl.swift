//
//  SegmentedControl.swift
//  erxesiosdk
//
//  Created by Soyombo bat-erdene on 8/16/19.
//  Copyright © 2019 Soyombo bat-erdene. All rights reserved.
//

import UIKit


protocol SegmentedControlDelegate: class {
    func changeToIndex(index: Int)
}

class SegmentedControl: UIView {
    private var buttonTitles: [String]!
    private var buttons: [UIButton]!
    private var selectorView: UIView!

    var textColor: UIColor = .black

    var selectorViewColor: UIColor = UIColor(hexString: "#5629B6")! {
        didSet {
            selectorView.backgroundColor = selectorViewColor
        }
    }
    var selectorTextColor: UIColor = UIColor(hexString: "#5629B6")!

    weak var delegate: SegmentedControlDelegate?

    public private(set) var selectedIndex: Int = 0

    convenience init(frame: CGRect, buttonTitle: [String]) {
        self.init(frame: frame)
        self.buttonTitles = buttonTitle
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.backgroundColor = UIColor.white
        updateView()
    }

    func setButtonTitles(buttonTitles: [String]) {
        self.buttonTitles = buttonTitles
        self.updateView()
    }

    func setIndex(index: Int) {
        buttons.forEach({ $0.setTitleColor(textColor, for: .normal) })
        let button = buttons[index]
        selectedIndex = index
        self.buttonAction(sender: button)

    }

    @objc func buttonAction(sender: UIButton) {
        for (buttonIndex, btn) in buttons.enumerated() {
            btn.setTitleColor(textColor, for: .normal)
            if btn == sender {
                let selectorPosition = frame.width / CGFloat(buttonTitles.count) * CGFloat(buttonIndex)
                selectedIndex = buttonIndex
                delegate?.changeToIndex(index: selectedIndex)
                UIView.animate(withDuration: 0.3) {
                    self.selectorView.frame.origin.x = selectorPosition
                }
                btn.setTitleColor(selectorTextColor, for: .normal)

            }
        }
    }


}

//Configuration View
extension SegmentedControl {
    private func updateView() {

        createButton()
        configSelectorView()
        configStackView()


    }

    private func configStackView() {
        let stack = UIStackView(arrangedSubviews: buttons)
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fillEqually
        addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        stack.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        stack.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        stack.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true

        
       
    }

    private func configSelectorView() {
        let selectorWidth = frame.width / CGFloat(self.buttonTitles.count)
        selectorView = UIView(frame: CGRect(x: 0, y: self.frame.height, width: selectorWidth, height: 2))
        selectorView.backgroundColor = selectorViewColor
        addSubview(selectorView)
    }

    private func createButton() {
        buttons = [UIButton]()
        buttons.removeAll()
        subviews.forEach({ $0.removeFromSuperview() })
        for buttonTitle in buttonTitles {
            let button = UIButton(type: .system)
            button.setTitle(buttonTitle, for: .normal)
            button.addTarget(self, action: #selector(SegmentedControl.buttonAction(sender:)), for: .touchUpInside)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            button.setTitleColor(textColor, for: .normal)

            buttons.append(button)
        }
        buttons[0].setTitleColor(selectorTextColor, for: .normal)
    }


}
