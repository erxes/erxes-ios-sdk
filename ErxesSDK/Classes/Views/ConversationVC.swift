import UIKit
import Apollo
import LiveGQL

class ConversationVC: UIViewController {

    @IBOutlet weak var tv:UITableView!
    @IBOutlet weak var btnEndTitle: UILabel!
    @IBOutlet weak var header:UIView!
    @IBOutlet weak var headerTitle:UILabel!
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
        
        if let integrationId = def.string(forKey: defs.integrationId.rawValue) {
            self.integrationId = integrationId
        }
        
        if let customerId = def.string(forKey: defs.customerId.rawValue) {
            self.customerId = customerId
        }
        
        tv.delegate = self
        tv.dataSource = self
        gql.delegate = self
        subscribe()
//        Erxes.changeLanguage()
        self.headerTitle.text = "conversations".localized
//        self.btnEndTitle.text = "end conversation".localized
        self.tv.addSubview(self.refreshControl)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.refreshControl.beginRefreshing()
        refresh()
    }
    
    func getSupporter() {
        
        let query = GetSupportersQuery(integrationId: integrationId)
        apollo.fetch(query: query) { [weak self] result, error in
            
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            if let list = result?.data?.messengerSupporters, list.count > 0 {
                supporters = list as! [GetSupportersQuery.Data.MessengerSupporter]
                let supporter = supporters[0]
                supporterName = supporter.details?.fullName
                supporterAvatar = supporter.details?.avatar
            }
        }
    }
    
    var list:[ConversationsQuery.Data.Conversation] = []
    
    
    
    func refresh() {
        let query = ConversationsQuery(integrationId: integrationId, customerId: erxesCustomerId)

        apollo.fetch(query: query, cachePolicy: .fetchIgnoringCacheData){[weak self] result,error in
            self?.refreshControl.endRefreshing()
            if let error = error {
                print(error.localizedDescription)
                return
            }
            self?.list = (result?.data?.conversations)! as! [ConversationsQuery.Data.Conversation]
            
            self?.list = (self?.list.filter { $0.status == "open" })!
            
            self?.tv.reloadData()
            

            if self?.list != nil && self?.list.count == 0 {
                let vc = self?.storyboard?.instantiateViewController(withIdentifier: "chat") as! ChatVC
                vc.isNewConversation = true
                conversationId = nil
                self?.navigationController?.pushViewController(vc, animated: false)
            }
        }
    }
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(ConversationVC.handleRefresh(_:)),
                                 for: UIControlEvents.valueChanged)
        refreshControl.tintColor = UIColor.red
        
        return refreshControl
    }()
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        refresh()
    }
    
    func setNavigationColor() {
        if let color = erxesColor {

            self.header.backgroundColor = color
            self.view.viewWithTag(1)?.backgroundColor = color
        }
    }
    
    @IBAction func close() {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func createConversation() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "chat") as! ChatVC
        conversationId = nil
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension ConversationVC:UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tv.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let item = list[indexPath.row]
        
        let lblDesc = cell.viewWithTag(lblLastTag) as! UILabel
        lblDesc.text = item.content?.html2String
        
        let lblDate = cell.viewWithTag(lblDateTag) as! UILabel
        lblDate.text = Utils.formatDate(time:item.createdAt!)
        

        
        if let avatar = supporterAvatar {
            let ivAvatar = cell.viewWithTag(ivTag) as! UIImageView
            ivAvatar.downloadedFrom(link: avatar)
        }
        
        if let title = supporterName {
            let lbl = cell.viewWithTag(lblTitleTag) as! UILabel
            lbl.text = title
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "chat") as! ChatVC
        var item = list[indexPath.row]
        conversationId = item.id
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension ConversationVC:LiveGQLDelegate {
    
    public func subscribe() {
//        gql.subscribe(graphql: "subscription{conversationChanged(_id:\"\(erxesCustomerId!)\"){type,conversationId}}", variables: nil, operationName: nil, identifier: "conversationChanged")
        gql.subscribe(graphql: "subscription{conversationAdminMessageInserted(customerId:\"\(erxesCustomerId!)\"){content}}", variables: nil, operationName: nil, identifier: "conversationAdminMessageInserted")
    }
    
    
    
    public func receivedRawMessage(text: String) {
       
        if self.list.count > 0 {
            refresh()
        }
    }
    
}
