//
//  Users.swift
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

class User {
    
    
    // User Variables
    var name: String = ""
    var profPicURL: String = ""
    var uid: String = ""
    
    
    // Initiating variables
    init(key:String, userDict: [String: AnyObject])
    {
        uid = key
        
        
        if let username = userDict[Constants.UserFields.name] as? String{
            name = username
        }
        
        if let pic = userDict[Constants.UserFields.profPicURL] as? String{
            profPicURL = pic
        }
        
    }
    
    
    
    func getProfilePic(withBlock: @escaping (UIImage) -> Void) {
        let storageRef = FIRStorage.storage().reference()
        let imageRef = storageRef.child(profPicURL)
        
        imageRef.data(withMaxSize: 1 * 1024 * 1024, completion: { (data, error) -> Void in
            if (error != nil) {
                print("An error occured: \(error)")
            } else {
                let image = UIImage(data: data!)
                withBlock(image!)
            }
        })
    }
    
    
    func getUser(UserID: String, withBlock: @escaping (User) -> Void)  {
        //        setData()
        let ref = FIRDatabase.database().reference()
        ref.child("User").child(UserID).observe(.value, with:  { snapshot -> Void in
            //  Get user name value
            if snapshot.exists() {
                if let userDict = snapshot.value as? [String: AnyObject]  {
                    let user = User(key: snapshot.key, userDict: userDict)
                    withBlock(user)
                }
            }
        })
    }
    
    
    
}
