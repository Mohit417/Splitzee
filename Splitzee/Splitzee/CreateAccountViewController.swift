//
//  CreateAccountViewController.swift
//  Splitzee
//
//  Created by Vidya Ravikumar on 11/16/16.
//  Copyright © 2016 Mohit Katyal. All rights reserved.
//

import UIKit
import Firebase

class CreateAccountViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate ,UINavigationControllerDelegate {
    
    var background: UIImageView!
    var createYourAccount: UILabel!
    var plainDividingLineTop: UIImageView!
    var pictureButton: UIButton!
    var plainDividingLineBottom: UIImageView!
    var inputFullName: UITextField!
    var inputEmail: UITextField!
    var inputPassword: UITextField!
    var inputConfirmPassword: UITextField!
    var createAccountButton: UIButton!
    var backToLoginButton: UIButton!
    var userImage: UIImage?
    let constants = Constants()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
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
        
        // createYourAccount
        createYourAccount = UILabel(frame: CGRect(x: 0, y: view.frame.height * 0.0856, width: view.frame.width, height: view.frame.height * 0.043))
        createYourAccount.textColor = UIColor.white
        createYourAccount.text = "Create your account"
        createYourAccount.font = UIFont(name: "SFUIText-Light", size: 27)
        createYourAccount.textAlignment = .center
        view.addSubview(createYourAccount)
        
