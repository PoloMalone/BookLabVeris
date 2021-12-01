//
//  DetailAdminActiveViewController.swift
//  bookLab
//
//  Created by Josef Jakobsson on 2021-10-14.
//

import UIKit
import Firebase
import FirebaseAnalytics
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth

class DetailAdminActiveViewController: UIViewController {

    @IBOutlet weak var activeItemLabel: UILabel!
    
    @IBOutlet weak var activeDescLabel: UITextView!
    
    @IBOutlet weak var activeEmailLabel: UILabel!
    
    @IBOutlet weak var activeTimeLabel: UILabel!
    
    @IBOutlet weak var activeIdLabel: UILabel!
    
    @IBOutlet weak var returnButtonTapped: UIButton!
    
    //lists and variables
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
        print((activeClass?.activeId)!)
        activeItemLabel.text = "\((activeClass?.activeName)!)"
        activeEmailLabel.text = "\((activeClass?.activeEmail)!)"
        activeDescLabel.text = "\((activeClass?.activeDesc)!)"
        activeTimeLabel.text = "\((activeClass?.timestamp)!)"
        activeIdLabel.text = "\((activeClass?.activeId)!)"
        DispatchQueue.main.async {
            self.getDocActive()
        }
        print("VIEW LOADED")
      
    }
    //more variables
    static var x : String?
    static var adminActiveDcId : String?
    static var activeDcIdForDelete: String?
    static var itemQuant: String?
    

 //func return button tapped
    @IBAction func returnButtonTapped(_ sender: Any) {
        
        
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
        
        if  DetailAdminActiveViewController.adminActiveDcId != nil{
            print("INSIDE IF STATEMENT FOR DOCUMENT")
                print(DetailAdminActiveViewController.adminActiveDcId!)
                let x1 = DetailAdminActiveViewController.adminActiveDcId!
                DispatchQueue.main.async {
                    self.getDocQuant(x: x1)
                }
                
            
                let docRef = Firestore.firestore().collection("items").document("\(DetailAdminActiveViewController.adminActiveDcId!)")
                let numQuant = DetailAdminActiveViewController.itemQuant!
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
            DetailAdminActiveViewController.adminActiveDcId = nil
        } else if DetailAdminActiveViewController.adminActiveDcId == nil{
            
                let num1 = 1
                let stringnum = String(num1)
            //add item back to items list
                Firestore.firestore().collection("items").addDocument(data:  [
                                                                "description": Desc!,
                                                                "itemId": Id!,
                                                                "itemName": Name!,
                                                                "quantity": stringnum,]){ (err) in
                                                                    
                if err != nil {
                    print("could not book item")
                }
                }
            
            }
        
        //add action to history that item was returned
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

        
        
        //delete from active item
        print("OUTSIDE THE STATEMENT")
        activeCollectionRef.document("\(DetailAdminActiveViewController.activeDcIdForDelete!)").delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
    
        self.gotoAdminScreen()
    }
                                                                
  
    //func to get document id
    func getDocActive() {

        self.itemCollectionRef.whereField("itemId", isEqualTo: "\((activeClass?.activeId)!)").getDocuments { (snapshot, err) in

        if let err = err {
            print("Error getting documents: \(err)")
        } else {
            for document in snapshot!.documents {
                if document == document {
                    DetailAdminActiveViewController.adminActiveDcId = document.documentID
                    let x = DetailAdminActiveViewController.adminActiveDcId!
                    self.getDocQuant(x: x)
                    print("Initial document")
                    print(DetailAdminActiveViewController.adminActiveDcId!)
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
                    DetailAdminActiveViewController.activeDcIdForDelete = document.documentID
                    print("LAST DOCUMENT")
                    print(document.documentID)
                   }
                }
            }
        }
    }
    
    //get amount of that item
    func getDocQuant(x: String) {
        
        let docRef = Firestore.firestore().collection("items").document("\(x)")

        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                DetailAdminActiveViewController.itemQuant = (document.get("quantity") as? String)
                
            } else {
                print("Document does not exist")
            }
        }
        
    }


    //func go back to admin screen
    func gotoAdminScreen() {
        
        
        let adminViewController = storyboard?.instantiateViewController(identifier:
            Constants.Story.adminViewController) as? AdminViewController
        
        
        view.window?.rootViewController = adminViewController
        view.window?.makeKeyAndVisible()

    }
}
