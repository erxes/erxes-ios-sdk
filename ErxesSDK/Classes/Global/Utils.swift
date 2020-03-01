
import UIKit

class Utils: NSObject {
    
    static func formatDate(date:Date) -> String! {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
//        let tmp = Int64(time)
//        let date = Date(milliseconds:tmp)
        let now = dateFormatter.string(from: date)
        return now
    }

    static func now() -> String! {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        let date = Date()
        let now = dateFormatter.string(from: date)
        return now
    }
    
    static func fullDateString(value:Date,locale: Locale!) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, YYYY HH:mm"
        dateFormatter.locale = locale
     
        let now = dateFormatter.string(from: value)
        return now
    }
}
