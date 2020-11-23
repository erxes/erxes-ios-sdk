//BaseCells.swift
/*
 * ChatUI
 * Created by penumutchu.prasad@gmail.com on 07/04/19
 * Is a product created by abnboys
 * For the ChatUI in the ChatUI
 
 * Here the permission is granted to this file with free of use anywhere in the IOS Projects.
 * Copyright © 2018 ABNBoys.com All rights reserved.
*/

import UIKit


class BaseCells: UICollectionViewCell {
    var isLoaded = false
    var width: CGFloat = 0
    var height: CGFloat = 0

    var model: MessageModel? {
        didSet {
            self.updateView()
        }
    }

    lazy var avatarView: UIImageView = {
        let imageview = UIImageView()
        imageview.image = UIImage(named: "ic_avatar",in: Erxes.erxesBundle(), compatibleWith: nil)
        self.contentView.addSubview(imageview)
        imageview.layer.cornerRadius = 15
        imageview.clipsToBounds = true
        return imageview
    }()


    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 10)
        self.contentView.addSubview(label)
        label.sizeToFit()
        return label
    }()


    lazy var textView: UITextView = {
        let view = UITextView()
        view.isEditable = false
        view.isScrollEnabled = false
        view.textColor = .white
        view.layer.cornerRadius = 10
        view.backgroundColor = UIColor(hexString: uiOptions?.color ?? defaultColorCode)
        view.font = UIFont.systemFont(ofSize: 18)

        view.textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 0, right: 8)
        self.contentView.addSubview(view)
        return view
    }()

    lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.isUserInteractionEnabled = true
        view.contentMode = ContentMode.scaleAspectFill
        view.clipsToBounds = true
        view.backgroundColor = .white
        self.contentView.addSubview(view)
        return view
    }()

    lazy var edgeView: UIView = {
        let view = UIView()
        self.contentView.addSubview(view)
        view.backgroundColor = UIColor(hexString: uiOptions?.color ?? defaultColorCode)
        return view
    }()


    override init(frame: CGRect) {
        super.init(frame: frame)
        cellDidLoad()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        cellDidLoad()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        cellDidLoad()
    }


    override func prepareForReuse() {
        super.prepareForReuse()
        self.avatarView.image = nil
        self.textView.text = nil
        self.dateLabel.text = nil
        self.textView.attributedText = nil
    }

    open func cellDidLoad() {

    }


    override func layoutSubviews() {
        super.layoutSubviews()
        if isLoaded { return }
        layoutView()
        isLoaded = true
    }


    open func layoutView() {

    }


    func updateView() {
        if let avatar = model?.user?.fragments.userModel.details?.avatar {
            avatarView.sd_setImage(with: URL(string: avatar.readFile()), placeholderImage: UIImage(named: "ic_avatar",in: Erxes.erxesBundle(), compatibleWith: nil))
        } else {
            avatarView.image = UIImage(named: "ic_avatar",in: Erxes.erxesBundle(), compatibleWith: nil)
        }

        if let date = model?.createdAt{
            let now = date.hourMinutes!
            dateLabel.text = now
        }else {
            let date = Date()
            let now = date.hourMinutes!
            dateLabel.text = now
        }
    }


    static func getSizeOf(message: MessageModel) -> CGSize {
        let textView = UITextView()


        var options = [NSAttributedString.Key: Any]()
//        options[NSAttributedString.Key.font] = UIFont.systemFont(ofSize: 13)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5
        paragraphStyle.paragraphSpacing = 0
        options[NSAttributedString.Key.paragraphStyle] = paragraphStyle

        guard let content = message.content else  {
            return CGSize(width: 0, height: 50)
        }
        
        var attributedString = NSMutableAttributedString()
        
        if message.contentType == "videoCallRequest" {
            attributedString = String(format: "📞  %@", "Video call request sent".localized(lang)).html2Attributed!
           
        }else if (message.contentType == "videoCall") {
            if message.videoCallData?.status  == "ongoing"{
                attributedString = String(format: "%@ \n👏", "You are invited to a video call".localized(lang)).html2Attributed!
            }else {
                attributedString = String(format: "📞 %@", "Video call ended".localized(lang) ).html2Attributed!
            }
            
        }else {
            if let aString = content.html2Attributed {
                attributedString = aString
            }
        }

        
        let attributes = attributedString.attributes(at: 0, effectiveRange: nil)
        let font = attributes[NSAttributedString.Key.font] as? UIFont
        let newFont = UIFont.systemFont(ofSize: font!.pointSize + 5.0)
        options[NSAttributedString.Key.font] = newFont

        attributedString.addAttributes(options, range: NSMakeRange(0, attributedString.length))
        if attributedString.attributedSubstring(from: NSMakeRange(attributedString.length - 1, 1)).string == "\n" {
            attributedString.deleteCharacters(in: NSMakeRange(attributedString.length - 1, 1))
        }
        textView.attributedText = attributedString
        let textViewSize = textView.sizeThatFits(CGSize(width: SCREEN_WIDTH - 100, height: 10000))
        var height = textViewSize.height + 22
        
        if message.contentType == "videoCall" && message.videoCallData?.status == "ongoing" {
            height = height + 70
        }
        
        
        if height < 50 {
            return CGSize(width: textViewSize.width, height: 50)
        } else {
            return CGSize(width: textViewSize.width, height: height)
        }
    }
}
