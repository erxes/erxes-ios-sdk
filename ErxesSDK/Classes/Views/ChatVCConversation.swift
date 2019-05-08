extension ChatVC {
    func readConversation() {
        if let id = conversationId {
            let mutation = ReadConversationMessagesMutation(conversationId: id)
            apollo.perform(mutation: mutation){result,error in
                if let error = error {
                    print(error)
                    return
                }
            }
        }
    }

    @IBAction func endConversation(_ sender: Any) {
       
        self.close()
        
    }
}
