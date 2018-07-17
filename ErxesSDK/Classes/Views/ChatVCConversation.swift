public protocol ChatVCConveration{
    
}

extension ChatVC{
    func readConversation(){
        if let id = conversationId{
            let mutation = ReadConversationMessagesMutation(conversationId: id)
            apollo.perform(mutation: mutation){result,error in
                if let error = error{
                    print(error)
                    return
                }
                print(result)
            }
        }
    }

    @IBAction func endConversation(_ sender: Any) {
        let mutation = EndConversationMutation(customerId: erxesCustomerId, brandCode: brandCode)
        apollo.perform(mutation: mutation){[weak self] result,error in
            self?.uploadView.isHidden = true
            if let error = error {
                print(error.localizedDescription)
                return
            }
            let defaults = UserDefaults()
            defaults.removeObject(forKey: "email")
            defaults.synchronize()
            self?.close()
            erxesEmail = nil
        }
    }
}
