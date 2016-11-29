//
//  MemberPageViewController.swift
//  Splitzee
//
//  Created by Vidya Ravikumar on 11/16/16.
//  Copyright © 2016 Mohit Katyal. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase



class MemberPageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var segmentedView: UISegmentedControl!
    var groupsButton: UIButton!
    var newTransactionButton: UIButton!
    var tableView: UITableView!
    var backgroundGradient: UIImageView!
    var pending = true
    var currUser: CurrentUser!
    let constants = Constants()
    var group: Group!
    var user: User!
    var listState = ListState.incoming

    var transactionList: [Transaction] = []
    var historyList: [Transaction] = []
    var incomingList: [Transaction] = []
    var outgoingList: [Transaction] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let dbRef = FIRDatabase.database().reference()
        let uid = FIRAuth.auth()?.currentUser?.uid
        if let uid = uid {
            dbRef.child(Constants.DataNames.User).child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
                // Get user value
                self.currUser = CurrentUser(key: uid, currentUserDict: snapshot.value as! [String: AnyObject])
                DispatchQueue.main.async {
                    self.setupUI()
                }
                
            }) { (error) in
                print(error.localizedDescription)
            }
        }
        
    }
    
    func setupUI() {
        
        backgroundGradient = UIImageView(frame: view.frame)
        backgroundGradient.image = #imageLiteral(resourceName: "whiteBlueGradientBG")
        view.addSubview(backgroundGradient)
        
        groupsButton = UIButton(frame: CGRect(x: view.frame.width * 0.053, y: view.frame.height * 0.143, width: view.frame.width * 0.058, height: view.frame.height * 0.032))
        groupsButton.setImage(#imageLiteral(resourceName: "menuSymbol"), for: .normal)
        groupsButton.imageView?.contentMode = .scaleAspectFill
        groupsButton.addTarget(self, action: #selector(groupsPressed), for: .touchUpInside)
        view.addSubview(groupsButton)
        
        newTransactionButton = UIButton(frame: CGRect(x: view.frame.width * 0.896, y: view.frame.height * 0.138, width: view.frame.width * 0.058, height: view.frame.height * 0.032))
        newTransactionButton.setTitle("+", for: .normal)
        newTransactionButton.titleLabel?.font = UIFont(name: "SFUIText-Light", size: 43)
        newTransactionButton.setTitleColor(constants.fontMediumBlue, for: .normal)
        newTransactionButton.imageView?.contentMode = .scaleAspectFit
        newTransactionButton.addTarget(self, action: #selector(newTransactionPressed), for: .touchUpInside)
        view.addSubview(newTransactionButton)
        
        setupNavBar()
        setupSegmentedControl()
        setupTableView()
        setUpTableLists()
    }
    
    func newTransactionPressed() {
        performSegue(withIdentifier: "memberPageToNewMemberTransaction", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "memberPageToNewMemberTransaction" {
            let nextVC = segue.destination as! NewMemberTransactionViewController
            nextVC.group = group
        }
    }
    
    func groupsPressed() {
        //        performSegue(withIdentifier: "memberToSideBar", sender: self)
        dismiss(animated: true, completion: nil)
    }
    
    func setupNavBar() {
        self.title = "Group Name" // change to group name
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: constants.fontMediumBlue, NSFontAttributeName: UIFont(name: "SFUIText-Light", size: 20)!]
        self.navigationController?.navigationBar.barTintColor = UIColor.white
    }
    
    func setupSegmentedControl() {
        let items = ["Incoming", "Outgoing", "History"]
        let attr = NSDictionary(object: UIFont(name: "SFUIText-Regular", size: 14.0)!, forKey: NSFontAttributeName as NSCopying)
        UISegmentedControl.appearance().setTitleTextAttributes(attr as [NSObject : AnyObject] , for: .normal)
        segmentedView = UISegmentedControl(items: items)
        segmentedView.selectedSegmentIndex = 0
        segmentedView.frame = CGRect(x: view.frame.width * 0.142, y: view.frame.height * 0.140, width: view.frame.width * 0.720, height: 28)
        segmentedView.layer.cornerRadius = 3
        segmentedView.backgroundColor = UIColor.white
        segmentedView.tintColor = constants.mediumBlue
        segmentedView.addTarget(self, action: #selector(switchView), for: .valueChanged)
        view.addSubview(segmentedView)
    }
    
    func setupTableView() {
        tableView = UITableView(frame: CGRect(x: 0, y: view.frame.height * 0.185, width: view.frame.width, height: view.frame.height * 0.820))
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MemberPendingTableViewCell.self, forCellReuseIdentifier: "pendingMemberCell")
        tableView.register(MemberHistoryTableViewCell.self, forCellReuseIdentifier: "historyMemberCell")
        view.addSubview(tableView)
    }
    
    func switchView(sender: UISegmentedControl) {
        if (sender.selectedSegmentIndex == 0) {
            pending = true
            listState = .incoming
            //more
        } else if (sender.selectedSegmentIndex == 1) {
            pending = true
            listState = .outgoing
            //more
        } else {
            pending = false
            listState = .history
            //more
        }
    }
    


    //-----------------functions----------------------------------
    
    //Create lists for different tables
    func setUpTableLists(){
        currUser.getTransactions(withBlock: {(trans) -> Void in
            print(trans)
            self.transactionList.append(trans)
            if trans.isApproved == false {
                self.historyList.append(trans)
            }
            else if trans.groupToMember == false {
                self.outgoingList.append(trans)
            }
            else {
                self.incomingList.append(trans)
            }
            self.tableView.reloadData()
            
        })
    }
    
    
    //-----------------Sets up the tableviews---------------------------
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch(segmentedView.selectedSegmentIndex)
        {
        case 0:
            return incomingList.count
            
        case 1:
            return outgoingList.count
            
        case 2:
            return historyList.count
            
        default:
            return 0
            
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch(segmentedView.selectedSegmentIndex)
            
        {
            
        case 0:
            let pendingCell = tableView.dequeueReusableCell(withIdentifier: "pendingMemberCell", for: indexPath) as! AdminPendingTableViewCell
            for subview in pendingCell.contentView.subviews {
                subview.removeFromSuperview()
            }
            pendingCell.awakeFromNib()
            
            
            return pendingCell
            
        case 1:
            
            let pendingCell = tableView.dequeueReusableCell(withIdentifier: "pendingMemberCell", for: indexPath) as! AdminPendingTableViewCell
            for subview in pendingCell.contentView.subviews {
                subview.removeFromSuperview()
            }
            pendingCell.awakeFromNib()
            return pendingCell
            
        case 2:
            
            let historyCell = tableView.dequeueReusableCell(withIdentifier: "historyMemberCell", for: indexPath) as! AdminHistoryTableViewCell
            for subview in historyCell.contentView.subviews {
                subview.removeFromSuperview()
            }
            historyCell.awakeFromNib()
            return historyCell
            
            
        default:
            
            let pendingCell = tableView.dequeueReusableCell(withIdentifier: "pendingMemberCell", for: indexPath) as! AdminPendingTableViewCell
            for subview in pendingCell.contentView.subviews {
                subview.removeFromSuperview()
            }
            pendingCell.awakeFromNib()
            return pendingCell
            
            
        }
        
    }
    
    
    //Populates the cell with data
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        
        switch(segmentedView.selectedSegmentIndex)
        {
        case 0:
            
            let pendingCell = cell as? MemberPendingTableViewCell
            
            //Displays the amount of money transferred
            pendingCell?.resultLabel.text = "$" + String(describing: incomingList[indexPath.row].amount)
            
            
            //Sets the Name of each user at each index
                pendingCell?.memberNameLabel.text = group.name
        
            
            //Gets the image of the group
            group.getGroupPic(withBlock: { (UIImage) -> Void in
                    pendingCell?.memberPicView.image = UIImage
                })
            
            
            //Sets description of each transaction
            pendingCell?.descriptionLabel.text = String(describing: incomingList[indexPath.row].description)
            
        case 1:
            
            let pendingCell = cell as? MemberPendingTableViewCell
            
            //Displays the amount of money transferred
            pendingCell?.resultLabel.text = "$" + String(describing: outgoingList[indexPath.row].amount)
            
            //Sets the Name of each user at each index
            user.getUser(UserID: outgoingList[indexPath.row].memberID, withBlock:{(User) -> Void in
                pendingCell?.memberNameLabel.text = User.name
            })
            
            //Gets the image of the group
            group.getGroupPic(withBlock: { (UIImage) -> Void in
                pendingCell?.memberPicView.image = UIImage
            })
            
            //Sets description of each transaction
            pendingCell?.descriptionLabel.text = String(describing: outgoingList[indexPath.row].description)
            
        case 2:
            
            let historyCell = cell as? MemberHistoryTableViewCell
            
            //Displays the amount of money transferred
            if historyList[indexPath.row].groupToMember == false {
                historyCell?.resultLabel.text = "-$" + String(describing: historyList[indexPath.row].amount)
            } else {
                historyCell?.resultLabel.text = "+$" + String(describing: historyList[indexPath.row].amount)
            }
            
            
            //Sets the Name of each user at each index
            user.getUser(UserID: historyList[indexPath.row].memberID, withBlock:{(User) -> Void in
                historyCell?.memberNameLabel.text = User.name
            })
            
            
            //Gets image of the group
            group.getGroupPic(withBlock: { (UIImage) -> Void in
                historyCell?.memberPicView.image = UIImage
            })
            
            //Sets description of each transaction
            historyCell?.descriptionLabel.text = String(describing: historyList[indexPath.row].description)
            
        default:
            
            let pendingCell = cell as? AdminPendingTableViewCell
            
        }
        
    }
    
    
    
    
    
}
