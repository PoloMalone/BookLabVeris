//
//  UserDetailViewController.swift
//  bookLab
//
//  Created by Josef Jakobsson on 2021-10-05.
//

import UIKit
import Firebase
import FirebaseAnalytics
import FirebaseFirestore
import FirebaseFirestoreSwift




class UserDetailViewController: UIViewController {

    @IBOutlet weak var itemNameLabel: UILabel!
    
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var quanLabel: UILabel!
    @IBOutlet weak var descTextView: UITextView!
    
    
    @IBOutlet weak var userStatusColor: UILabel!
    @IBOutlet weak var userBookTapped: UIButton!
    
    //variables
    var item: items?
    var itemsCollectionRef: CollectionReference!
    
    static var userdcId : String?
    
    //what to show on phone
    override func viewDidLoad() {
        super.viewDidLoad()
        
        itemsCollectionRef = Firestore.firestore().collection("items")
        descTextView.text = "\((item?.desc)!)"
        itemNameLabel.text = "\((item?.name)!)"
        quanLabel.text = "\((item?.quant)!)"
        idLabel.text = "\((item?.id)!)"
        getDoc()
        
        let nrForColor = Int((item?.quant)!)
        print(nrForColor!)
        if nrForColor == 0{
            userStatusColor.text = "Unavailable"
            userStatusColor.textColor = UIColor.red
            userBookTapped.isHidden = true
        } else {
            userStatusColor.text = "Available"
            userStatusColor.textColor = UIColor.green
            userBookTapped.isHidden = false
        }
     
    }
    

    
    //func when user taps book button
    @IBAction func userBookTapped(_ sender: Any) {
        
        print(UserDetailViewController.userdcId!)
        let itemsRef = Firestore.firestore().collection("items").document("\(UserDetailViewController.userdcId!)")
        let numQuant = item?.quant
        let quantNum = Int(numQuant!)
        print(quantNum!)
        let num = quantNum! - 1
        
        itemsRef.updateData([
            "quantity": String(num)
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
        
        var email = ""
        let user = Auth.auth().currentUser
        if let user = user {
            _ = user.uid
            let bookEmail = user.email
            email = bookEmail!
            print(bookEmail!)
        }
        let bookName = item?.name!
        let bookId = item?.id!
        let bookDesc = item?.desc!
        print(bookName!)
        print(bookId!)
        print(bookDesc!)
        
        
        let bookBookingId = Int.random(in: 0...10000) + Int.random(in: 0...30000)
        let stringedBookingId = String(bookBookingId)
        //get random booking id and add to booked in database
        Firestore.firestore().collection("booked").addDocument(data:  [
                                                                "bookDesc": bookDesc!,
                                                                "bookEmail": email,
                                                                "bookId": bookId!,
                                                                "bookName": bookName!,
                                                                "bookingId": stringedBookingId,
                                                                "timeStamp": Timestamp(date: Date())]){ (err) in
            if err != nil {
                print("could not book item")
            }
                                                                }
        
        //add to history in database
        Firestore.firestore().collection("history").addDocument(data:  [
                                                                "historyAction": "Booked By",
                                                                "historyId": stringedBookingId,
                                                                "historyEmail": email,
                                                                "historyName":bookName!,
                                                                "timeStamp": Timestamp(date: Date())]){ (err) in
            if err != nil {
                print("could not book item")
            }
                                                                }
        //go back to user home screen
        self.gotoHomeScreen()
    }
    
    
    //func that goes back to homescreen
    func gotoHomeScreen() {

        
        let homeViewController = storyboard?.instantiateViewController(identifier: Constants.Story.homeViewController) as? HomeViewController
        
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
 
   }

    //func that gets item document id
    func getDoc() {

     self.itemsCollectionRef.whereField("itemId", isEqualTo: "\((item?.id)!)").getDocuments { (snapshot, err) in

        if let err = err {
            print("Error getting documents: \(err)")
        } else {
            for document in snapshot!.documents {
                if document == document {
                    UserDetailViewController.userdcId = document.documentID
                    print(UserDetailViewController.userdcId!)
                   }
                }
            }
        }
    }
    
    
}
