//
//  NewMemberTransactionViewController.swift
//  Splitzee
//
//  Created by Vidya Ravikumar on 11/16/16.
//  Copyright © 2016 Mohit Katyal. All rights reserved.
//

import UIKit

class NewMemberTransactionViewController: UIViewController {
    var userSelectTextField: UITextField!
    var amountTextField: UITextField!
    var descriptionTextField: UITextView!
    var payButton: UIButton!
    var requestButton: UIButton!
    var groupImage: UIImageView!
    var groupLabel: UILabel!
    let constants = Constants()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupNavBar() {
        let navBar: UINavigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height * 0.111))
        navBar.backgroundColor = UIColor.white
        let navTitle = UINavigationItem(title: "New Transaction")
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : constants.fontMediumBlue]
        navBar.setItems([navTitle], animated: false)
        view.addSubview(navBar)
    }
    
    func setUpUI() {
        
        setupNavBar()
        
        groupImage = UIImageView(frame: CGRect(x: 0.326 * view.frame.width, y: 0.145 * view.frame.height, width: 0.345 * view.frame.width, height: 0.160 * view.frame.height))
        groupImage.contentMode = .scaleAspectFit
        groupImage.image = #imageLiteral(resourceName: "selectNewPhoto")// Should have the group image
        groupImage.clipsToBounds = true
        view.addSubview(groupImage)
        
        groupLabel = UILabel(frame: CGRect(x: 0, y: 0.306 * view.frame.height , width: view.frame.width, height: view.frame.height * 0.061))
        groupLabel.layer.masksToBounds = true
        groupLabel.textColor = constants.fontDarkGray
        groupLabel.textAlignment = .center
        groupLabel.text = "International Justice League of Super Acquaintances" // Should have the group name
        view.addSubview(groupLabel)
        
        amountTextField = UITextField(frame: CGRect(x: 0, y: 0.367 * view.frame.height , width: view.frame.width, height: view.frame.height * 0.061))
        amountTextField.layer.masksToBounds = true
        amountTextField.backgroundColor = UIColor.white
        amountTextField.layer.borderColor = constants.fontLightGray.cgColor
        amountTextField.layer.borderWidth = 1
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
        
        payButton = UIButton(frame: CGRect(x: 0, y: 0.597*view.frame.height , width: 0.4985 * view.frame.width, height: view.frame.height * 0.089))
        payButton.layer.masksToBounds = true
        payButton.backgroundColor = constants.mediumBlue
        payButton.setTitle("Confirm Payment", for: .normal)
        payButton.setTitleColor(UIColor.white, for: .normal)
        payButton.layer.cornerRadius = 2
        view.addSubview(payButton)
        
        requestButton = UIButton(frame: CGRect(x: 0.5015 * view.frame.width, y: 0.597 * view.frame.height , width: 0.4985 * view.frame.width, height: view.frame.height * 0.089))
        requestButton.layer.masksToBounds = true
        requestButton.setTitle("Request Money", for: .normal)
        requestButton.backgroundColor = constants.mediumBlue
        requestButton.setTitleColor(UIColor.white, for: .normal)
        requestButton.layer.cornerRadius = 2
        view.addSubview(requestButton)
        
    }
    
    
}

extension NewMemberTransactionViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == constants.fontLightGray {
            textView.text = ""
            textView.textColor = UIColor.black
        }
    }
}
