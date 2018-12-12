
import UIKit

struct UserDetail:Codable {
    var avatar:String?
    var fullName:String?
}

struct User:Codable {
    var _id:String?
    var details:UserDetail?
}

struct Attachment:Codable {
    var url:String?
    var type:String?
    var size:Int?
    var name:String?
}

struct Message: Codable {
    var conversationId:String?
    var customerId:String?
    var user:User?
    var content:String?
    var createdAt:Int64?
    var attachments:[Attachment?]?
}

struct MessageSubsData: Codable {
    var conversationMessageInserted:Message?
}

struct MessageSubsPayload:Codable {
    var data:MessageSubsData?
}

struct MessageSubs:Codable {
    var payload:MessageSubsPayload?
}
