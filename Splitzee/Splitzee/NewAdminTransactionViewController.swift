//
//  NewAdminTransactionViewController.swift
//  Splitzee
//
//  Created by Vidya Ravikumar on 11/16/16.
//  Copyright © 2016 Mohit Katyal. All rights reserved.
//
import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage

class NewAdminTransactionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    var background: UIImageView!
    var userSelectTextField: UITextField!
    var amountTextField: UITextField!
    var descriptionTextField: UITextView!
    var payButton: UIButton!
    var requestButton: UIButton!
    var collectionView: UICollectionView!
    let constants = Constants()
    var groupID: String!
    var currUser: CurrentUser!
    
    
    let rootRef: FIRDatabaseReference! = nil
    //var key: UInt!
    var membersList = [User]()
    var selectedMembers = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currUser = CurrentUser()
        setUpUI()
        pollForUsers()
        setupCollectionView()
        
        // Do any additional setup after loading the view.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUpUI() {
        
        background = UIImageView(image: #imageLiteral(resourceName: "whiteBlueGradientBG"))
        background.frame = view.frame
        self.view.addSubview(background)
        
        setupNavBar()
        
        userSelectTextField = UITextField(frame: CGRect(x: 0, y: 0.306 * view.frame.height , width: view.frame.width, height: view.frame.height * 0.061))
        userSelectTextField.layer.masksToBounds = true
        userSelectTextField.backgroundColor = UIColor.white
        userSelectTextField.layer.borderColor = constants.fontLightGray.cgColor
        userSelectTextField.layer.borderWidth = 1
        userSelectTextField.placeholder = "     Enter name, @username, or select above"
        view.addSubview(userSelectTextField)
        
        amountTextField = UITextField(frame: CGRect(x: 0, y: 0.367 * view.frame.height , width: view.frame.width, height: view.frame.height * 0.061))
        amountTextField.layer.masksToBounds = true
        amountTextField.backgroundColor = UIColor.white
        amountTextField.layer.borderColor = constants.fontLightGray.cgColor
        amountTextField.placeholder = "     $0.00"
        view.addSubview(amountTextField)
        
        descriptionTextField = UITextView(frame: CGRect(x: 0, y: 0.428 * view.frame.height , width: view.frame.width, height: view.frame.height * 0.164))
        descriptionTextField.layer.masksToBounds = true
        descriptionTextField.backgroundColor = UIColor.white
        descriptionTextField.layer.borderColor = constants.fontLightGray.cgColor
        descriptionTextField.layer.borderWidth = 1
        descriptionTextField.delegate = self
        descriptionTextField.text = "     Add a short description of the transaction"
        descriptionTextField.textColor = constants.fontLightGray
        view.addSubview(descriptionTextField)
        
        payButton = UIButton(frame: CGRect(x: 0, y: 0.590*view.frame.height , width: 0.4985 * view.frame.width, height: view.frame.height * 0.089))
        payButton.layer.masksToBounds = true
        payButton.backgroundColor = constants.mediumBlue
        payButton.setTitle("Confirm Payment", for: .normal)
        payButton.setTitleColor(UIColor.white, for: .normal)
        payButton.layer.cornerRadius = 2
        //payButton.addTarget(self, action: #selector(pressPay), for: .touchUpInside)
        view.addSubview(payButton)
        
        requestButton = UIButton(frame: CGRect(x: 0.5015 * view.frame.width, y: 0.590 * view.frame.height , width: 0.4985 * view.frame.width, height: view.frame.height * 0.089))
        requestButton.layer.masksToBounds = true
        requestButton.setTitle("Request Money", for: .normal)
        requestButton.backgroundColor = constants.mediumBlue
        requestButton.setTitleColor(UIColor.white, for: .normal)
        requestButton.layer.cornerRadius = 2
        view.addSubview(requestButton)
    }
    
    func setupNavBar() {
        self.title = "New Transaction"
    }
    
    func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        collectionView = UICollectionView(frame: CGRect(x: 0 , y: 80, width: 0.988 * view.frame.width, height: userSelectTextField.frame.minY - 64) , collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(NewAdminTransactionCollectionViewCell.self, forCellWithReuseIdentifier: "adminTransactionCell")
        collectionView.backgroundColor = UIColor.clear
        
        view.addSubview(collectionView)
    }
    
    
    
    //-------------------- Functions---------------------------------------------------
    
    
    
    func pollForUsers(){
        rootRef.child("User").queryOrderedByKey().observe(.childAdded, with: {
            snapshot in
            let userKey = snapshot.key as String
            let userDict = snapshot.value as? [String: AnyObject]
            let user = User(key: userKey, userDict: userDict!)
            self.membersList.insert(user, at: 0)
        })
        DispatchQueue.main.async {
            self.collectionView.reloadData()
            
        }
    }
        
    func pressPay(sender: UIButton!)
    {
        for member in selectedMembers {
            var amt = amountTextField.text!
            amt.remove(at: (amt.startIndex))
            let amount: Double = (Double)(amt)!
            newTransaction(amt: (String)(amount), memberID: member.uid, groupToMember: true)
        }
    }
    
        
        
    func pressRequest(sender: UIButton)
    {
        for member in selectedMembers {
            var amt = amountTextField.text!
            amt.remove(at: (amt.startIndex))
            let amount: Double = (Double)(amt)!
            newTransaction(amt: (String)(amount), memberID: member.uid, groupToMember: false)
        }
    }
    
    func newTransaction(amt: String, memberID: String, groupToMember: Bool) {
        let transactionDict: [String:AnyObject]
        
        transactionDict = ["amount": amt as AnyObject, "memberID": memberID as AnyObject, "groupID": groupID as AnyObject, "groupToMember": groupToMember as AnyObject, "isApproved": true as AnyObject]
        
        let rootRef = FIRDatabase.database().reference()
        let key = rootRef.child("Transaction").childByAutoId().key
        rootRef.child("Transaction").child(key).setValue(transactionDict)
        dismiss(animated: true, completion: nil)
    }
        
        
//-------------------Setting up collectionView--------------------
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // should be returning the number of users
        return membersList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "adminTransactionCell", for: indexPath) as! NewAdminTransactionCollectionViewCell
        for subview in cell.contentView.subviews {
            subview.removeFromSuperview()
        }
        cell.awakeFromNib()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let adminTransactionCell = cell as! NewAdminTransactionCollectionViewCell
        //adminTransactionCell.userImage.image = membersList[indexPath.row].profPicURL //Should be actual image
        adminTransactionCell.userName.text = membersList[indexPath.row].name //Should be actual user's name
        // set UI stuff
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 0.275*view.frame.width , height: 0.367*view.frame.height )
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? NewAdminTransactionCollectionViewCell
        if cell?.backgroundColor == UIColor.black {
            cell?.backgroundColor = UIColor.clear
            selectedMembers = selectedMembers.filter { $0.uid != selectedMembers[indexPath.row].uid }
        } else {
            cell?.backgroundColor = UIColor.black
            selectedMembers.append(membersList[indexPath.row])
        }
    }

}

extension NewAdminTransactionViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == self.constants.fontLightGray {
            textView.text = ""
            textView.textColor = UIColor.black
        }
    }
}



