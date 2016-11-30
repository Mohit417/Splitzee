//
//  Transactions.swift
//  Splitzee
//
//  Created by Mohit Katyal on 11/10/16.
//  Copyright © 2016 Mohit Katyal. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

class Transaction {
    
    var transactionID: String = ""
    var groupToMember: Bool = false
    var memberID: String = ""
    var groupID: String = ""
    var amount: Double = 0.00
    var isApproved: Bool = false
    var description: String = ""
    var isRejected: Bool = false
    var isFlagged: Bool = false
    
    
    init(key: String, transactionDict: [String: AnyObject]) {
        transactionID = key
        
        
        if let group = transactionDict[Constants.TransactionFields.groupID] as? String{
            groupID = group
        }
        
        if let sendToMember = transactionDict[Constants.TransactionFields.groupToMember] as? Bool{
            groupToMember = sendToMember
        }
        
        if let member = transactionDict[Constants.TransactionFields.memberID] as? String{
            memberID = member
        }
        
        if let amountSent = transactionDict[Constants.TransactionFields.amount] as? Double{
            amount = amountSent
        }
        
        if let approved = transactionDict[Constants.TransactionFields.isApproved] as? Bool{
            isApproved = approved
        }
        
        if let rejected = transactionDict[Constants.TransactionFields.isRejected] as? Bool{
            isRejected = rejected
        }
        
        if let flagged = transactionDict[Constants.TransactionFields.isFlagged] as? Bool{
            isFlagged = flagged
        }
        
        if let descriptionText = transactionDict[Constants.TransactionFields.description] as? String{
            description = descriptionText
        }
    }
    
    
    init(amount: Double, memberID: String, groupID: String, groupToMember: Bool, description: String) {
        self.amount = amount
        self.memberID = memberID
        self.groupID = groupID
        self.groupToMember = groupToMember
        self.description = description
        
    }
    
    
    func deleteTransaction() {
        let ref = FIRDatabase.database().reference()
        ref.child("Transactions/\(transactionID)").removeValue()
    }
    
    // Gets the user the group is trying to send the money to
    func getUser(withBlock: @escaping (User) -> Void ){
        let ref = FIRDatabase.database().reference()
        ref.child(Constants.DataNames.User).child(memberID).observe(.value, with: { snapshot -> Void in
            // Get user value
            if snapshot.exists(){
                if let userDict = snapshot.value as? [String: AnyObject]{
                    let user = User(key: snapshot.key, userDict: userDict)
                    withBlock(user)
                }
            }
        })
    }
    
    // Gets current group so that one can update the money of the group
    func getGroup(withBlock: @escaping (Group) -> Void) {
        let ref = FIRDatabase.database().reference()
        ref.child(Constants.DataNames.Group).child(groupID).observe(.value, with: { snapshot -> Void in
            // Get user value
            if snapshot.exists(){
                if let groupDict = snapshot.value as? [String: AnyObject]{
                    let group = Group(key: snapshot.key, groupDict: groupDict)
                    withBlock(group)
                }
            }
        })
    }
    
    // Gets current group so that one can update the money of the group
    func getCurrGroup(withBlock: @escaping (Group) -> Void) {
        let ref = FIRDatabase.database().reference()
        ref.child(Constants.DataNames.Group).child(groupID).observeSingleEvent(of: .value, with: { snapshot -> Void in
            // Get user value
            if snapshot.exists(){
                if let groupDict = snapshot.value as? [String: AnyObject]{
                    let group = Group(key: snapshot.key, groupDict: groupDict)
                    withBlock(group)
                }
            }
        })
    }
    
    func addToDatabase(withBlock: @escaping (Transaction) -> Void) {
        let transactionDict: [String:AnyObject] = [Constants.TransactionFields.amount: amount as AnyObject, Constants.TransactionFields.memberID: memberID as AnyObject, Constants.TransactionFields.groupID: groupID as AnyObject, Constants.TransactionFields.groupToMember: groupToMember as AnyObject, Constants.TransactionFields.isApproved: isApproved as AnyObject, Constants.TransactionFields.description: description as AnyObject]
        
        let rootRef = FIRDatabase.database().reference()
        let groupRef = rootRef.child(Constants.DataNames.Group).child(groupID)
        let userRef = rootRef.child(Constants.DataNames.User).child(memberID)
        
        let key = rootRef.child(Constants.DataNames.Transaction).childByAutoId().key
        transactionID = key
        rootRef.child(Constants.DataNames.Transaction).child(key).updateChildValues(transactionDict)
        
        var userTransactionIDs = [String]()
        var groupTransactionIDs = [String]()
        

        userRef.observeSingleEvent(of: .value, with: { (snapshot) in
            let userDict = snapshot.value as! [String:AnyObject]
            
            if let transIDs = userDict[Constants.UserFields.transactionIDs] as? [String] {
                userTransactionIDs = transIDs
            }
            
            userTransactionIDs.append(key)
            userRef.child(Constants.UserFields.transactionIDs).setValue(userTransactionIDs) { (error, reference) in
                withBlock(self)
            }
        })
        
        groupRef.observeSingleEvent(of: .value, with: { (snapshot) in
            let groupDict = snapshot.value as! [String:AnyObject]
            
            if let transIDs = groupDict[Constants.GroupFields.transactionIDs] as? [String] {
                groupTransactionIDs = transIDs
            }
            
            groupTransactionIDs.append(key)
            groupRef.child(Constants.GroupFields.transactionIDs).setValue(groupTransactionIDs)
        })
    }
    
    /*
     func getTransactions(withBlock: @escaping (Transaction) -> Void) {
     let ref = FIRDatabase.database().reference()
     for id in transactionID {
     ref.child("Transactions").child(id).observe(.value, with: { (snapshot) in
     let curr = Transaction(key: id, transactionDict: snapshot.value as! [String : AnyObject])
     withBlock(curr)
     })
     }
     }
     */
    
    
    func rejectTransaction() {
        isApproved = true
        isRejected = true
        
        let ref = FIRDatabase.database().reference()
        ref.child(Constants.DataNames.Transaction).child(transactionID).child(Constants.TransactionFields.isApproved).setValue(isApproved)
        ref.child(Constants.DataNames.Transaction).child(transactionID).child(Constants.TransactionFields.isRejected).setValue(isRejected)
    }
    
    func flagTransaction() {
        isApproved = true
        isFlagged = true
        
        let ref = FIRDatabase.database().reference()
        ref.child(Constants.DataNames.Transaction).child(transactionID).child(Constants.TransactionFields.isApproved).setValue(isApproved)
        ref.child(Constants.DataNames.Transaction).child(transactionID).child(Constants.TransactionFields.isFlagged).setValue(isFlagged)
    }
    
    /* In the feed for our pending requests, it will now look for transactions
     that have the approved value of "false". Once it is set to true, the history
     feed will now include this request*/
    
    func approveTransaction(){
        isApproved = true
        
        let ref = FIRDatabase.database().reference()
        ref.child(Constants.DataNames.Transaction).child(transactionID).child(Constants.TransactionFields.isApproved).setValue(true)
        
        // update money
        getCurrGroup(withBlock: { (group) -> Void in
            group.addToTotal(amount: self.amount)
        })
        
    }
}