        // plainDividingLineTop
        plainDividingLineTop = UIImageView(image: #imageLiteral(resourceName: "line"))
        plainDividingLineTop.frame = CGRect(x: view.frame.width * 0.098, y: view.frame.height * 0.146, width: view.frame.width * 0.804, height: view.frame.height * 0.01)
        plainDividingLineTop.contentMode = .scaleAspectFill
        self.view.addSubview(plainDividingLineTop)
        
        // pictureButton
        pictureButton = UIButton()
        pictureButton.frame = CGRect(x: 0.31 * view.frame.width, y: 0.170 * view.frame.height, width: 0.38 * view.frame.width, height: 0.38 * view.frame.width)
        pictureButton.setImage(#imageLiteral(resourceName: "selectNewPhoto"), for: .normal)
        pictureButton.contentMode = .scaleAspectFill
        pictureButton.layer.cornerRadius = 0.5 * pictureButton.frame.size.width
        pictureButton.clipsToBounds = true
        pictureButton.addTarget(self, action: #selector(loadImagesButtonTapped), for: .touchUpInside)
        view.addSubview(pictureButton)
        
        // plainDividingLineBottom
        plainDividingLineBottom = UIImageView(image: #imageLiteral(resourceName: "line"))
        plainDividingLineBottom.frame = CGRect(x: view.frame.width * 0.098, y: view.frame.height * 0.760 + (view.frame.height*0.0625), width: view.frame.width * 0.804, height: view.frame.height * 0.01)
        plainDividingLineBottom.contentMode = .scaleAspectFill
        self.view.addSubview(plainDividingLineBottom)
        
        // inputFullName
        inputFullName = UITextField()
        let inputFullNamePlaceholder = NSAttributedString(string: String(describing: "Full name"), attributes: [NSForegroundColorAttributeName: UIColor.lightGray])
        inputFullName.attributedPlaceholder = inputFullNamePlaceholder
        inputFullName.font = UIFont(name: "SFUIText-Light", size: 14)
        inputFullName.frame = CGRect(x: view.frame.width * 0.077, y: view.frame.height * 0.329 + (view.frame.height*0.0625), width: view.frame.width * 0.841, height: view.frame.height * 0.057)
        inputFullName.backgroundColor = UIColor.white
        inputFullName.layer.cornerRadius = 3
        inputFullName.autocapitalizationType = .words
        inputFullName.autocorrectionType = .no
        createInset(textField: inputFullName)
        view.addSubview(inputFullName)
        
        // inputEmailOrUsername
        inputEmail = UITextField()
        let inputEmailPlaceholder = NSAttributedString(string: String(describing: "Email"), attributes: [NSForegroundColorAttributeName: UIColor.lightGray])
        inputEmail.attributedPlaceholder = inputEmailPlaceholder
        inputEmail.font = UIFont(name: "SFUIText-Light", size: 14)
        inputEmail.frame = CGRect(x: view.frame.width * 0.077, y: view.frame.height * 0.409 + (view.frame.height*0.0625), width: view.frame.width * 0.841, height: view.frame.height * 0.057)
        inputEmail.backgroundColor = UIColor.white
        inputEmail.layer.cornerRadius = 3
        inputEmail.keyboardType = .emailAddress
        inputEmail.autocorrectionType = .no
        inputEmail.autocapitalizationType = .none
        createInset(textField: inputEmail)
        view.addSubview(inputEmail)
        
        // inputPassword
        inputPassword = UITextField()
        let inputPasswordPlaceholder = NSAttributedString(string: String(describing: "Password"), attributes: [NSForegroundColorAttributeName: UIColor.lightGray])
        inputPassword.attributedPlaceholder = inputPasswordPlaceholder
        inputPassword.font = UIFont(name: "SFUIText-Light", size: 14)
        inputPassword.frame = CGRect(x: view.frame.width * 0.077, y: view.frame.height * 0.490 + (view.frame.height*0.0625), width: view.frame.width * 0.841, height: view.frame.height * 0.057)
        inputPassword.backgroundColor = UIColor.white
        inputPassword.layer.cornerRadius = 3
        inputPassword.isSecureTextEntry = true
        inputPassword.autocapitalizationType = .none
        inputPassword.autocorrectionType = .no
        createInset(textField: inputPassword)
        view.addSubview(inputPassword)
        
        // inputConfirmPassword
        inputConfirmPassword = UITextField()
        let inputConfirmPasswordPlaceholder = NSAttributedString(string: String(describing: "Confirm password"), attributes: [NSForegroundColorAttributeName: UIColor.lightGray])
        inputConfirmPassword.attributedPlaceholder = inputConfirmPasswordPlaceholder
        inputConfirmPassword.font = UIFont(name: "SFUIText-Light", size: 14)
        inputConfirmPassword.frame = CGRect(x: view.frame.width * 0.077, y: view.frame.height * 0.571 + (view.frame.height*0.0625), width: view.frame.width * 0.841, height: view.frame.height * 0.057)
        inputConfirmPassword.backgroundColor = UIColor.white
        inputConfirmPassword.layer.cornerRadius = 3
        inputConfirmPassword.isSecureTextEntry = true
        inputConfirmPassword.autocapitalizationType = .none
        inputConfirmPassword.autocorrectionType = .no
        createInset(textField: inputConfirmPassword)
        view.addSubview(inputConfirmPassword)
        
        // createAccountButton
        createAccountButton = UIButton(frame: CGRect(x: view.frame.width * 0.077, y: view.frame.height * 0.651 + (view.frame.height*0.0625), width: view.frame.width * 0.841, height: view.frame.height * 0.068))
        createAccountButton.setTitle("CREATE ACCOUNT", for: .normal)
        createAccountButton.titleLabel?.font = UIFont(name: "SFUIText-Light", size: 18)
        createAccountButton.backgroundColor = constants.red
        createAccountButton.addTarget(self, action: #selector(createAccountPressed), for: .touchUpInside)
        createAccountButton.layer.cornerRadius = 3
        view.addSubview(createAccountButton)
        
        // backToLoginButton
        backToLoginButton = UIButton(frame: CGRect(x: view.frame.width * 0.077, y: view.frame.height * 0.802 + (view.frame.height*0.0625), width: view.frame.width * 0.841, height: view.frame.height * 0.057))
        backToLoginButton.setTitle("Back to Login", for: .normal)
        backToLoginButton.titleLabel?.font = UIFont(name: "SFUIText-Regular", size: 18)
        backToLoginButton.backgroundColor = UIColor.clear
        backToLoginButton.layer.borderWidth = 1
        backToLoginButton.layer.borderColor = UIColor.white.cgColor
        backToLoginButton.layer.cornerRadius = 3
        backToLoginButton.addTarget(self, action: #selector(touchBackToLoginButton), for: .touchUpInside)
        view.addSubview(backToLoginButton)
    }
    
    func initializeTextFields() {
        inputEmail.delegate = self
        inputPassword.delegate = self
        inputFullName.delegate = self
        inputConfirmPassword.delegate = self
    }
    
    // -----------FUNCTIONS------------------------------------------------------------------------
    
    func touchBackToLoginButton() {
        dismiss(animated: true, completion: nil)
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
    
    //--------------Adding Images to the Create an Account Button---------------------------------
    
    
    var imagePicker = UIImagePickerController()
    
    func loadImagesButtonTapped(sender: UIButton){
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let setImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            userImage = setImage
            pictureButton.setImage(userImage, for: .normal)
            dismiss(animated: true, completion: nil)
        }
    }
    
    
    func storeImage(id:String, withBlock: @escaping (String?) -> Void) {
        
        let storage = FIRStorage.storage()
        let storageRef = storage.reference(forURL: "gs://splitzee-ebff4.appspot.com")
        let imagesRef = storageRef.child("images/"+id)
        var data = NSData()
        if let img = userImage {
            data = UIImageJPEGRepresentation(img, 0.8)! as NSData
            
            let uploadTask = imagesRef.put(data as Data, metadata: nil) { metadata, error in
                if (error != nil) {
                    
                } else {
                    
                    withBlock("images/"+id)
                }
            }
        }
    }
    
    
    
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    // -----------FIREBASE------------------------------------------------------------------------
    
    //Signs in user
    func signedIn(_ user: FIRUser?) {
        performSegue(withIdentifier: "createAccountToSignIn", sender: self)
    }
    
    //Sets display name of the user
    func setDisplayName(_ user: FIRUser?) {
        let changeRequest = user?.profileChangeRequest()
        changeRequest?.displayName = user?.email!.components(separatedBy: "@")[0]
        changeRequest?.commitChanges(completion: { (error) in
            if let error = error {
                print(error)
                return
            } else {
                self.signedIn(FIRAuth.auth()?.currentUser)
            }
        })
    }
    
    func createAccountPressed(_ sender: UIButton) {
        let alertView = UIAlertController(title: "Terms and Conditions", message: "In connection with the use of our mobile application, you will not take any action that is considered spam or harassment to any user or group.", preferredStyle: UIAlertControllerStyle.alert)
        alertView.addAction(UIAlertAction(title: "Accept", style: .default, handler: { (action) in
            self.createAccount()
        }))
        alertView.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action) in
            self.touchBackToLoginButton()
        }))
        self.present(alertView, animated: true, completion: nil)
    }
    
    // Creates a new account
    func createAccount() {
        
        
        if ((inputFullName.text?.characters.count)! == 0 || (inputPassword.text?.characters.count)! == 0 || (inputConfirmPassword.text?.characters.count)! == 0 || (inputEmail.text?.characters.count)! == 0)
        {
            let alertView = UIAlertController(title: "Error"
                , message: "One or more fields have not been filled.", preferredStyle: UIAlertControllerStyle.alert)
            alertView.addAction(UIAlertAction(title: "Done", style: .default, handler: { (action) in
            }))
            self.present(alertView, animated: true, completion: nil)
        }

        if userImage == nil
        {
            let alertView = UIAlertController(title: "Error"
                , message: "Please upload a profile photo.", preferredStyle: UIAlertControllerStyle.alert)
            alertView.addAction(UIAlertAction(title: "Done", style: .default, handler: { (action) in
            }))
            self.present(alertView, animated: true, completion: nil)
        }
        
        if (inputPassword.text != inputConfirmPassword.text) {
            let alertView = UIAlertController(title: "Error", message: "Passwords do not match.", preferredStyle: UIAlertControllerStyle.alert)
            alertView.addAction(UIAlertAction(title: "Done", style: .default, handler: { (action) in
            }))
            self.present(alertView, animated: true, completion: nil)
            
        }
        else {
            guard let email = inputEmail.text, let password = inputPassword.text, let name = inputFullName.text else {return}
            FIRAuth.auth()?.createUser(withEmail: email, password: password,  completion: { (user, error) in
                if let error = error {
                    if ((self.inputPassword.text?.characters.count)! < 6) {
                        let alertView = UIAlertController(title: "Error", message: "Password must be at least six characters long.", preferredStyle: UIAlertControllerStyle.alert)
                        alertView.addAction(UIAlertAction(title: "Done", style: .default, handler: { (action) in
                        }))
                        self.present(alertView, animated: true, completion: nil)
                        
                    } else {
                        let alertView = UIAlertController(title: "Error", message: "Email is not correctly formatted or is already in existence.", preferredStyle: UIAlertControllerStyle.alert)
                        alertView.addAction(UIAlertAction(title: "Done", style: .default, handler: { (action) in
                        }))
                        self.present(alertView, animated: true, completion: nil)
                    }
                    
                    print(error)
                    return
                } else if let user = user {
                    
                    //Stores the image in firebase database
                    
                    let rootRef = FIRDatabase.database().reference()
                    let key = user.uid
                    let userRef = rootRef.child(Constants.DataNames.User).child(key)
                    
                    self.storeImage(id: key, withBlock: {(urlString) -> Void in
                        
                        if let urlString = urlString {
                            userRef.setValue([Constants.UserFields.email: email,Constants.UserFields.name: name, Constants.UserFields.profPicURL: urlString, Constants.UserFields.transactionIDs: [String](), Constants.UserFields.groupIDs : [String](), Constants.UserFields.groupAdminIDs : [String]()])
                            
                            // stores the image in firebase storage
                            
                            AppState.sharedInstance.signedIn = true
                            self.setDisplayName(user)
                        } else {
                            let alertView = UIAlertController(title: "Error", message: "Please enter a profile picture.", preferredStyle: UIAlertControllerStyle.alert)
                            alertView.addAction(UIAlertAction(title: "Done", style: .default, handler: { (action) in
                            }))
                            self.present(alertView, animated: true, completion: nil)
                            
                            return
                        }
                    })
                    
                    
                    
                    
                    
                    
                    
                }
                
                
            })
            
            
            
        }
        
    }
}
