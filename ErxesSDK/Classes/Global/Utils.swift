
import UIKit

class Utils: NSObject {
    
    static func formatDate(time:String!) -> String!{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        let tmp = Int64(time)
        let date = Date(milliseconds:tmp!)
        let now = dateFormatter.string(from: date)
        return now
    }
}
