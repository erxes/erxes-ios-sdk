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
}

class UploadView: UIView {

    
    
    weak var delegate: AttachmentUploadDelegate?
    var size = 0
  
    private var imageFile = UIImage() {
        didSet{
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
        imageview.layer.borderColor = UIColor.init(hexString: "#e7e8ea")?.cgColor
        return imageview
    }()
    
    lazy var progressBar: UIProgressView = {
        let progressView = UIProgressView()
        progressView.progressViewStyle = UIProgressView.Style.bar
        progressView.trackTintColor = .clear
        progressView.progressTintColor = themeColor
       
        return progressView
    }()
    
    var closeButton:UIButton = {
       let button = UIButton()
        button.setImage(UIImage.erxes(with: .cancel, textColor: themeColor!, size: CGSize(width: 25, height: 25), backgroundColor: .clear), for: .normal)
        button.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
        button.layer.cornerRadius = 20
        button.layer.borderColor = themeColor?.cgColor
        button.layer.borderWidth = 2
        button.backgroundColor = .white
        
        return button
    }()
    
    @objc func closeAction(){
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
    
    convenience init(image:UIImage) {
        self.init(frame: .zero)
        self.imageFile = image
        self.imageView.image = image
        
        let ratio = image.size.width / image.size.height
        let w = SCREEN_WIDTH - 100
        
        let newHeight = w / ratio
        self.imageView.frame.size = CGSize(width: w, height: newHeight)
        self.imageView.center = self.center
        self.uploadFile(image: image)
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
    
    func uploadFile(image:UIImage) {
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
                multipartFormData.append(imgData, withName: "file",fileName: "file.jpg", mimeType: "image/jpg")
                
            },
                             to:uploadUrl ) {
                                (result) in
                                
                                switch result {
                                case .success(let upload, _, _):
                                    self.processUpload(upload)
                                case .failure(let encodingError):
                                    print(encodingError)
                                }
            }
        }
    }
    
    func cancelUploadRequest() {
        sessionManager.session.getTasksWithCompletionHandler { (_, uploadTasks, _) in
            uploadTasks.forEach { $0.cancel() }
        }
    }
    
    func processUpload(_ upload:UploadRequest) {
        upload.uploadProgress(closure: { (progress) in
           
            self.progressBar.progress = Float(progress.fractionCompleted)
        })
        
        upload.responseString { response in
            switch response.result {
                
            case .success(_):
                self.progressBar.progress = 1
                if self.isValidUrl(url: response.value!)  {
                    print("response = ", response)
                    let file = AttachmentInput(url: response.value!, name: "file", type: "image/jpeg", size: Double(exactly: self.size))
                    self.delegate?.attachmentUploaded(file: file)
                
                }else {
                    let alertController = UIAlertController(title: "Upload failed", message: "Check your configuration", preferredStyle: .alert)
                    let closeAction = UIAlertAction(title: "Close", style: .cancel, handler: { action in
                        //                    self.uploadLoader.stopAnimating()
                        //                    self.uploadView.isHidden = true
                    })
                    alertController.addAction(closeAction)
                    //                self.present(alertController, animated: true, completion: nil)
                }
            case .failure(_):
                print(response.error?.localizedDescription as Any)
            @unknown default:
                print("asd")
            }
        
            
            
        }
    }
    
    func isValidUrl(url: String) -> Bool {
        let urlRegEx = "^(https?://)?(www\\.)?([-a-z0-9]{1,63}\\.)*?[a-z0-9][-a-z0-9]{0,61}[a-z0-9]\\.[a-z]{2,6}(/[-\\w@\\+\\.~#\\?&/=%]*)?$"
        let urlTest = NSPredicate(format:"SELF MATCHES %@", urlRegEx)
        let result = urlTest.evaluate(with: url)
        return result
    }
    
}
