//
//  ChatIndexViewController.swift
//  DnD Character Tracker
//
//  Created by Ioana Bojinca on 24/03/2021.
//  Copyright © 2021 Ioana Bojinca. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseDatabase

struct UserMessageData: Equatable {
 
    var user: UserData
    var messages: Message
    
    static func == (lhs: UserMessageData, rhs: UserMessageData) -> Bool {
        return lhs.user == rhs.user
     }
     
}


class ChatIndexViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var chatIndexTableView: UITableView!
    @IBOutlet weak var noChatsLabel: UILabel!
    
    private var docReference: DocumentReference?
    var databaseReference: DatabaseReference! = Database.database().reference()
    
    var dataSource: [String] = []
    var userName: String = ""
    var currentUser: User = Auth.auth().currentUser!
    var userMessageData: [UserMessageData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        chatIndexTableView.isHidden = true
        noChatsLabel.isHidden = true
        chatIndexTableView.delegate = self
        chatIndexTableView.dataSource = self
        
        let db = Firestore.firestore().collection("Chats")
            .whereField("users", arrayContains: self.currentUser.uid)
        
        db.getDocuments { (chatQuerySnap, error) in
            if let error = error {
                print("Error: \(error)")
                return
            } else {
                guard let queryCount = chatQuerySnap?.documents.count else {
                    return
                }
                if queryCount == 0 {
                    self.noChatsLabel.isHidden = false
                    self.chatIndexTableView.isHidden = true
                }
                else if queryCount >= 1 {
                    self.noChatsLabel.isHidden = true
                    self.chatIndexTableView.isHidden = false
                    
                    for doc in chatQuerySnap!.documents {
                        doc.reference.collection("thread")
                            .order(by: "created", descending: true)
                            .addSnapshotListener(includeMetadataChanges: true, listener: { (threadQuery, error) in
                                if let error = error {
                                    print("Error: \(error)")
                                    return
                                } else {
                                    //sender ID poate sa fie si propriul ID
                                    //adauga proprietate de reciever ID? la struct de message
                                    // & reciever name
                                    if let data = threadQuery?.documents.first?.data() {
                                        if let message = Message(dictionary: data) {
                                            if message.senderID != self.currentUser.uid {
                                                let userData = UserData(uid: message.senderID , username: message.senderName)
                                                self.userMessageData.append(UserMessageData(user: userData, messages: message ))
                                            } else {
                                                let userData = UserData(uid: message.receiverID , username: message.receiverName)
                                                self.userMessageData.append(UserMessageData(user: userData, messages: message ))
                                            }
                                          self.userMessageData.removeDuplicates()
                                            self.chatIndexTableView.reloadData()
                                        }
                                        
                                    }
                                }
                            })
                        self.userMessageData.removeDuplicates()
                        self.chatIndexTableView.reloadData()
                    }
                } else {
                    print("Let's hope this error never prints!")
                }
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userMessageData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = chatIndexTableView.dequeueReusableCell(withIdentifier: "chatIndexCell", for: indexPath)
        cell.textLabel?.text = userMessageData[indexPath.row].user.username
        cell.detailTextLabel?.text = "\(userMessageData[indexPath.row].messages.sentDate.description)\n\(userMessageData[indexPath.row].messages.senderName): \(userMessageData[indexPath.row].messages.content)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChatVC") as! ChatViewController
        vc.user1Name = userName
        vc.user2Name = userMessageData[indexPath.row].user.username
        vc.user2UID = userMessageData[indexPath.row].user.uid
        present(vc, animated: true)
    }
    
    @IBAction func didPressBackButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
}
