extension ChatVC {
    func checkOnline(){
        let query = IsSupporterOnlineQuery(integrationId: integrationId)
        apollo.fetch(query: query){ [weak self] result, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            if let isOnline = result?.data?.isMessengerOnline{
                if isOnline{
                    self?.lblStatus.text = "online".localized
                }
                else{
                    self?.lblStatus.text = "offline".localized
                }
            }
        }
    }

    func setSupporterState(){
        if supporters.count > 0 {
            var title = ""
            for n in 0...supporters.count-1{
                let user = supporters[n]
                let iv = self.view.viewWithTag(101 + n) as! UIImageView
                if let avatar = user.details?.avatar{
                    iv.downloadedFrom(link: avatar)
                    iv.layer.borderColor = erxesColor!.cgColor
                    iv.layer.borderWidth = 1
                }
                if let names = user.details?.fullName?.split(separator: " "){
                    if names.count > 0{
                        title += names[0]
                        if n < supporters.count - 1{
                            title += ", "
                        }
                    }
                }
            }
            self.lblSupporterName.text = title
        }
        else{
            supporterAvatar = "Хэрэглэгчид туслах"
        }

        if let supporterAvatar = supporterAvatar{
            self.ivSupporterAvatar.downloadedFrom(link: supporterAvatar)
        }
        else{
            supporterAvatar = "avatar.png"
        }
    }
}