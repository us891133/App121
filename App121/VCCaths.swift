//
//  VCCaths.swift
//  App121
//
//  Created by ios on 2018/2/2.
//  Copyright © 2018年 pcschool.com. All rights reserved.
//

import UIKit
import Firebase
import JSQMessagesViewController

class VCCaths: JSQMessagesViewController {
    
    private lazy var messageRef: DatabaseReference = Database.database().reference().child("messages")
    private var newMessageRefHandle: DatabaseHandle?
    
    
var messages = [JSQMessage]()
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return messages[indexPath.item]
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("message count = \(messages.count)")
        return messages.count
    }
    private func setupOutgoingBubble() -> JSQMessagesBubbleImage {
        let bubbleImageFactory = JSQMessagesBubbleImageFactory()
        return bubbleImageFactory!.outgoingMessagesBubbleImage(with: UIColor.jsq_messageBubbleBlue())
    }
    
    lazy var outgoingBubbleImageView: JSQMessagesBubbleImage = self.setupOutgoingBubble()
    lazy var incomingBubbleImageView: JSQMessagesBubbleImage = self.setupIncomingBubble()
    
    private func setupIncomingBubble() -> JSQMessagesBubbleImage {
        let bubbleImageFactory = JSQMessagesBubbleImageFactory()
        return bubbleImageFactory!.incomingMessagesBubbleImage(with: UIColor.jsq_messageBubbleLightGray())
    }
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        let message = messages[indexPath.item] // 1
        if message.senderId == senderId { // 2
            return outgoingBubbleImageView as! JSQMessageAvatarImageDataSource
        } else { // 3
            return incomingBubbleImageView as! JSQMessageAvatarImageDataSource
        }
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        let message = messages[indexPath.item] // 1
        if message.senderId == senderId { // 2
            return outgoingBubbleImageView
        } else { // 3
            return incomingBubbleImageView
        }
//        return nil
    }
    
    private func addMessage(withId id: String, name: String, text: String) {
        if let message = JSQMessage(senderId: id, displayName: name, text: text) {
            messages.append(message)
        }
    }
    //addMessage(withId: "foo", name: "Mr.Bolt", text: "I am so fast!")
    // messages sent from local sender
    //addMessage(withId: senderId, name: "Me", text: "I bet I can run faster than you!")
   // addMessage(withId: senderId, name: "Me", text: "I like to run!")
    // animates the receiving of a new message on the view
    //finishReceivingMessage()
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
        let message = messages[indexPath.item]
        
        if message.senderId == senderId {
            cell.textView?.textColor = UIColor.white
        } else {
            cell.textView?.textColor = UIColor.black
        }
        return cell
    }
    
    
    
    
    override func didPressSend(_ button: UIButton!, withMessageText text:
        String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        let messageRef = self.self.messageRef.childByAutoId() // 1
        let messageItem = [ // 2
            "senderId": senderId!,
            "senderName": senderDisplayName!,
            "text": text!,
            ]
        messageRef.setValue(messageItem) // 3
        JSQSystemSoundPlayer.jsq_playMessageSentSound() // 4
        finishSendingMessage() // 5
        isTyping = false
    }
    
    private func observeMessages() {
        //        messageRef = channelRef!.child("messages")
        // 1.
        let messageQuery = messageRef.queryLimited(toLast:25)
        // 2. We can use the observe method to listen for new
        // messages being written to the Firebase DB
        newMessageRefHandle = messageQuery.observe(.childAdded, with: { (snapshot) -> Void in
            // 3
            let messageData = snapshot.value as! Dictionary<String, String>
            if let id = messageData["senderId"] as String!, let name = messageData["senderName"]
                as String!, let text = messageData["text"] as String!, text.count > 0 {
                // 4
                self.addMessage(withId: id, name: name, text: text)
                // 5
                self.finishReceivingMessage()
            }else {
                    print("Error! Could not decode message data")
            }
            
        })
    }
    
    override func textViewDidChange(_ textView: UITextView) {
        super.textViewDidChange(textView)
        // If the text is not empty, the user is typing
        print(textView.text != "")
        isTyping = textView.text != ""
    }
    
    private lazy var userIsTypingRef: DatabaseReference=Database.database().reference().child("typingIndicator").child(self.senderId) // 1
    private var localTyping = false // 2
    var isTyping: Bool {
        get {
            return localTyping
        }
        set {
            // 3
            localTyping = newValue
            userIsTypingRef.setValue(newValue)
        }
    }
    
    // ssss
    private func observeTyping() {
        let typingIndicatorRef = Database.database().reference().child("typingIndicator")
        userIsTypingRef = typingIndicatorRef.child(senderId)
        userIsTypingRef.onDisconnectRemoveValue()
    
    usersTypingQuery.observe(.value) { (data: DataSnapshot) in
    // 2 You're the only one typing, don't show the indicator
    if data.childrenCount == 1 && self.isTyping {
    return
    }
    
    // 3 Are there others typing?
    self.showTypingIndicator = data.childrenCount > 0
    self.scrollToBottom(animated: true)
    }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        observeTyping()
    }
    
    private lazy var usersTypingQuery: DatabaseQuery=Database.database().reference().child("typingIndicator").queryOrderedByValue().queryEqual(toValue: true)

    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView!.collectionViewLayout.incomingAvatarViewSize = CGSize.zero
        collectionView!.collectionViewLayout.outgoingAvatarViewSize = CGSize.zero
        
        // Do any additional setup after loading the view.
        
        
        self.senderId=Auth.auth().currentUser?.uid
        self.senderDisplayName="AAAA"
        observeMessages()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
