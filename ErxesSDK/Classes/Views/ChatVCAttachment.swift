import Photos
import Alamofire

public class ChatVCAttachment:ChatVCMessage {
    
    @IBOutlet weak var ivSupporterAvatar: UIImageView!
    @IBOutlet weak var lblSupporterName: UILabel!
    @IBOutlet weak var lblSupporterStatus: UILabel!
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var header:UIView!
    
    var uploadUrl = ""
    var uploaded = JSON()
    var headerInited = false
    var size = 0
    
    func checkPermission() {

        let photos = PHPhotoLibrary.authorizationStatus()
        if photos == .notDetermined {
            PHPhotoLibrary.requestAuthorization({status in
                if status == .authorized {
                    self.openGallery()
                } else {
                }
            })
        } else {
            self.openGallery()
        }
    }

    func uploadFile(image:UIImage) {

        self.uploadView.isHidden = false
        self.progress.progress = 0
        self.uploadLoader.startAnimating()

        let url = "https://app-api.crm.nmma.co/upload-file"
        let imgData = UIImageJPEGRepresentation(image, 0.2)!
        size = imgData.count
        let bcf = ByteCountFormatter()
        bcf.allowedUnits = [.useKB]
        bcf.countStyle = .file
        self.lblFilesize.text = bcf.string(fromByteCount: Int64(size))

//        let parameters = ["name": rname] //Optional for extra parameter

        Alamofire.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imgData, withName: "file",fileName: "file.jpg", mimeType: "image/jpg")
//            for (key, value) in parameters {
//                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
//            } //Optional for extra parameters
        },
            to:url )
        { (result) in
            switch result {
            case .success(let upload, _, _):
                self.processUpload(upload)
            case .failure(let encodingError):
                print(encodingError)
            }
        }
    }
    
    func processUpload(_ upload:UploadRequest) {
        upload.uploadProgress(closure: { (progress) in
            print("Upload Progress: \(progress.fractionCompleted)")
            self.progress.progress = Float(progress.fractionCompleted)
        })
        
        upload.responseString { response in
            print(response)
            self.uploadUrl = response.value!
            self.uploaded = ["url" : self.uploadUrl, "size" : self.size, "type" : "image/jpeg"]
            self.uploadLoader.stopAnimating()
            
            self.uploadView.isHidden = false
            self.attachments = [JSON]()
            self.attachments.append(self.uploaded)
            self.sendMessage("")
        }
    }

    func openGallery() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
//        imagePicker.allowsEditing = true
        DispatchQueue.main.async {
            self.present(imagePicker, animated: true, completion: nil)
        }
    }

    @IBAction func reshapeHeader() {
        let count = supporters.count
        if count > 0 && !headerInited {
            headerInited = true
            for n in 1...count {
                fillUserInfo(n)
            }
        }
    }
    
    func fillUserInfo(_ index:Int) {
        let size = self.header.frame.size
        let width = size.width - 128
        let count = supporters.count
        let cellsize = width/CGFloat(count)
        var begin = (width - CGFloat(count) * cellsize)/2
        begin += cellsize * CGFloat(index-1)
        let user = supporters[index-1]
        let view = self.view.viewWithTag(10 * index)
        view?.isHidden = false
        view?.frame = CGRect(x: begin, y: 0, width: cellsize, height: 70)
        
        if let avatar =  user.details?.avatar {
            if let iv = self.view.viewWithTag(10 * index + 1) as? UIImageView {
                iv.downloadedFrom(link:avatar)
            }
        }
        
        if let lbl = self.view.viewWithTag(10 * index + 2) as? UILabel {
            lbl.text = user.details?.fullName
        }
        
        if let lbl = self.view.viewWithTag(10 * index + 3) as? UILabel {
            lbl.text = self.lblStatus.text
        }
    }
    
    func resizeHeader() {
        let size = self.header.frame.size
        if size.height == 64 {
            self.header.frame = CGRect(x: 0, y: 0, width: size.width, height: 100)
            self.view.viewWithTag(1)?.isHidden = true
            self.view.viewWithTag(2)?.isHidden = false
        } else {
            self.header.frame = CGRect(x: 0, y: 0, width: size.width, height: 64)
            self.view.viewWithTag(1)?.isHidden = false
            self.view.viewWithTag(2)?.isHidden = true
        }
    }

    @IBAction func btnAttachClick() {
        checkPermission()
    }

    @IBAction func btnCancelClick(_ sender: Any) {
        self.uploadView.isHidden = true
        self.attachments = [JSON]()
    }
}

extension ChatVCAttachment:UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    public func imagePickerController(_ picker: UIImagePickerController,
                                      didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true, completion: nil)
        print(info)

        if let chosenImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            ivPicked.image = chosenImage
            uploadFile(image: chosenImage)
        }
    }

    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
