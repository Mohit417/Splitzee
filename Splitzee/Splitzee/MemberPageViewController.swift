//
//  MemberPageViewController.swift
//  Splitzee
//
//  Created by Vidya Ravikumar on 11/16/16.
//  Copyright © 2016 Mohit Katyal. All rights reserved.
//

import UIKit

class MemberPageViewController: UIViewController {
    
    var segmentedView: UISegmentedControl!
    var groupsButton: UIButton!
    var newTransactionButton: UIButton!
    var tableView: UITableView!
    var backgroundGradient: UIImageView!
    let constants = Constants()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupSideBar()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupUI() {
        
        backgroundGradient = UIImageView(frame: view.frame)
        backgroundGradient.image = #imageLiteral(resourceName: "whiteBlueGradientBG")
        view.addSubview(backgroundGradient)
        
        groupsButton = UIButton(frame: CGRect(x: view.frame.width * 0.053, y: view.frame.height * 0.143, width: view.frame.width * 0.058, height: view.frame.height * 0.032))
        groupsButton.setImage(#imageLiteral(resourceName: "menuSymbol"), for: .normal)
        groupsButton.imageView?.contentMode = .scaleAspectFill
        view.addSubview(groupsButton)
        
        newTransactionButton = UIButton(frame: CGRect(x: view.frame.width * 0.896, y: view.frame.height * 0.143, width: view.frame.width * 0.058, height: view.frame.height * 0.032))
        newTransactionButton.setImage(#imageLiteral(resourceName: "pencilSymbol"), for: .normal)
        newTransactionButton.imageView?.contentMode = .scaleAspectFit
        view.addSubview(newTransactionButton)
        
        setupNavBar()
        setupSegmentedControl()
        setupTableView()
    }
    
    func setupNavBar() {
        self.title = "Group Name" // change to group name
    }
    
    func setupSegmentedControl() {
        let items = ["Incoming", "Outgoing", "History"]
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
        tableView.register(MemberPendingTableViewCell.self, forCellReuseIdentifier: "memberCell")
        view.addSubview(tableView)
    }
    
    func switchView(sender: UISegmentedControl) {
        if (sender.selectedSegmentIndex == 0) {
            // incoming
        } else if (sender.selectedSegmentIndex == 1) {
            // outgoing
        } else {
            // history
        }
    }
    
    func setupSideBar() {
        if revealViewController() != nil {
            groupsButton.addTarget(self.revealViewController(), action: "revealToggle:", for: .touchUpInside)
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
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

extension MemberPageViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "memberCell", for: indexPath) as! MemberPendingTableViewCell
        for subview in cell.contentView.subviews {
            subview.removeFromSuperview()
        }
        cell.awakeFromNib()
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cell = cell as! MemberPendingTableViewCell
    }
}
