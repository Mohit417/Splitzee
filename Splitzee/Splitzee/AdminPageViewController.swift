//
//  AdminPageViewController.swift
//  Splitzee
//
//  Created by Vidya Ravikumar on 11/16/16.
//  Copyright © 2016 Mohit Katyal. All rights reserved.
//
import UIKit
import Firebase
import FirebaseDatabase

enum ListState {
    case incoming
    case outgoing
    case history
}

class AdminPageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, AdminPendingTableViewCellDelegate, AdminHistoryTableViewCellDelegate {
    
    var segmentedView: UISegmentedControl!
    var groupsButton: UIButton!
    var newTransactionButton: UIButton!
    var addMoneyButton: UIButton!
    var subtractMoneyButton: UIButton!
    var totalLoopImage: UIImageView!
    var totalAmount: UILabel!
    var tableView: UITableView!
    var backgroundGradient: UIImageView!
    let constants = Constants()
    var alertViewAdd: UIAlertController!
    var alertViewSub: UIAlertController!
    var pending = true
    var currUser: CurrentUser!
    var group: Group!
    let rootRef = FIRDatabase.database().reference()
    var listState = ListState.incoming
    var alertView: UIAlertController!
    
    var transactionList: [Transaction] = []
    var historyList: [Transaction] = []
    var incomingList: [Transaction] = []
    var outgoingList: [Transaction] = []
    
    func approve(transaction: Transaction) {
        //
        transaction.approveTransaction()
        print("approved")
        reloadAllData()
    }
    
    func reject(transaction: Transaction) {
        //
        transaction.rejectTransaction()
        print("rejected")
        reloadAllData()
    }
    
    func report(transaction: Transaction) {
        //
        transaction.flagTransaction()
        print("reported")
        reloadAllData()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let dbRef = FIRDatabase.database().reference()
        let uid = FIRAuth.auth()?.currentUser?.uid
        if let uid = uid {
            dbRef.child(Constants.DataNames.User).child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
                // Get user value
                self.currUser = CurrentUser(key: uid, currentUserDict: snapshot.value as! [String: AnyObject])
                DispatchQueue.main.async {
                    self.setUpTableLists()
                    self.setupUI()
                    self.setUpDataDependencies()
                }
                
            }) { (error) in
                print(error.localizedDescription)
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        reloadAllData()
    }
    
