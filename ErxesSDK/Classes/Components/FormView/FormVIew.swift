//
//  FormVIew.swift
//  Erxes iOS SDK
//
//  Created by soyombo bat-erdene on 5/14/20.
//  Copyright © 2020 Soyombo bat-erdene. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialTextControls_FilledTextFields
import MaterialComponents.MaterialTextControls_FilledTextAreas


class FormVIew: UIView {


    var submissions = [FieldValueInput?]()
    var thankMessage = String()
    var textFields = [UITextField]()
    var currentTag = Int()

    var didTapOpenFile: (() -> Void)?

    var errors = [FieldError]() {
        didSet {
            reloadView()

            guard let fields = form.fields?.compactMap({ $0?.fragments.fieldModel }) else { return }
            self.buildForm(fields: fields)
        }
    }
    private var form = FormModel() {
        didSet {
            reloadView()

            guard let fields = form.fields?.compactMap({ $0?.fragments.fieldModel }) else { return }
            self.buildForm(fields: fields)

        }
    }

    var didTapHandler: (() -> Void)?

    var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)

        label.textColor = .black
        label.textAlignment = .left
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.sizeToFit()

        return label
    }()

    var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)

        label.textColor = .lightGray
        label.textAlignment = .left
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.sizeToFit()

        return label
    }()

    var button: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(hexString: uiOptions?.color ?? defaultColorCode)
        button.layer.cornerRadius = 8
        button.setTitleColor(.white, for: .normal)
        button.layer.shadowColor = UIColor.lightGray.cgColor
        button.layer.shadowOffset = CGSize(width: 3, height: 3)
        button.layer.shadowOpacity = 0.7
        button.layer.shadowRadius = 4.0
        return button
    }()


    private var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.spacing = 30.0
        return stackView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        didLoad()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        didLoad()
    }

    convenience init(form: FormModel) {
        self.init(frame: .zero)
        self.form = form
    }

    func reloadView() {

        titleLabel.text = form.title

        titleLabel.snp.makeConstraints { (make) in

            if titleLabel.text?.count == 0 {
                make.top.equalToSuperview()
            } else {
                make.top.equalToSuperview().offset(16)
            }
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
        }

        descriptionLabel.text = form.description
        descriptionLabel.snp.makeConstraints { (make) in

            if descriptionLabel.text?.count == 0 {
                make.top.equalTo(titleLabel.snp.bottom)
            } else {
                make.top.equalTo(titleLabel.snp.bottom).offset(10)
            }

            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
        }



        button.setTitle(form.buttonText, for: .normal)


    }

    func didLoad() {

        self.backgroundColor = .white
        self.layer.cornerRadius = 10
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOffset = CGSize(width: 3, height: 3)
        self.layer.shadowOpacity = 0.7
        self.layer.shadowRadius = 4.0

        self.addSubview(titleLabel)
        self.addSubview(descriptionLabel)
        self.addSubview(button)
        self.addSubview(stackView)
    }

    override func layoutSubviews() {
        super.layoutSubviews()


        titleLabel.snp.makeConstraints { (make) in

            if titleLabel.text?.count == 0 {
                make.top.equalToSuperview()
            } else {
                make.top.equalToSuperview().offset(16)
            }
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
        }

        descriptionLabel.snp.makeConstraints { (make) in

            if descriptionLabel.text?.count == 0 {
                make.top.equalTo(titleLabel.snp.bottom)
            } else {
                make.top.equalTo(titleLabel.snp.bottom).offset(10)
            }

            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
        }

        stackView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(descriptionLabel.snp.bottom).offset(16)
        }


        button.snp.makeConstraints { (make) in
            make.top.equalTo(stackView.snp.bottom).offset(16)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.height.equalTo(40)
            if button.isHidden {
                make.height.equalTo(0)
            }
            make.bottom.equalToSuperview().inset(16)
        }

    }

    override func updateConstraints() {
        super.updateConstraints()

    }


    func setData(form: FormModel) {
        self.form = form
    }

    func fileUploadFinished(file: AttachmentInput) {
        
        let textField = self.stackView.viewWithTag(currentTag) as? MDCFilledTextField
        if let mimeType = file.type {
            textField?.text = file.name + ": \(mimeType ?? "")"
        } else {
            textField?.text = file.name
        }

        guard let field = self.form.fields?.compactMap({ $0?.fragments.fieldModel })[textField!.tag] else { return }
        let valueInput = FieldValueInput(_id: field._id, type: field.type, validation: field.validation, text: field.text, value: ["url":file.url])

        if let index = self.submissions.firstIndex(where: { $0?._id == field._id }) {
            self.submissions[index] = valueInput
        }
    }


    func buildForm(fields: [FieldModel]) {

        stackView.removeAllArrangedSubviews()
        submissions.removeAll()
        for (i, field) in fields.enumerated() {
            let valueInput = FieldValueInput(_id: field._id, type: field.type, validation: field.validation, text: field.text, value: nil)
            self.submissions.append(valueInput)
            switch field.type {

            case "select":
                let textField = MDCFilledTextField()
                let isRequired = field.isRequired
                textField.label.text = (isRequired ?? false ? field.text! + " *:" : field.text! + ":")
                textField.placeholder = field.description


                textField.setFilledBackgroundColor(UIColor(hexString: "#f9f8fa")!, for: .normal)
                textField.setUnderlineColor(.clear, for: .normal)
                textField.setUnderlineColor(.clear, for: .editing)
                textField.tintColor = UIColor(hexString: uiOptions?.color ?? defaultColorCode)
                textField.layer.borderWidth = 0.3
                textField.layer.borderColor = UIColor.lightGray.cgColor
                textField.layer.cornerRadius = 8
                textField.sizeToFit()
                textField.tag = i
                textField.delegate = self
                textField.addTarget(self, action: #selector(textFieldEditingDidChange(sender:)), for: .editingDidEnd)
                let picker = UIPickerView()
                picker.dataSource = self
                picker.delegate = self
                picker.backgroundColor = .white
                picker.tag = i
                textField.inputView = picker

                stackView.addArrangedSubview(textField)
                textField.snp.makeConstraints { (make) in
                    make.height.equalTo(60)
                    make.left.right.equalToSuperview().inset(16)
                }
                if let error = self.errors.first(where: { $0.fieldId == field._id }) {
                    textField.leadingAssistiveLabel.text = error.text
                    textField.setLeadingAssistiveLabelColor(.red, for: .normal)
                    textField.layer.borderColor = UIColor.red.cgColor
                }
            case "textarea":
                let textField = MDCFilledTextArea()
                let isRequired = field.isRequired
                textField.label.text = (isRequired ?? false ? field.text! + " *:" : field.text! + ":")
                textField.setFilledBackgroundColor(UIColor(hexString: "#f9f8fa")!, for: .normal)
                textField.backgroundColor = UIColor(hexString: "#f9f8fa")
                textField.setUnderlineColor(.clear, for: .normal)
                textField.setUnderlineColor(.clear, for: .editing)
                textField.tintColor = UIColor(hexString: uiOptions?.color ?? defaultColorCode)
                textField.layer.borderWidth = 0.3
                textField.layer.borderColor = UIColor.lightGray.cgColor
                textField.layer.cornerRadius = 8
                textField.textView.isScrollEnabled = true
                textField.clipsToBounds = true
                textField.sizeToFit()
                textField.tag = i
                textField.textView.delegate = self
                stackView.addArrangedSubview(textField)
                textField.snp.makeConstraints { (make) in
                    make.height.equalTo(100)
                    make.left.right.equalToSuperview().inset(16)
                }
                if let error = self.errors.first(where: { $0.fieldId == field._id }) {
                    textField.leadingAssistiveLabel.text = error.text
                    textField.setLeadingAssistiveLabel(.red, for: .normal)
                    textField.layer.borderColor = UIColor.red.cgColor
                }
            case "radio":
                guard let options = field.options?.filter({ $0 != nil }) else { continue }
                let isRequired = field.isRequired
                let radioView = RadioView(options: options, title: (isRequired ?? false ? field.text! + " *:" : field.text! + ":"), desc: field.description)


                radioView.backgroundColor = UIColor(hexString: "#f9f8fa")!
                radioView.layer.cornerRadius = 8
                radioView.layer.borderWidth = 0.3
                radioView.layer.borderColor = UIColor.lightGray.cgColor
                radioView.subTitleLabel.textColor = .gray
                radioView.tag = i
                radioView.delegate = self
                stackView.addArrangedSubview(radioView)
                radioView.snp.makeConstraints { (make) in
                    make.left.right.equalToSuperview().inset(16)
                }
                if let error = self.errors.first(where: { $0.fieldId == field._id }) {
                    radioView.subTitleLabel.text = error.text
                    radioView.subTitleLabel.textColor = .red
                    radioView.layer.borderColor = UIColor.red.cgColor
                }
            case "check":
                guard let options = field.options?.filter({ $0 != nil }) else { continue }
                let isRequired = field.isRequired
                let checkView = CheckView(options: options, title: (isRequired ?? false ? field.text! + " *:" : field.text! + ":"), desc: field.description)

                checkView.backgroundColor = UIColor(hexString: "#f9f8fa")!
                checkView.layer.cornerRadius = 8
                checkView.layer.borderWidth = 0.3
                checkView.subTitleLabel.textColor = .gray
                checkView.layer.borderColor = UIColor.lightGray.cgColor
                checkView.tag = i
                checkView.delegate = self
                stackView.addArrangedSubview(checkView)
                checkView.snp.makeConstraints { (make) in
                    make.left.right.equalToSuperview().inset(16)
                }
                if let error = self.errors.first(where: { $0.fieldId == field._id }) {
                    checkView.subTitleLabel.text = error.text
                    checkView.subTitleLabel.textColor = .red
                    checkView.layer.borderColor = UIColor.red.cgColor
                }
            case "file":
                let textField = MDCFilledTextField()
                let isRequired = field.isRequired
                textField.label.text = (isRequired ?? false ? field.text! + " *:" : field.text! + ":")
                textField.placeholder = field.description
                textField.setFilledBackgroundColor(UIColor(hexString: "#f9f8fa")!, for: .normal)
                textField.setUnderlineColor(.clear, for: .normal)
                textField.setUnderlineColor(.clear, for: .editing)
                textField.tintColor = UIColor(hexString: uiOptions?.color ?? defaultColorCode)
                textField.layer.borderWidth = 0.3
                textField.layer.borderColor = UIColor.lightGray.cgColor
                textField.layer.cornerRadius = 8
                textField.sizeToFit()
                textField.tag = i
                textField.delegate = self

//                textField.addTarget(self, action: #selector(didTapFile(sender:)), for: .editingDidBegin)
                let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapFile(sender:)))
            
                tapRecognizer.numberOfTapsRequired = 1
                tapRecognizer.numberOfTouchesRequired = 1
                textField.addGestureRecognizer(tapRecognizer)
                textField.clearButtonMode = .always
                textField.inputAccessoryView = UIView()
                stackView.addArrangedSubview(textField)
                textField.snp.makeConstraints { (make) in
                    make.height.equalTo(60)
                    make.left.right.equalToSuperview().inset(16)
                }
                if let error = self.errors.first(where: { $0.fieldId == field._id }) {
                    textField.leadingAssistiveLabel.text = error.text
                    textField.setLeadingAssistiveLabelColor(.red, for: .normal)
                    textField.layer.borderColor = UIColor.red.cgColor
                }
            default:
                let textField = MDCFilledTextField()
                let isRequired = field.isRequired
                textField.label.text = (isRequired ?? false ? field.text! + " *:" : field.text! + ":")
                textField.placeholder = field.description


                textField.setFilledBackgroundColor(UIColor(hexString: "#f9f8fa")!, for: .normal)
                textField.setUnderlineColor(.clear, for: .normal)
                textField.setUnderlineColor(.clear, for: .editing)
                textField.tintColor = UIColor(hexString: uiOptions?.color ?? defaultColorCode)
                textField.layer.borderWidth = 0.3
                textField.layer.borderColor = UIColor.lightGray.cgColor
                textField.layer.cornerRadius = 8
                textField.sizeToFit()
                textField.tag = i
                textField.delegate = self
                textField.addTarget(self, action: #selector(textFieldEditingDidChange(sender:)), for: .editingDidEnd)
                stackView.addArrangedSubview(textField)
                textField.snp.makeConstraints { (make) in
                    make.height.equalTo(60)
                    make.left.right.equalToSuperview().inset(16)
                }
                if let error = self.errors.first(where: { $0.fieldId == field._id }) {
                    textField.leadingAssistiveLabel.text = error.text
                    textField.setLeadingAssistiveLabelColor(.red, for: .normal)
                    textField.layer.borderColor = UIColor.red.cgColor
                }
            }
        }
    }

    @objc func textFieldEditingDidChange(sender: UITextField) {
        sender.resignFirstResponder()
        self.endEditing(true)
        guard let field = self.form.fields?.compactMap({ $0?.fragments.fieldModel })[sender.tag] else { return }

        let valueInput = FieldValueInput(_id: field._id, type: field.type, validation: field.validation, text: field.text, value: ["text":sender.text])

        if let index = self.submissions.firstIndex(where: { $0?._id == field._id }) {
            self.submissions[index] = valueInput
        }
    }

    @objc func didTapFile(sender: UIGestureRecognizer) {
        self.endEditing(true)
       
        if let handle = didTapOpenFile {
            self.currentTag = sender.view!.tag
            handle()

        }
    }
    
    
    func showThankContent(){
        stackView.removeAllArrangedSubviews()
        descriptionLabel.text = thankMessage
        button.isHidden = true
        layoutSubviews()
    }

}



