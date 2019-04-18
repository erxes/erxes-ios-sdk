extension ChatVC {
    func readConversation() {
        if let id = conversationId {
            let mutation = ReadConversationMessagesMutation(conversationId: id)
            apollo.perform(mutation: mutation){result,error in
                if let error = error {
                    print(error)
                    return
                }
                print(result)
            }
        }
    }

    @IBAction func endConversation(_ sender: Any) {
        let defaults = UserDefaults()
        defaults.removeObject(forKey: "email")
        defaults.removeObject(forKey: "phone")
        defaults.synchronize()
        self.close()
        erxesEmail = ""
        erxesPhone = ""
        conversationId = nil
    }
}
