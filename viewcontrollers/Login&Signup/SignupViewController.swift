//
//  SignupViewController.swift
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

class SignupViewController: UIViewController {

    
    @IBOutlet weak var firstNameTextField: UITextField!
    
    @IBOutlet weak var lastNameTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var passwordTextField2: UITextField!
    
    @IBOutlet weak var registerButton: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    


    
    
    
    
    

    //valide fields so that they are ok.
    
    func validateFields() -> String? {
       
        
        if firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField2.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            return "Please fill all the fields above."
        }
        
        let checkEmail = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if Helpers.isEmailValid(checkEmail) == false {
            return "Email format not valid."
        }
        if !checkEmail.contains("@student.bth.se"){
            return "Email must include student.bth.se"
        }
        
            
        
        
        let pass = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if pass.count < 6{
            return "Password needs 6 char atleast"
        }
        
        
        if passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines) != passwordTextField2.text!.trimmingCharacters(in: .whitespacesAndNewlines){
            return "Password does not match."
        }
        
        
        return nil
    }
    
    
    
    
    //func for when register button is tapped
    @IBAction func registerTapped(_ sender: Any) {
      
        //Kolla så att allt stämmer ihop med kraven för registrering
        let checkError = validateFields()
        
        if checkError != nil{
            showError(checkError!)
        }
        else {
            
            let firstName = firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastName = lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            
            // create user in database
            Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
                
                if error != nil {
            
                    self.showError("Error while trying to create user.")
            
                }
                else {
                    let db = Firestore.firestore()
                    db.collection("usersWmail").addDocument(data: ["firstName": firstName, "lastName": lastName, "email": email, "password": password, "uID": result!.user.uid]) { (err) in
                        
                        if err != nil {
                            self.showError("Data could not be saved")
                        }
                        
                    }
                    // if ok, go to home screen with logged in account
                    
                   self.gotoHomeScreen()
                    
                    
                }
            }
            
        }
    
    }
    //func to show error
    func showError(_ message: String) {
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    
    //func to go to home screen
    func gotoHomeScreen() {
        
        let homeViewController = storyboard?.instantiateViewController(identifier: Constants.Story.homeViewController) as? HomeViewController
        
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
   }

}
