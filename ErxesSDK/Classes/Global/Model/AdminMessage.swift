//
//  AdminMessage.swift
//  ErxesSDK
//
//  Created by Soyombo bat-erdene on 5/7/19.
//

import Foundation

import UIKit

struct AdminUserDetail:Codable {
    var avatar:String?
    var fullName:String?
}

struct AdminUser:Codable {
    var _id:String?
    var details:AdminUserDetail?
}

struct AdminAttachment:Codable {
    var url:String?
    var type:String?
    var size:Int?
    var name:String?
}

struct AdminMessage: Codable {
    var conversationId:String?
    var customerId:String?
    var user:AdminUser?
    var content:String?
    var createdAt:Int64?
    var attachments:[AdminAttachment?]?
}

struct AdminMessageSubsData: Codable {
    var conversationAdminMessageInserted:AdminMessage?
}

struct AdminMessageSubsPayload:Codable {
    var data:AdminMessageSubsData?
}

struct AdminMessageSubs:Codable {
    var payload:AdminMessageSubsPayload?
}
