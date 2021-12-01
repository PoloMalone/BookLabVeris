//
//  LoginViewController.swift
//  bookLab
//
//  Created by Josef Jakobsson on 2021-09-02.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseAnalytics
import FirebaseFirestore
import FirebaseFirestoreSwift

class LoginViewController: UIViewController {

    
    @IBOutlet weak var userNameTextField: UITextField!
    
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    @IBOutlet weak var loginButton: UIButton!
    
    
    @IBOutlet weak var errorLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    


    
    
    func validateLogin() -> String? {
        
        
        //check so that all fields are filled
        
        if userNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            
            return "Please fill all the fields above."
        }
        
        return nil
    }
    
    
    //func for when login button is tapped.
    @IBAction func loginTapped(_ sender: Any) {

        let checkValidateLogin = validateLogin()
        
        if checkValidateLogin != nil{
            showErrorLogin(checkValidateLogin!)
        }
        else {
            let username = userNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            if username == "admin@admin.se" || password == "admin123" {
                Auth.auth().signIn(withEmail: username, password: password) { (result, err) in
                    
                    if err != nil {
                       
                        self.showErrorLogin("Could not sign in, please check email and password.")
                    }
                    else{
                      
                        self.gotoAdminScreen()
                    }
            }
            }
            else{
            Auth.auth().signIn(withEmail: username, password: password) { (result, err) in
            
                
                if err != nil {
                    self.showErrorLogin("Could not sign in, please check email and password.")
                }
                else{
                    
                    self.gotoHomeScreen()
                    
                }
            }
            }
            
        }
        
    }
    
    

    //func to show error if error occur
    func showErrorLogin(_ message: String) {
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    //func to go to homescreen
    func gotoHomeScreen() {

        
        let homeViewController = storyboard?.instantiateViewController(identifier: Constants.Story.homeViewController) as? HomeViewController
        
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
 
   }
//func to go to admin screen, depeding on who is logging in
    func gotoAdminScreen() {
        
        
        let adminViewController = storyboard?.instantiateViewController(identifier:
            Constants.Story.adminViewController) as? AdminViewController
        
        
        view.window?.rootViewController = adminViewController
        view.window?.makeKeyAndVisible()

    }
}
