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


class ChatIndexViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var chatIndexTableView: UITableView!
    @IBOutlet weak var noChatsLabel: UILabel!
    
    private var docReference: DocumentReference?
    var dataSource: [String] = []
    var userName: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        chatIndexTableView.isHidden = true
        noChatsLabel.isHidden = true
        chatIndexTableView.delegate = self
        chatIndexTableView.dataSource = self
        debugPrint("username is \(userName)")
        let db = Firestore.firestore().collection("Chats")
            .whereField("users", arrayContains: self.userName)
    
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
                        
                        let chat = Chat(dictionary: doc.data())
                        if let user1 = chat?.users[0], let user2 = chat?.users[1] {
                            self.dataSource.append(user1 != self.userName ? user1 : user2)
                        }
                        self.chatIndexTableView.reloadData()
                    }
                } else {
                    print("Let's hope this error never prints!")
                }
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = chatIndexTableView.dequeueReusableCell(withIdentifier: "chatIndexCell", for: indexPath)
        cell.textLabel?.text = dataSource[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChatVC") as! ChatViewController
        vc.user1Name = userName
        vc.user2Name = dataSource[indexPath.row]
        present(vc, animated: true)
    }
    
    @IBAction func didPressBackButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
}
