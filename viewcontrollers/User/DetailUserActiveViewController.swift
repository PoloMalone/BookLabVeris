//
//  DetailUserActiveViewController.swift
//  bookLab
//
//  Created by Josef Jakobsson on 2021-10-16.
//

import UIKit
import Firebase
import FirebaseAnalytics
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth

class DetailUserActiveViewController: UIViewController {

    @IBOutlet weak var itemNameLabel: UILabel!
    
    
    @IBOutlet weak var itemDescLabel: UITextView!
    
    @IBOutlet weak var userActiveLabel: UILabel!
    
    @IBOutlet weak var userActiveTimeLabel: UILabel!
    
    @IBOutlet weak var userActiveIdLabel: UILabel!
    
    
    @IBOutlet weak var userReturnButtonTapped: UIButton!
    
    //variables and lists
    var activeList = [active]()
    var activeCollectionRef: CollectionReference!
    var itemCollectionRef: CollectionReference!
    var activeClass: active?
    var item: items?
    
    //what to show on phone
    override func viewDidLoad() {
        super.viewDidLoad()
        itemCollectionRef = Firestore.firestore().collection("items")
        activeCollectionRef = Firestore.firestore().collection("active")
        itemNameLabel.text = "\((activeClass?.activeName)!)"
        itemDescLabel.text = "\((activeClass?.activeDesc)!)"
        userActiveLabel.text = "\((activeClass?.activeEmail)!)"
        userActiveTimeLabel.text = "\((activeClass?.timestamp)!)"
        userActiveIdLabel.text = "\((activeClass?.activeId)!)"
        DispatchQueue.main.async {
            self.getDocActive()
        }
        
  
    }
    //some more variables
    static var x : String?
    static var userActiveDcId : String?
    static var useractiveDcIdForDelete: String?
    static var useritemQuant: String?
    

    //func for when user taps return button
    @IBAction func userReturnButtonTapped(_ sender: Any) {
        
        
            
        //check what user
        var email = ""
        let user = Auth.auth().currentUser
        if let user = user {
            _ = user.uid
            let bookEmail = user.email
            email = bookEmail!
        }
        
        let Name = activeClass?.activeName!
        let Id = activeClass?.activeId!
        let Desc = activeClass?.activeDesc!
        let bookingId = activeClass?.activeBookingId!

        
        if  DetailUserActiveViewController.userActiveDcId != nil{
            print("INSIDE IF STATEMENT FOR DOCUMENT")
                let x2 = DetailUserActiveViewController.userActiveDcId!
                DispatchQueue.main.async {
                    self.getDocQuant(x: x2)
                }
            
                let docRef = Firestore.firestore().collection("items").document("\(DetailUserActiveViewController.userActiveDcId!)")
                let numQuant = DetailUserActiveViewController.useritemQuant!
                let quantNum = Int(numQuant)
                print(quantNum!)
                let num = quantNum! + 1
                docRef.updateData([
                    "quantity": String(num)
                ]) { err in
                    if let err = err {
                        print("Error updating document: \(err)")
                    } else {
                        print("Document successfully updated")
                    }
                }
                
        } else if DetailUserActiveViewController.userActiveDcId == nil {
                print("IF NOT IN TABLE")
                
                let num1 = 1
                let stringnum = String(num1)
                    
            
                //add item back to items list in database
                Firestore.firestore().collection("items").addDocument(data:  [
                                                                "description": Desc!,
                                                                "itemId": Id!,
                                                                "itemName": Name!,
                                                                "quantity": stringnum,]){ (err) in
                                                                    print("IF NOT IN TABLE")
                if err != nil {
                    print("could not book item")
                }
                }
        
            }
        
        //add action to history in database
        Firestore.firestore().collection("history").addDocument(data:  [
                                                                "historyAction": "Returned By",
                                                                "historyId": bookingId!,
                                                                "historyEmail": email,
                                                                "historyName":Name!,
                                                                "timeStamp": Timestamp(date: Date())]){ (err) in
            if err != nil {
                print("could not book item")
            }
                                                                }
        
     
        activeCollectionRef.document("\(DetailUserActiveViewController.useractiveDcIdForDelete!)").delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
        //go back to user home screen
        self.gotoHomeScreen()
    }
    
    //get document id on active item
    func getDocActive() {

        self.itemCollectionRef.whereField("itemId", isEqualTo: "\((activeClass?.activeId)!)").getDocuments { (snapshot, err) in

        if let err = err {
            print("Error getting documents: \(err)")
        } else {
            for document in snapshot!.documents {
                if document == document {
                    DetailUserActiveViewController.userActiveDcId = document.documentID
                    let x = DetailUserActiveViewController.userActiveDcId!
                    self.getDocQuant(x: x)
                    print(DetailUserActiveViewController.userActiveDcId!)
                   }
                }
            }
        }
        self.activeCollectionRef.whereField("activeBookingId", isEqualTo: "\((activeClass?.activeBookingId)!)").getDocuments { (snapshot, err) in

        if let err = err {
            print("Error getting documents: \(err)")
        } else {
            for document in snapshot!.documents {
                if document == document {
                    DetailUserActiveViewController.useractiveDcIdForDelete = document.documentID
                   }
                }
            }
        }
        
    }
    
    //get document id amount
    func getDocQuant(x: String) {
        
        let docRef = Firestore.firestore().collection("items").document("\(x)")

        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                DetailUserActiveViewController.useritemQuant = (document.get("quantity") as? String)
            } else {
                print("Document does not exist")
            }
        }
        
    }
    
    //go back to home screen (user) 
    func gotoHomeScreen() {

        
        let homeViewController = storyboard?.instantiateViewController(identifier: Constants.Story.homeViewController) as? HomeViewController
        
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
 
   }



}
