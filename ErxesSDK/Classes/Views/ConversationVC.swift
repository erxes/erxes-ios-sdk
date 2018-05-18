
import UIKit
import Apollo
import LiveGQL
import SwiftyJSON

class ConversationVC: UIViewController {

    @IBOutlet weak var tv:UITableView!
    
    var integrationId:String!
    var customerId:String!
    
    let ivTag = 1
    let lblTitleTag = 2
    let lblDateTag = 3
    let lblLastTag = 4
    
    var inited:Bool! = false
    
    let gql = LiveGQL(socket: subsUrl)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        setNavigationColor()
        
        let def = UserDefaults()
        
        if let integrationId = def.string(forKey: defs.integrationId.rawValue){
            self.integrationId = integrationId
        }
        
        if let customerId = def.string(forKey: defs.customerId.rawValue){
            self.customerId = customerId
        }
        
        tv.delegate = self
        tv.dataSource = self
        gql.delegate = self
        subscribe()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        refresh()
    }
    
    var list:[ConversationsQuery.Data.Conversation] = [];
    
    func refresh(){
        let query = ConversationsQuery(integrationId: Erxes.integrationId, customerId: Erxes.customerId)

        apollo.fetch(query: query, cachePolicy: .fetchIgnoringCacheData){[weak self] result,error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            self?.list = (result?.data?.conversations)! as! [ConversationsQuery.Data.Conversation]
            self?.tv.reloadData()
            
//            if !(self?.inited)!{
//                self?.inited = true
//                let vc = self?.storyboard?.instantiateViewController(withIdentifier: "chat") as! ChatVC
//                if Erxes.conversationId != nil{
//                    vc.conversationId = Erxes.conversationId
//                }
//                self?.navigationController?.pushViewController(vc, animated: true)
//            }
            if self?.list != nil && self?.list.count == 0{
                let vc = self?.storyboard?.instantiateViewController(withIdentifier: "chat") as! ChatVC
                self?.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    func setNavigationColor(){
        if let color = Erxes.color{
            self.navigationController?.navigationBar.barTintColor = color
        }
    }
    
    @IBAction func close(){
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func createConversation(){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "chat") as! ChatVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension ConversationVC:UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tv.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let item = list[indexPath.row]
        
        let lbl = cell.viewWithTag(lblTitleTag) as! UILabel
        lbl.text = item.content?.withoutHtml
        
        let lblDate = cell.viewWithTag(lblDateTag) as! UILabel
        lblDate.text = Utils.formatDate(time:item.createdAt!)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "chat") as! ChatVC
        var item = list[indexPath.row]
        vc.conversationId = item.id
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension ConversationVC:LiveGQLDelegate{
    
    public func subscribe(){
        gql.subscribe(graphql: "subscription{conversationsChanged(customerId:\"\(Erxes.customerId!)\"){type,customerId}}", variables: nil, operationName: nil, identifier: "conversationsChanged")
    }
    
    public func receivedRawMessage(text: String) {
        refresh()
    }
}