extension FormVIew: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        guard let options = form.fields?.compactMap({ $0!.fragments.fieldModel })[pickerView.tag].options else { return "" }
        return options[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard let options = form.fields?.compactMap({ $0!.fragments.fieldModel })[pickerView.tag].options else { return }
        let textField = self.stackView.viewWithTag(pickerView.tag) as? MDCFilledTextField
        textField?.text = options[row]
    }
}

extension FormVIew: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        guard let options = form.fields?.compactMap({ $0!.fragments.fieldModel })[pickerView.tag].options else { return 0 }
        return options.count
    }
}


extension FormVIew: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let field = self.form.fields?.compactMap({ $0?.fragments.fieldModel })[textField.tag] else { return true }
        if field.type == "file" {
            return false
        } else {
            return true
        }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        guard let field = self.form.fields?.compactMap({ $0?.fragments.fieldModel })[textField.tag] else { return true }
        if field.type == "file" {
            return false
        } else {
            return true
        }
    }
}

extension FormVIew: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {

        guard let field = self.form.fields?.compactMap({ $0?.fragments.fieldModel })[textView.tag] else { return }
        let valueInput = FieldValueInput(_id: field._id, type: field.type, validation: field.validation, text: field.text, value: ["text": textView.text])
        if let index = self.submissions.firstIndex(where: { $0?._id == field._id }) {
            self.submissions[index] = valueInput
        }
        textView.resignFirstResponder()
    }



}


extension FormVIew: RadioViewDelegate {
    func didSelectValue(value: String, sender: UIView) {
        guard let field = self.form.fields?.compactMap({ $0?.fragments.fieldModel })[sender.tag] else { return }
        let valueInput = FieldValueInput(_id: field._id, type: field.type, validation: field.validation, text: field.text, value: ["value: ":value])
        if let index = self.submissions.firstIndex(where: { $0?._id == field._id }) {
            self.submissions[index] = valueInput
        }
    }
}

extension FormVIew: CheckViewDelegate {
    func didSelectValues(values: String, sender: UIView) {

        guard let field = self.form.fields?.compactMap({ $0?.fragments.fieldModel })[sender.tag] else { return }
        let valueInput = FieldValueInput(_id: field._id, type: field.type, validation: field.validation, text: field.text, value: ["values":values])
        if let index = self.submissions.firstIndex(where: { $0?._id == field._id }) {
            self.submissions[index] = valueInput
        }
    }
}
