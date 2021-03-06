//
//  Chat.swift
//  abseil
//
//  Created by Ioana Bojinca on 24/03/2021.
//

import Foundation
import Firebase
import MessageKit

struct Chat {
    
    var users: [String]
    
    var dictionary: [String: Any] {
        return [
            "users": users
        ]
    }
}

extension Chat {
    
    init?(dictionary: [String:Any]) {
        guard let chatUsers = dictionary["users"] as? [String] else {return nil}
        self.init(users: chatUsers)
    }
    
}

struct Message {
    
    var id: String
    var content: String
    var created: Timestamp
    var senderID: String
    var senderName: String
    var receiverID: String
    var receiverName: String
    
    var dictionary: [String: Any] {
        
        return [
            "id": id,
            "content": content,
            "created": created,
            "senderID": senderID,
            "senderName": senderName,
            "receiverID": receiverID,
            "receiverName": receiverName
        ]
        
    }
}

extension Message {
    init?(dictionary: [String: Any]) {
        
        guard let id = dictionary["id"] as? String,
            let content = dictionary["content"] as? String,
            let created = dictionary["created"] as? Timestamp,
            let senderID = dictionary["senderID"] as? String,
            let senderName = dictionary["senderName"] as? String,
            let receiverID = dictionary["receiverID"] as? String,
            let receiverName = dictionary["receiverName"] as? String
            else {return nil}
        
        self.init(id: id, content: content, created: created, senderID: senderID, senderName:senderName, receiverID: receiverID, receiverName: receiverName)
        
    }
}

extension Message: MessageType {
    
    var sender: SenderType {
        return Sender(id: senderID, displayName: senderName)
    }
    
    var messageId: String {
        return id
    }
    
    var sentDate: Date {
        return created.dateValue()
    }
    
    var kind: MessageKind {
        return .text(content)
    }
}
