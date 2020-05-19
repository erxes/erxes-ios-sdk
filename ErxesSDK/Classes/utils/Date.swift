import Foundation
extension Date {
    var millisecondsSince1970:Int {
        return Int((self.timeIntervalSince1970 * 1000.0).rounded())
    }
    
    init(milliseconds:Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds / 1000))
    }
    
    struct Formatter {
        static let utcFormatter: DateFormatter = {
            let dateFormatter = DateFormatter()
            
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss'Z'"
            dateFormatter.timeZone = TimeZone(identifier: "GMT")
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            return dateFormatter
        }()
    }
    
    var dateToUTC: String {
        return Formatter.utcFormatter.string(from: self)
    }
    
    var hourMinutes: String? {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: self)
    }
}


extension Int64 {
    func dateFromUnixTime() -> Date {
        //        let date = NSDate(timeIntervalSince1970: TimeInterval(self))
        let timeInterval = Double(self / 1000)
        let date = Date(timeIntervalSince1970: timeInterval)
        return date
    }
}

extension Int {
    func dateFromUnixTime() -> Date {
        //        let date = NSDate(timeIntervalSince1970: TimeInterval(self))
        let timeInterval = Double(self / 1000)
        let date = Date(timeIntervalSince1970: timeInterval)
        return date
    }
}

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

