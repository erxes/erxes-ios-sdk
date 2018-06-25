
import UIKit

class Utils: NSObject {
    
    static func formatDate(time:Int) -> String!{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        let tmp = Int64(time)
        let date = Date(milliseconds:tmp)
        let now = dateFormatter.string(from: date)
        return now
    }
}
