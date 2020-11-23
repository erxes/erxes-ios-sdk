//
//  UploadView.swift
//  erxesiosdk
//
//  Created by Soyombo bat-erdene on 8/23/19.
//  Copyright © 2019 Soyombo bat-erdene. All rights reserved.
//

import UIKit

protocol AttachmentUploadDelegate: class {
    func attachmentUploaded(file: AttachmentInput)
    func uploadFailed(errorMessage: String)
}

class UploadView: UIView {

    let network = NetworkManager()

    weak var delegate: AttachmentUploadDelegate?
    var size = 0

    private var imageFile = UIImage() {
        didSet {
            imageView.image = imageFile
        }
    }

    lazy var imageView: UIImageView = {
        let imageview = UIImageView()
        imageview.contentMode = ContentMode.scaleAspectFit
        self.addSubview(imageview)
        imageview.center = self.center
        imageview.layer.cornerRadius = 6
        imageview.layer.borderWidth = 4
        imageview.clipsToBounds = true
        imageview.layer.borderColor = UIColor.init(hexString: uiOptions?.color ?? defaultColorCode)?.cgColor
        return imageview
    }()

    var spinner = UIActivityIndicatorView(style: .whiteLarge)
    
    var closeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage.erxes(with: .cancel, textColor: UIColor(hexString: uiOptions?.color ?? defaultColorCode)!, size: CGSize(width: 25, height: 25), backgroundColor: .clear), for: .normal)
        button.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
        button.layer.cornerRadius = 20
        button.layer.borderColor = UIColor(hexString: uiOptions?.color ?? defaultColorCode)?.cgColor
        button.layer.borderWidth = 2
        button.backgroundColor = .white

        return button
    }()

    @objc func closeAction() {
        self.network.cancelUpload()
        self.removeFromSuperview()
    }


    override init(frame: CGRect) {
        super.init(frame: frame)
        didLoad()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        didLoad()
    }

    convenience init(image: UIImage, filePath: URL? = nil) {
        self.init(frame: .zero)
        
        var uuid = UUID().uuidString
        uuid = uuid.replacingOccurrences(of: "-", with: "")
        uuid = uuid.map { $0.lowercased() }.joined()
        
        if filePath == nil {
            self.imageFile = image
            self.imageView.image = image

            let ratio = image.size.width / image.size.height
            let w = SCREEN_WIDTH - 100

            let newHeight = w / ratio
            self.imageView.frame.size = CGSize(width: w, height: newHeight)
            self.imageView.center = self.center
            
            guard let imageData = image.jpegData(compressionQuality: 1.0) else {
                return
            }
     
            let fileInfo = NetworkManager.FileInfo(withFileData: imageData, filename: uuid, name: "file", mimetype: "image/jpg")
            
            self.upload(files: [fileInfo], toURL: URL(string: API_URL + "/upload-file"))
        } else {
            let w = SCREEN_WIDTH - 100
            self.imageFile = UIImage.erxes(with: .file, textColor: .gray)
            self.imageView.image = UIImage.erxes(with: .file, textColor: .gray, size: CGSize(width: w - 50, height: w - 50))
            self.imageView.contentMode = .scaleAspectFit
            self.imageView.backgroundColor = .white


            self.imageView.frame.size = CGSize(width: w, height: w)
            self.imageView.center = self.center
            
            let uuid = UUID().uuidString
            let fileInfo = NetworkManager.FileInfo(withFileURL: filePath, filename: uuid, name: "file", mimetype: "application/pdf")
            
            self.upload(files: [fileInfo], toURL: URL(string: API_URL + "/upload-file"))
        }

    }

    func didLoad() {
        //Place your initialization code here
        self.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
        self.backgroundColor = UIColor.black.withAlphaComponent(0.75)
        
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.startAnimating()
        
        self.imageView.addSubview(spinner)
        
        spinner.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        self.addSubview(closeButton)

        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForResource = TimeInterval(15.0)
        configuration.timeoutIntervalForRequest = TimeInterval(15.0)

    }



    override func layoutSubviews() {
        super.layoutSubviews()

        //Custom manually positioning layout goes here (auto-layout pass has already run first pass)

        closeButton.snp.makeConstraints { (make) in
            make.width.height.equalTo(40)
            make.top.equalTo(imageView.snp.top).offset(-20)
            make.right.equalTo(imageView.snp.right).offset(20)
        }

    }

    override func updateConstraints() {
        super.updateConstraints()

    }
    
    func upload(files: [NetworkManager.FileInfo], toURL url: URL?) {

        let fileInfo = files.first
        if let uploadURL = url {
    
            network.upload(files: files, toURL: uploadURL, withHttpMethod: .post) { [self] (results, failedFilesList) in
     
                if let error = results.error {
                    self.delegate?.uploadFailed(errorMessage: error.localizedDescription)
                }
                
                if let data = results.data {
                    guard let fileUrl = String(data: data, encoding: .utf8) else { return }
                    let file = AttachmentInput(url: fileUrl, name: (fileInfo?.filename)!, type: fileInfo?.mimetype)
                    self.delegate?.attachmentUploaded(file: file)
                }
                
                if failedFilesList != nil {
                    self.delegate?.uploadFailed(errorMessage: "Upload failed !!!")
                }
            }
        }
    }
}


extension Data {
    private static let mimeTypeSignatures: [UInt8: String] = [
        0xFF: "image/jpeg",
        0x89: "image/png",
        0x47: "image/gif",
        0x49: "image/tiff",
        0x4D: "image/tiff",
        0x25: "application/pdf",
        0xD0: "application/vnd",
        0x46: "text/plain",
    ]

    var mimeType: String {
        var c: UInt8 = 0
        copyBytes(to: &c, count: 1)
        return Data.mimeTypeSignatures[c] ?? "application/octet-stream"
    }
}