    func reloadAllData() {
        transactionList = []
        historyList = []
        incomingList = []
        outgoingList = []
        let dbRef = FIRDatabase.database().reference()
        let groupID = group.groupID
        
        dbRef.child(Constants.DataNames.Group).child(groupID).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            self.group = Group(key: groupID, groupDict: snapshot.value as! [String: AnyObject])
            DispatchQueue.main.async {
                self.setUpTableLists()
            }
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func setUpDataDependencies() {
        group.getTotal(withBlock: { total in
            let nf = NumberFormatter()
            nf.numberStyle = .currency
            let amtString = nf.string(from: total as NSNumber)!
            self.totalAmount.text = amtString
        })
    }
    
    func setupUI() {
        // BACKGROUND
        backgroundGradient = UIImageView(frame: view.frame)
        backgroundGradient.image = #imageLiteral(resourceName: "whiteBlueGradientBG")
        view.addSubview(backgroundGradient)
        
        // GROUPS BUTTON LEFT
        groupsButton = UIButton(frame: CGRect(x: view.frame.width * 0.048, y: view.frame.height * 0.337, width: view.frame.width * 0.058, height: view.frame.height * 0.032))
        groupsButton.setImage(#imageLiteral(resourceName: "menuSymbol"), for: .normal)
        groupsButton.imageView?.contentMode = .scaleAspectFill
        groupsButton.addTarget(self, action: #selector(groupsPressed), for: .touchUpInside)
        view.addSubview(groupsButton)
        
        // NEW TRANSACTION BUTTON RIGHT
        newTransactionButton = UIButton(frame: CGRect(x: view.frame.width * 0.896, y: view.frame.height * 0.333, width: view.frame.width * 0.063, height: view.frame.height * 0.032))
        newTransactionButton.setTitle("+", for: .normal)
        newTransactionButton.titleLabel?.font = UIFont(name: "SFUIText-Light", size: 43)
        newTransactionButton.setTitleColor(constants.fontMediumBlue, for: .normal)
        
        newTransactionButton.addTarget(self, action: #selector(touchNewAdminTransactionButton), for: .touchUpInside)
        view.addSubview(newTransactionButton)
        
        // BALANCE CIRCLE
        totalLoopImage = UIImageView(frame: CGRect(x: view.frame.width / 2 - 0.175 * view.frame.width, y: view.frame.height * 0.110, width: view.frame.width * 0.35, height: view.frame.height * 0.200))
        totalLoopImage.image = #imageLiteral(resourceName: "Loop")
        totalLoopImage.contentMode = .scaleAspectFit
        view.addSubview(totalLoopImage)
        
        // BALANCE AMOUNT
        totalAmount = UILabel(frame: CGRect(x: view.frame.width / 2 - 0.175 * view.frame.width, y: view.frame.height * 0.19, width: view.frame.width * 0.35, height: view.frame.height * 0.045))
        totalAmount.text = String(group.total) //Actual group total
        totalAmount.textAlignment = .center
        totalAmount.font = UIFont(name: "SFUIText-Light", size: 18)
        totalAmount.textColor = constants.fontMediumBlue
        totalAmount.textAlignment = .center
        view.addSubview(totalAmount)
        
        // ADD BUTTON
        addMoneyButton = UIButton(frame: CGRect(x: view.frame.width * 0.693, y: view.frame.height * 0.155, width: view.frame.width * 0.075 + 15, height: view.frame.height * 0.046 + 15))
        addMoneyButton.setImage(#imageLiteral(resourceName: "plusSign"), for: .normal)
        addMoneyButton.imageView?.contentMode = .scaleAspectFill
        addMoneyButton.addTarget(self, action: #selector(addMoneyPressed), for: .touchUpInside)
        view.addSubview(addMoneyButton)
        
        // SUBTRACT BUTTON
        subtractMoneyButton = UIButton(frame: CGRect(x: view.frame.width * 0.693, y: view.frame.height * 0.216, width: view.frame.width * 0.075 + 15, height: view.frame.height * 0.046 + 15))
        subtractMoneyButton.setImage(#imageLiteral(resourceName: "minusSign"), for: .normal)
        subtractMoneyButton.imageView?.contentMode = .scaleAspectFill
        subtractMoneyButton.addTarget(self, action: #selector(subMoneyPressed), for: .touchUpInside)
        view.addSubview(subtractMoneyButton)
        
        setupNavBar()
        setupSegmentedControl()
        setupTableView()
        setUpTableLists()
        
        
    }
    
    func groupsPressed() {
        dismiss(animated: true, completion: nil)
    }
    
    func setupNavBar() {
        self.title = group.name // Actual group name
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: constants.fontMediumBlue, NSFontAttributeName: UIFont(name: "SFUIText-Medium", size: 20)!]
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.tintColor = constants.fontMediumBlue
    }
    
    func setupSegmentedControl() {
        let items = ["Incoming", "Outgoing", "History"]
        let attr = NSDictionary(object: UIFont(name: "SFUIText-Regular", size: 14.0)!, forKey: NSFontAttributeName as NSCopying)
        UISegmentedControl.appearance().setTitleTextAttributes(attr as [NSObject : AnyObject] , for: .normal)
        segmentedView = UISegmentedControl(items: items)
        segmentedView.selectedSegmentIndex = 0
        segmentedView.frame = CGRect(x: view.frame.width * 0.145, y: view.frame.height * 0.334, width: view.frame.width * 0.720, height: 28)
        segmentedView.layer.cornerRadius = 3
        segmentedView.backgroundColor = UIColor.white
        segmentedView.tintColor = constants.mediumBlue
        segmentedView.addTarget(self, action: #selector(switchView), for: .valueChanged)
        view.addSubview(segmentedView)
    }
    
    func setupTableView() {
        tableView = UITableView(frame: CGRect(x: 0, y: view.frame.height * 0.397, width: view.frame.width, height: view.frame.height * 0.603), style: UITableViewStyle.plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(AdminPendingTableViewCell.self, forCellReuseIdentifier: "pendingAdminCell")
        tableView.register(AdminHistoryTableViewCell.self, forCellReuseIdentifier: "historyAdminCell")
        view.addSubview(tableView)
    }
    
    func touchNewAdminTransactionButton(sender: UIButton!) {
        performSegue(withIdentifier: "adminPageToNewAdminTransaction", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "adminPageToNewAdminTransaction" {
            let nextVC = segue.destination as! NewAdminTransactionViewController
            nextVC.group = group
            //print(group.name)
        }
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
        tableView.reloadData()
    }
    
    func addMoneyPressed() {
        alertViewAdd = UIAlertController(title: "Add an amount:", message: "", preferredStyle: UIAlertControllerStyle.alert)
        alertViewAdd.addTextField { (textField) -> Void in
            textField.placeholder = "$0.00"
        }
        alertViewAdd.addAction(UIAlertAction(title: "Done", style: .default, handler: { (action) in
            let textF = self.alertViewAdd.textFields![0] as UITextField
            if let amountToAdd = Double(textF.text!) {
                self.group.addToTotal(amount: amountToAdd)
            } else {
                self.alert("Poorly formatted amount.")
            }
            print(textF.text!)
        }))
        alertViewAdd.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action) in
            self.alertViewAdd.dismiss(animated: true, completion: nil)
        }))
        self.present(alertViewAdd, animated: true, completion: nil)
        
    }
    
    func subMoneyPressed() {
        alertViewSub = UIAlertController(title: "Subtract an amount:", message: "", preferredStyle: UIAlertControllerStyle.alert)
        alertViewSub.addTextField { (textField) -> Void in
            textField.placeholder = "0.00"
        }
        alertViewSub.addAction(UIAlertAction(title: "Done", style: .default, handler: { (action) in
            let textF = self.alertViewSub.textFields![0] as UITextField
            if let amountToAdd = Double(textF.text!) {
                self.group.addToTotal(amount: (amountToAdd * -1))
            } else {
                self.alert("Poorly formated amount.")
            }
        }))
        alertViewSub.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action) in
            self.alertViewSub.dismiss(animated: true, completion: nil)
        }))
        self.present(alertViewSub, animated: true, completion: nil)
        
        
    }
    
    func alert(_ msg: String) {
        alertView = UIAlertController(title: "Error", message: msg, preferredStyle: UIAlertControllerStyle.alert)
        alertView.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
            self.alertView.dismiss(animated: true, completion: nil)
        }))
        self.present(alertView, animated: true, completion: nil)
    }
    
    //-----------------functions----------------------------------
    
    //Create lists for different tables
    func setUpTableLists(){
        group.getTransactions(withBlock: {(trans) -> Void in
            self.transactionList.append(trans)
            if trans.isApproved == true {
                self.historyList.append(trans)
            }
            else if trans.groupToMember == true {
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
        
        switch listState {
        case .incoming:
            print(incomingList.count)
            return incomingList.count
            
        case .outgoing:
            return outgoingList.count
            
        case .history:
            return historyList.count
            
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch listState {
            
        case .incoming:
            let pendingCell = tableView.dequeueReusableCell(withIdentifier: "pendingAdminCell", for: indexPath) as! AdminPendingTableViewCell
            for subview in pendingCell.contentView.subviews {
                subview.removeFromSuperview()
            }
            pendingCell.selectionStyle = .none
            pendingCell.awakeFromNib()
            
            
            return pendingCell
            
        case .outgoing:
            
            let pendingCell = tableView.dequeueReusableCell(withIdentifier: "pendingAdminCell", for: indexPath) as! AdminPendingTableViewCell
            for subview in pendingCell.contentView.subviews {
                subview.removeFromSuperview()
            }
            pendingCell.selectionStyle = .none
            pendingCell.awakeFromNib()
            return pendingCell
            
        case .history:
            
            let historyCell = tableView.dequeueReusableCell(withIdentifier: "historyAdminCell", for: indexPath) as! AdminHistoryTableViewCell
            for subview in historyCell.contentView.subviews {
                subview.removeFromSuperview()
            }
            historyCell.selectionStyle = .none
            historyCell.awakeFromNib()
            return historyCell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    //Populates the cell with data
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        
        switch listState {
            
        case .incoming:
            
            let transaction = incomingList[indexPath.row]
            let pendingCell = cell as? AdminPendingTableViewCell
            
            //Displays the amount of money transferred
            let amt = transaction.amount
            let nf = NumberFormatter()
            nf.numberStyle = .currency
            var amtString = nf.string(from: amt as NSNumber)!
            if !amtString.hasPrefix("-") {
                amtString = "+" + amtString
            }
            pendingCell?.approveButton.setTitle(amtString, for: .normal)
            
            //Sets the Name of each user at each index
            
            
            transaction.getUser(withBlock:{(user) -> Void in
                pendingCell?.memberNameLabel.text = user.name
                
                //get user image
                user.getProfilePic(withBlock: { (UIImage) -> Void in
                    pendingCell?.memberPicView.image = UIImage
                })
            })
            
            //Sets description of each transaction
            pendingCell?.descriptionLabel.text = String(describing: transaction.description)
            pendingCell?.transaction = transaction
            pendingCell?.delegate = self
            
            
            
        case .outgoing:
            
            let transaction = outgoingList[indexPath.row]
            let pendingCell = cell as? AdminPendingTableViewCell
            
            //Displays the amount of money transferred
            let amt = transaction.amount
            let nf = NumberFormatter()
            nf.numberStyle = .currency
            var amtString = nf.string(from: amt as NSNumber)!
            if !amtString.hasPrefix("-") {
                amtString = "+" + amtString
            }
            pendingCell?.approveButton.setTitle(amtString, for: .normal)
            
            //Sets the Name of each user at each index
            
            
            transaction.getUser(withBlock:{(user) -> Void in
                pendingCell?.memberNameLabel.text = user.name
                
                //get user image
                user.getProfilePic(withBlock: { (UIImage) -> Void in
                    pendingCell?.memberPicView.image = UIImage
                })
            })
            
            //Sets description of each transaction
            pendingCell?.descriptionLabel.text = String(describing: transaction.description)
            pendingCell?.transaction = transaction
            pendingCell?.delegate = self
            
            
        case .history:
            
            let transaction = historyList[indexPath.row]
            
            
            let historyCell = cell as? AdminHistoryTableViewCell
            
            //Displays the amount of money transferred
            let amt = transaction.amount
            let nf = NumberFormatter()
            nf.numberStyle = .currency
            var amtString = nf.string(from: amt as NSNumber)!
            historyCell?.resultLabel.textColor = constants.lightRed
            if !amtString.hasPrefix("-") {
                amtString = "+" + amtString
                historyCell?.resultLabel.textColor = constants.lightGreen
            }
            historyCell?.resultLabel.text = amtString
            
            //Sets the Name of each user at each index
            
            transaction.getUser(withBlock:{(user) -> Void in
                historyCell?.memberNameLabel.text = user.name
                
                //get user image
                user.getProfilePic(withBlock: { (UIImage) -> Void in
                    historyCell?.memberPicView.image = UIImage
                })
            })
            
            //Sets description of each transaction
            historyCell?.descriptionLabel.text = String(describing: transaction.description)
            
            if (transaction.isRejected) {
                historyCell?.backgroundColor = UIColor(hex: 0xe8aea8, alpha: 0.25)
            } else {
                historyCell?.backgroundColor = UIColor.clear
            }
            historyCell?.transaction = transaction
            historyCell?.delegate = self
        }
    }
    
    
    
}

extension UIColor {
    convenience init(hex: Int, alpha: CGFloat) {
        let r = CGFloat((hex & 0xFF0000) >> 16)/255
        let g = CGFloat((hex & 0xFF00) >> 8)/255
        let b = CGFloat(hex & 0xFF)/255
        self.init(red: r, green: g, blue: b, alpha: alpha)
    }
    
    convenience init(hex: Int) {
        self.init(hex:hex, alpha:1.0)
    }
}
