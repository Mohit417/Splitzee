//
//  SignInViewController.swift
//  Splitzee
//
//  Created by Vidya Ravikumar on 11/16/16.
//  Copyright © 2016 Mohit Katyal. All rights reserved.
//

import UIKit
import Firebase

class SignInViewController: UIViewController, UITextFieldDelegate {
    
    var splitzeeLogo: UIImageView!
    var pleaseSignIn: UILabel!
    var plainDividingLine: UIImageView!
    var inputEmail: UITextField!
    var inputPassword: UITextField!
    var signInButton: UIButton!
    var createAccountButton: UIButton!
    var background: UIImageView!
    let constants = Constants()
    var alertWrongFormat: UIAlertController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.statusBarStyle = .lightContent
        setupUI()
        initializeTextFields()
        configureKeyboard()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.statusBarStyle = .default
    }
    
    func setupUI() {
        // background
        background = UIImageView(image: #imageLiteral(resourceName: "purpleFogBG"))
        background.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        self.view.addSubview(background)
        
        // splitzeeLogo
        splitzeeLogo = UIImageView(image: #imageLiteral(resourceName: "splitzeeStraight"))
        splitzeeLogo.frame = CGRect(x: view.frame.width * 0.052, y: view.frame.height * -0.045, width: view.frame.width, height: view.frame.height * 0.250)
        splitzeeLogo.contentMode = .scaleAspectFit
        self.view.addSubview(splitzeeLogo)
        
        // pleaseSignIn
        pleaseSignIn = UILabel(frame: CGRect(x: 0, y: view.frame.height * 0.230, width: view.frame.width, height: view.frame.height * 0.043))
        pleaseSignIn.textColor = UIColor.white
        pleaseSignIn.font = UIFont(name: "SFUIText-Light", size: 27)
        pleaseSignIn.text = "Please sign in"
        pleaseSignIn.textAlignment = .center
        view.addSubview(pleaseSignIn)
        
        // plainDividingLine
        plainDividingLine = UIImageView(image: #imageLiteral(resourceName: "line"))
        plainDividingLine.frame = CGRect(x: view.frame.width * 0.077, y: view.frame.height * 0.283, width: view.frame.width * 0.841, height: view.frame.height * 0.01)
        plainDividingLine.contentMode = .scaleAspectFill
        self.view.addSubview(plainDividingLine)
        
        // inputEmail
        inputEmail = UITextField()
        let inputEmailPlaceholder = NSAttributedString(string: String(describing: "Email"), attributes: [NSForegroundColorAttributeName: UIColor.lightGray])
        inputEmail.font = UIFont(name: "SFUIText-Light", size: 14)
        inputEmail.attributedPlaceholder = inputEmailPlaceholder
        inputEmail.frame = CGRect(x: view.frame.width * 0.077, y: view.frame.height * 0.329, width: view.frame.width * 0.841, height: view.frame.height * 0.057)
        inputEmail.backgroundColor = UIColor.white
        inputEmail.autocapitalizationType = .none
        inputEmail.keyboardType = .emailAddress
        inputEmail.layer.cornerRadius = 3
        inputEmail.autocorrectionType = .no
        createInset(textField: inputEmail)
        view.addSubview(inputEmail)
        
        // inputPassword
        inputPassword = UITextField(frame: CGRect(x: view.frame.width * 0.077, y: view.frame.height * 0.410, width: view.frame.width * 0.841, height: view.frame.height * 0.057))
        inputPassword.font = UIFont(name: "SFUIText-Light", size: 14)
        let inputPasswordPlaceholder = NSAttributedString(string: String(describing: "Password"), attributes: [NSForegroundColorAttributeName: UIColor.lightGray])
        inputPassword.attributedPlaceholder = inputPasswordPlaceholder
        inputPassword.backgroundColor = UIColor.white
        inputPassword.textColor = UIColor.black
        inputPassword.isSecureTextEntry = true
        inputPassword.autocapitalizationType = .none
        inputPassword.autocorrectionType = .no
        inputPassword.layer.cornerRadius = 3
        createInset(textField: inputPassword)
        view.addSubview(inputPassword)
        
        // signinButton
        signInButton = UIButton(frame: CGRect(x: view.frame.width * 0.077, y: view.frame.height * 0.516, width: view.frame.width * 0.256, height: view.frame.height * 0.068))
        signInButton.setTitle("SIGN IN", for: .normal)
        signInButton.titleLabel?.font = UIFont(name: "SFUIText-Light", size: 18)
        signInButton.backgroundColor = constants.darkGray
        signInButton.layer.cornerRadius = 3
        signInButton.addTarget(self, action: #selector(touchSignInButton), for: .touchUpInside)
        view.addSubview(signInButton)
        
        // createAccountButton
        createAccountButton = UIButton(frame: CGRect(x: view.frame.width * 0.350, y: view.frame.height * 0.516, width: view.frame.width * 0.568, height: view.frame.height * 0.068))
        createAccountButton.setTitle("CREATE ACCOUNT", for: .normal)
        createAccountButton.titleLabel?.font = UIFont(name: "SFUIText-Light", size: 18)
        createAccountButton.backgroundColor = constants.red
        createAccountButton.layer.cornerRadius = 3
        createAccountButton.addTarget(self, action: #selector(touchCreateAccountButton), for: .touchUpInside)
        view.addSubview(createAccountButton)
        
    }
    
    func initializeTextFields() {
        inputEmail.delegate = self
        inputPassword.delegate = self
    }
    
    
    // FUNCTIONS---------------------------------------------------------------
    
    func touchCreateAccountButton(sender: UIButton!) {
        performSegue(withIdentifier: "signInToCreateAccount", sender: self)
    }
    
    func touchSignInButton(sender: UIButton!) {
        if ((inputEmail.text?.isEmpty)! || (inputPassword.text?.isEmpty)!) {
            alert(msg: "Please enter both an email and password.")
        } else {
            guard let email = inputEmail.text, let password = inputPassword.text else {return}
            FIRAuth.auth()?.signIn(withEmail: email, password: password) { (user, error) in
                if let error = error {
                    self.alert(msg: "There has been an error! \(error.localizedDescription)")
                    return
                } else {
                    self.signedIn(user)
                }
            }
        }
    }
    
    func alert(msg: String) {
        alertWrongFormat = UIAlertController(title: "Error", message: msg, preferredStyle: UIAlertControllerStyle.alert)
        alertWrongFormat.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
            self.alertWrongFormat.dismiss(animated: true, completion: nil)
        }))
        self.present(alertWrongFormat, animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
    
    func createInset(textField: UITextField) {
        let Inset = UITextView()
        Inset.frame = CGRect(x: 0, y: 0, width: 0.048 * view.frame.width, height: textField.frame.height)
        Inset.layer.cornerRadius = 3
        textField.leftView = Inset
        textField.leftViewMode = .always
        view.addSubview(Inset)
    }
    
    func configureKeyboard() {
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
    }
    
    
    // FIREBASE----------------------------------------------------------------
    override func viewDidAppear(_ animated: Bool) {

        FIRAuth.auth()?.addStateDidChangeListener({ (auth : FIRAuth, user : FIRUser?) in
            if let user = user {
                self.signedIn(user)
            }
        })
    }
    
    func signedIn(_ user: FIRUser?) {
        AppState.sharedInstance.signedIn = true
        inputEmail.text = ""
        inputPassword.text = ""
        performSegue(withIdentifier: "signInToMenu", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "signInToMenu" {
            let nextVC = segue.destination as! SideBarViewController
            nextVC.currUser = CurrentUser()
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
