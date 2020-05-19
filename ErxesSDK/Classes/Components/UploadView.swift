//
//  UploadView.swift
//  erxesiosdk
//
//  Created by Soyombo bat-erdene on 8/23/19.
//  Copyright © 2019 Soyombo bat-erdene. All rights reserved.
//

import UIKit
import Alamofire


protocol AttachmentUploadDelegate: class {
    func attachmentUploaded(file: AttachmentInput)
    func uploadFailed(errorMessage: String)
}

class UploadView: UIView {



    weak var delegate: AttachmentUploadDelegate?
    var size = 0

    private var imageFile = UIImage() {
        didSet {
            imageView.image = imageFile
        }
    }



    var sessionManager: SessionManager!

    lazy var imageView: UIImageView = {
        let imageview = UIImageView()
        imageview.contentMode = ContentMode.scaleAspectFit
        self.addSubview(imageview)
        imageview.center = self.center
        imageview.layer.cornerRadius = 6
        imageview.layer.borderWidth = 4
        imageview.layer.borderColor = UIColor.init(hexString: uiOptions?.color ?? defaultColorCode)?.cgColor
        return imageview
    }()

    lazy var progressBar: UIProgressView = {
        let progressView = UIProgressView()
        progressView.progressViewStyle = UIProgressView.Style.bar
        progressView.trackTintColor = .clear
        progressView.progressTintColor = UIColor(hexString: uiOptions?.color ?? defaultColorCode)

        return progressView
    }()

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
        self.cancelUploadRequest()
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
        if filePath == nil {
            self.imageFile = image
            self.imageView.image = image

            let ratio = image.size.width / image.size.height
            let w = SCREEN_WIDTH - 100

            let newHeight = w / ratio
            self.imageView.frame.size = CGSize(width: w, height: newHeight)
            self.imageView.center = self.center
            self.uploadImage(image: image)
        } else {
            let w = SCREEN_WIDTH - 100
            self.imageFile = UIImage.erxes(with: .file, textColor: .gray)
            self.imageView.image = UIImage.erxes(with: .file, textColor: .gray,size: CGSize(width: w-50, height: w-50))
            self.imageView.contentMode = .scaleAspectFit
            self.imageView.backgroundColor = .white
            

            self.imageView.frame.size = CGSize(width: w, height: w)
            self.imageView.center = self.center
            self.uploadFile(path: filePath!)
        }

    }

    func didLoad() {
        //Place your initialization code here
        self.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
        self.backgroundColor = UIColor.black.withAlphaComponent(0.75)
        self.imageView.addSubview(progressBar)
        self.addSubview(closeButton)

        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForResource = TimeInterval(15.0)
        configuration.timeoutIntervalForRequest = TimeInterval(15.0)
        sessionManager = Alamofire.SessionManager(configuration: configuration)
    }



    override func layoutSubviews() {
        super.layoutSubviews()

        //Custom manually positioning layout goes here (auto-layout pass has already run first pass)
        progressBar.snp.makeConstraints({ (make) in
            make.bottom.equalToSuperview().offset(-4)
            make.height.equalTo(4)
            make.left.equalToSuperview().offset(4)
            make.right.equalToSuperview().offset(-4)
        })

        closeButton.snp.makeConstraints { (make) in
            make.width.height.equalTo(40)
            make.top.equalTo(imageView.snp.top).offset(-20)
            make.right.equalTo(imageView.snp.right).offset(20)
        }

    }

    override func updateConstraints() {
        super.updateConstraints()

    }

    func uploadFile(path: URL) {
        let isSecured = path.startAccessingSecurityScopedResource() == true
        self.progressBar.progress = 0
        //        self.uploadLoader.startAnimating()

        let fileName = path.lastPathComponent
       
        do {
            let fileData: Data = try Data(contentsOf: path)
            let mimeType = fileData.mimeType
            size = fileData.count

            let bcf = ByteCountFormatter()
            bcf.allowedUnits = [.useKB]
            bcf.countStyle = .file
            //            self.lblFilesize.text = bcf.string(fromByteCount: Int64(size))

            sessionManager.upload(multipartFormData: { multipartFormData in
                multipartFormData.append(fileData, withName: path.deletingPathExtension().lastPathComponent, fileName: fileName, mimeType: mimeType)

            },
                                  to: uploadUrl) {
                (result) in

                switch result {
                case .success(let upload, _, _):
                    self.processUpload(upload, name: path.deletingPathExtension().lastPathComponent, mimeType: mimeType)
                case .failure(let encodingError):
                    self.delegate?.uploadFailed(errorMessage: encodingError.localizedDescription)
                }
            }

        }
        catch {
            // Couldn't create audio player object, log the error
            delegate?.uploadFailed(errorMessage: error.localizedDescription)
        }
        
        if(isSecured){
            path.stopAccessingSecurityScopedResource()
        }

    }
    
  

    func uploadImage(image: UIImage) {
//        self.uploadView.isHidden = false
        self.progressBar.progress = 0
//        self.uploadLoader.startAnimating()



        if let imgData = UIImage.resize(image) {
            size = imgData.count
            let bcf = ByteCountFormatter()
            bcf.allowedUnits = [.useKB]
            bcf.countStyle = .file
//            self.lblFilesize.text = bcf.string(fromByteCount: Int64(size))

            sessionManager.upload(multipartFormData: { multipartFormData in
                multipartFormData.append(imgData, withName: "file", fileName: "file.jpg", mimeType: "image/jpg")

            },
                                  to: uploadUrl) {
                (result) in
     
                switch result {
                case .success(let upload, _, _):
                    self.processUpload(upload,name: "file", mimeType: "image/jpg")
                case .failure(let encodingError):
                    self.delegate?.uploadFailed(errorMessage: encodingError.localizedDescription)
                }
            }
        }
    }

    func cancelUploadRequest() {
        sessionManager.session.getTasksWithCompletionHandler { (_, uploadTasks, _) in
            uploadTasks.forEach { $0.cancel() }
        }
    }

    func processUpload(_ upload: UploadRequest, name:String, mimeType: String) {
        upload.uploadProgress(closure: { (progress) in

            self.progressBar.progress = Float(progress.fractionCompleted)
        })

        upload.responseString { response in
            switch response.result {

            case .success(_):
                self.progressBar.progress = 1
                if self.isValidUrl(url: response.value!) {
         
                    let file = AttachmentInput(url: response.value!, name: name, type: mimeType, size: Double(exactly: self.size))
                    self.delegate?.attachmentUploaded(file: file)

                } else {
                    self.delegate?.uploadFailed(errorMessage: "Check your server configuration")
                }
            case .failure(_):
                self.delegate?.uploadFailed(errorMessage: response.error!.localizedDescription)
            @unknown default:
                 self.delegate?.uploadFailed(errorMessage: "unknown error has occured")
            }



        }
    }

    func isValidUrl(url: String) -> Bool {
        let urlRegEx = "^(https?://)?(www\\.)?([-a-z0-9]{1,63}\\.)*?[a-z0-9][-a-z0-9]{0,61}[a-z0-9]\\.[a-z]{2,6}(/[-\\w@\\+\\.~#\\?&/=%]*)?$"
        let urlTest = NSPredicate(format: "SELF MATCHES %@", urlRegEx)
        let result = urlTest.evaluate(with: url)
        return result
    }

}


extension Data {
    private static let mimeTypeSignatures: [UInt8 : String] = [
        0xFF : "image/jpeg",
        0x89 : "image/png",
        0x47 : "image/gif",
        0x49 : "image/tiff",
        0x4D : "image/tiff",
        0x25 : "application/pdf",
        0xD0 : "application/vnd",
        0x46 : "text/plain",
    ]
    
    var mimeType: String {
        var c: UInt8 = 0
        copyBytes(to: &c, count: 1)
        return Data.mimeTypeSignatures[c] ?? "application/octet-stream"
    }
}
