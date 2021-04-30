
//  ChatViewController.swift
//
//  Created by Ioana Bojinca on 19/03/2021.
//

import UIKit
import InputBarAccessoryView
import Firebase
import MessageKit
import FirebaseFirestore

class ChatViewController: MessagesViewController, InputBarAccessoryViewDelegate, MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate {
    
    var currentUser: User = Auth.auth().currentUser!
    var user1Name: String? //current username
    var user2Name: String? //username for second user
    var user2UID: String? // second user uid
    private var docReference: DocumentReference?
    
    var messages: [Message] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        maintainPositionOnKeyboardFrameChanged = true
        messageInputBar.inputTextView.tintColor = .systemBlue
        messageInputBar.sendButton.setTitleColor(.systemBlue, for: .normal)
        messageInputBar.delegate = self
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        
        navigationItem.title = user2Name ?? "Chat"
        let backButton = UIBarButtonItem(title: "< CHATS", style: .plain, target: self, action: #selector(onCancel))
        navigationItem.leftBarButtonItem = backButton
        loadChat()
        
    }
    
    @objc func onCancel(){
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Custom messages handlers
    
    func createNewChat() {
        let users = [self.currentUser.uid, self.user2UID]
        let data: [String: Any] = [
            "users":users
        ]
        
        let db = Firestore.firestore().collection("Chats")
        db.addDocument(data: data) { (error) in
            if let error = error {
                print("Unable to create chat! \(error)")
                return
            } else {
                self.loadChat()
            }
        }
    }
    
    func loadChat() {
        
      
        //Fetch all the chats which has current user in it
        let db = Firestore.firestore().collection("Chats")
                .whereField("users", arrayContains: Auth.auth().currentUser?.uid ?? "Not Found User 1")
        
        
        db.getDocuments { (chatQuerySnap, error) in
            
            if let error = error {
                print("Error: \(error)")
                return
            } else {
                
                //Count the no. of documents returned
                guard let queryCount = chatQuerySnap?.documents.count else {
                    return
                }
                
                if queryCount == 0 {
                    self.createNewChat()
                }
                else if queryCount >= 1 {
                    for doc in chatQuerySnap!.documents {
                        
                        let chat = Chat(dictionary: doc.data())
                        //Get the chat which has user2 id
                        if (chat?.users.contains(self.user2UID!))! {
                            
                            self.docReference = doc.reference
                            //fetch it's thread collection
                             doc.reference.collection("thread")
                                .order(by: "created", descending: false)
                                .addSnapshotListener(includeMetadataChanges: true, listener: { (threadQuery, error) in
                            if let error = error {
                                print("Error: \(error)")
                                return
                            } else {
                                self.messages.removeAll()
                                    for message in threadQuery!.documents {

                                        let msg = Message(dictionary: message.data())
                                        self.messages.append(msg!)
                                      //  print("Data: \(msg?.content ?? "No message found")")
                                    }
                                self.messagesCollectionView.reloadData()
                                self.messagesCollectionView.scrollToLastItem(animated: true)
                            }
                            })
                            return
                        } //end of if
                    } //end of for
                    self.createNewChat()
                } else {
                    print("Let's hope this error never prints!")
                }
            }
        }
    }
    
    
    private func insertNewMessage(_ message: Message) {
        messages.append(message)
        messagesCollectionView.reloadData()
        DispatchQueue.main.async {
            self.messagesCollectionView.scrollToLastItem(animated: true)
        }
    }
    
    private func save(_ message: Message) {
        
        let data: [String: Any] = [
            "content": message.content,
            "created": message.created,
            "id": message.id,
            "senderID": message.senderID,
            "senderName": message.senderName,
            "receiverID": message.receiverID,
            "receiverName": message.receiverName
        ]
        
        docReference?.collection("thread").addDocument(data: data, completion: { (error) in
            
            if let error = error {
                print("Error Sending message: \(error)")
                return
            }
            
            self.messagesCollectionView.scrollToLastItem()
            
        })
    }
    
    // MARK: - InputBarAccessoryViewDelegate
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        
        let message = Message(id: UUID().uuidString, content: text, created: Timestamp(), senderID: currentUser.uid , senderName: user1Name ?? "none", receiverID: user2UID ?? "none", receiverName: user2Name ?? "n/a")
        
        insertNewMessage(message)
        save(message)
        
        inputBar.inputTextView.text = ""
        messagesCollectionView.reloadData()
        messagesCollectionView.scrollToLastItem(animated: true)
    }
    
    
    // MARK: - MessagesDataSource
    func currentSender() -> SenderType {
        return Sender(senderId: currentUser.uid , displayName: user1Name ?? "Name not found")
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        
        if messages.count == 0 {
            print("No messages to display")
            return 0
        } else {
            return messages.count
        }
    }
    
    
    // MARK: - MessagesLayoutDelegate

    func cellTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 20.0
    }
    
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        avatarView.isHidden = true
    }
    func avatarSize(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGSize {
        return .zero
    }
    
    func messageTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 20.0
    }
    
    func messageTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        let myString = (isFromCurrentSender(message: message) ? user1Name ?? "Unknown" :  user2Name ?? "Unknown")
        let range = (myString as NSString).range(of: myString)

        let mutableAttributedString = NSMutableAttributedString.init(string: myString)
        mutableAttributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: (isFromCurrentSender(message: message) ? UIColor.systemBlue : UIColor.systemGray2), range: range)
        mutableAttributedString.addAttribute(NSAttributedString.Key.strokeWidth, value: 4.0, range: range)
        mutableAttributedString.addAttribute(NSAttributedString.Key.backgroundColor, value: UIColor.clear, range: range)
        return mutableAttributedString
    }

 
    // MARK: - MessagesDisplayDelegate
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? .systemBlue: .systemGray2
    }
    
    func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return .white
    }
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        
        let corner: MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight: .bottomLeft
        return .bubbleTail(corner, .curved)
        
    }
    
}
