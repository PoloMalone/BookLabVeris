//
//  AddViewController.swift
//  bookLab
//
//  Created by Josef Jakobsson on 2021-09-17.
//

import UIKit
import Firebase


class AddViewController: UIViewController {

    var admin: AdminViewController?
    

    @IBOutlet weak var quantTextField: UITextField!
    
    
    @IBOutlet weak var descTextField: UITextView!
    
    
    @IBOutlet weak var itemNameTextField: UITextField!
    
    
    @IBOutlet weak var itemIDTextField: UITextField!
    
    @IBOutlet weak var errorLabelAdd: UILabel!
    
    @IBOutlet weak var addItemTapped: UIButton!
    
    @IBOutlet weak var addItemLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.descTextField.layer.borderColor = UIColor.lightGray.cgColor
        self.descTextField.layer.borderWidth = 1
        // Do any additional setup after loading the view.
    }


//when add item button is tapped
    @IBAction func addItemTapped(_ sender: Any) {
    //check user
        var email = ""
        let user = Auth.auth().currentUser
        if let user = user {
            _ = user.uid
            let bookEmail = user.email
            email = bookEmail!
           
        }
        
        let checkFields = validateFields()
        //check if fields are ok before adding
        if checkFields != nil{
            showError(checkFields!)
        }
        
        else{
            
            let itemName = itemNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let itemID = itemIDTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let desc = descTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let quant = quantTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            
            //add to the database items
            Firestore.firestore().collection("items").addDocument(data:  [
                                                                    "itemName": itemName,
                                                                    "itemId": itemID,
                                                                    "description": desc,
                                                                    "quantity": quant]){ (err) in
                if err != nil {
                    self.showError("Data could not be saved")
                }
            }
            //add to the database history
            Firestore.firestore().collection("history").addDocument(data:  [
                                                                    "historyAction": "Item added",
                                                                    "historyId": itemID,
                                                                    "historyEmail": email,
                                                                    "historyName": itemName,
                                                                    "timeStamp": Timestamp(date: Date())]){ (err) in
                if err != nil {
                    print("could not book item")
                }
                                                                    }

            
            //clear textfields
            self.textFieldClear(textField: itemNameTextField)
            self.textFieldClear(textField: itemIDTextField)
            self.textFieldClear(textField: quantTextField)
            descTextField.text = nil
            errorLabelAdd.text = nil
            self.showAdd("Item Added!")
            
            
        }
        
        

        
        
        
        
        
        
    }
    
    //function that checks fields
    func validateFields() -> String? {
       
        
        
        if itemNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||            itemIDTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            descTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            quantTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            return "Please fill all the fields above."
        }
        
        guard let quantNum = Int(quantTextField.text!) else {
                    return "Quantity value needs to be a number"
                }

        
        return nil
    }

    //error message show, change alpha to 1
    func showError(_ message: String) {
        errorLabelAdd.text = message
        errorLabelAdd.alpha = 1
     }
    
    //clear textfield func
    func textFieldClear(textField: UITextField) {
        textField.text = ""
    }
    //show message
    func showAdd(_ message: String) {
        addItemLabel.text = message
        addItemLabel.alpha = 1
    }


}




