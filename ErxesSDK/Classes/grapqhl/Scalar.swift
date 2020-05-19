//
//  Scalar.swift
//  Erxes iOS SDK
//
//  Created by Soyombo bat-erdene on 4/23/20.
//  Copyright © 2020 Soyombo bat-erdene. All rights reserved.
//

import Apollo

public typealias Scalar_JSON = [String: Any?]
public typealias Scalar_Date = Date

extension Date: JSONDecodable, JSONEncodable {
    public var jsonValue: JSONValue {
        let dateFormatter = DateFormatter()

        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        dateFormatter.timeZone = TimeZone(identifier: "GMT")
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        return dateFormatter.string(from: self)
    }

    public init(jsonValue value: JSONValue) throws {
        guard let isoString = value as? String else {
            throw JSONDecodingError.couldNotConvert(value: value, to: Date.self)
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        dateFormatter.timeZone = TimeZone(identifier: "GMT")
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")

        guard let date = dateFormatter.date(from: isoString) else {
            throw JSONDecodingError.couldNotConvert(value: value, to: Date.self)
        }
        self = date
    }
}

extension Dictionary: JSONDecodable {
    /// Custom `init` extension so Apollo can decode custom scalar type `CurrentMissionChallenge `
    public init(jsonValue value: JSONValue) throws {
        guard let dictionary = value as? Dictionary else {
            throw JSONDecodingError.couldNotConvert(value: value, to: Dictionary.self)
        }
        self = dictionary
    }
}


struct MessengerData: Decodable {
    let links: SocialLinks?
    let supporterIds: [String?]?
    let requireAuth: Bool?
    let showChat: Bool?
    let showLauncher: Bool?
    let forceLogoutWhenResolve: Bool?
    let isOnline: Bool?
    let timezone: String?
    let messages: ErxesMessages?
    let knowledgeBaseTopicId: String?
    let websiteApps: [WebsiteApp?]?
    let formCode: String?
}


struct SocialLinks: Decodable {
    let twitter: String?
    let facebook: String?
    let youtube: String?

}

struct ErxesMessages: Decodable {
    let greetings: Greetings?
    let welcome: String?
    let away: String?
    let thank: String?
}

struct Greetings: Decodable {
    let title: String?
    let message: String?
}

struct WebsiteApp: Decodable {
    let showInInbox: Bool
    let scopeBrandIds: [String?]
    let _id: String?
    let name: String?
    let kind: String?
    let credentials: Credentials?
}

struct Credentials: Decodable {
    let integrationId: String?
    let description: String?
    let buttonText: String?
    let url: String?
}

struct UIOptions: Decodable {
    let color: String?
    let wallpaper: String?
    let logo: String?
    let videoCallUsageStatus: Bool?
}


struct LeadData: Decodable {
    let adminEmails: [String?]?
    let rules:[String?]?
    let loadType: String?
    let successAction: String?
    let fromEmail: String?
    let userEmailTitle: String?
    let userEmailContent: String?
    let adminEmailTitle: String?
    let adminEmailContent: String?
    let thankContent: String?
    let redirectUrl: String?
    let themeColor: String?
    let callout: CallOut?
    let contactsGathered: Int?
}


struct CallOut:Decodable {
    let title: String?
    let body: String?
    let buttonText: String?
    let featuredImage: String?
    let skip:Bool?
}
    



extension Decodable {

    init(from value: Any,
         options: JSONSerialization.WritingOptions = [],
         decoder: JSONDecoder) throws {
        let data = try JSONSerialization.data(withJSONObject: value, options: options)
        self = try decoder.decode(Self.self, from: data)
    }

    init(from value: Any,
         options: JSONSerialization.WritingOptions = [],
         decoderSetupClosure: ((JSONDecoder) -> Void)? = nil) throws {
        let decoder = JSONDecoder()
        decoderSetupClosure?(decoder)
        try self.init(from: value, options: options, decoder: decoder)
    }

    init?(discardingAnErrorFrom value: Any,
          printError: Bool = false,
          options: JSONSerialization.WritingOptions = [],
          decoderSetupClosure: ((JSONDecoder) -> Void)? = nil) {
        do {
            try self.init(from: value, options: options, decoderSetupClosure: decoderSetupClosure)
        } catch {
            if printError { print("\(Self.self) decoding ERROR:\n\(error)") }
            return nil
        }
    }
}
