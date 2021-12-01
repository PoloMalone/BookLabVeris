//
//  DetailUserBookViewController.swift
//  bookLab
//
//  Created by Josef Jakobsson on 2021-10-13.
//

import UIKit
import Firebase
import FirebaseAnalytics
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth

class DetailUserBookViewController: UIViewController {

    @IBOutlet weak var bookNameLabel: UILabel!
    
    @IBOutlet weak var bookDescTextView: UITextView!
    
    @IBOutlet weak var bookEmailLabel: UILabel!
    
    @IBOutlet weak var bookTimeLabel: UILabel!
    
    @IBOutlet weak var bookIdLabel: UILabel!
    
    @IBOutlet weak var pickupButtonTapped: UIButton!
    
//variables /lists initiliaze
    var bookedList = [booked]()
    var bookedCollectionRef: CollectionReference!
    var book: booked?
    
    static var x : String?
    static var getDocForDelete: String?
    
    
    //what to show on phone
    override func viewDidLoad() {
        super.viewDidLoad()
        bookedCollectionRef = Firestore.firestore().collection("booked")
        bookNameLabel.text = "\((book?.bookName)!)"
        bookEmailLabel.text = "\((book?.bookEmail)!)"
        bookDescTextView.text = "\((book?.bookDesc)!)"
        bookTimeLabel.text = "\((book?.timestamp)!)"
        bookIdLabel.text = "\((book?.bookId)!)"
        self.getDoc()
    }
    

    //func for when pickup button is tapped (user)
    @IBAction func pickupButtonTapped(_ sender: Any) {
        
        
        var email = ""
        let user = Auth.auth().currentUser
        if let user = user {
            _ = user.uid
            let bookEmail = user.email
            email = bookEmail!
            print(bookEmail!)
        }
        let activeName = book?.bookName!
        let activeId = book?.bookId!
        let activeDesc = book?.bookDesc!
        let bookingId = book?.bookingId!
        
        
        //add item to active in database
        Firestore.firestore().collection("active").addDocument(data:  [
                                                                "activeDesc": activeDesc!,
                                                                "activeEmail": email,
                                                                "activeId": activeId!,
                                                                "activeName": activeName!,
                                                                "activeBookingId": bookingId!,
                                                                "timeStamp": Timestamp(date: Date())]){ (err) in
            if err != nil {
                print("could not book item")
            }
                                                                }
        //add action to history in database
        Firestore.firestore().collection("history").addDocument(data:  [
                                                                "historyAction": "Picked Up By",
                                                                "historyId": bookingId!,
                                                                "historyEmail": email,
                                                                "historyName":activeName!,
                                                                "timeStamp": Timestamp(date: Date())]){ (err) in
            if err != nil {
                print("could not book item")
            }
                                                                }

        
  
        bookedCollectionRef.document("\(DetailUserBookViewController.getDocForDelete!)").delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
        //go back to user home screen
        self.gotoHomeScreen()
    }
    //func to go back to user home screen
    func gotoHomeScreen() {

        
        let homeViewController = storyboard?.instantiateViewController(identifier: Constants.Story.homeViewController) as? HomeViewController
        
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
 
   }
    
    //get document id
    func getDoc() {

        self.bookedCollectionRef.whereField("bookId", isEqualTo: "\((book?.bookId)!)").getDocuments { (snapshot, err) in

        if let err = err {
            print("Error getting documents: \(err)")
        } else {
            for document in snapshot!.documents {
                if document == document {
                    DetailUserBookViewController.getDocForDelete = document.documentID
                    
                   }
                }
            }
        }
    }

}
