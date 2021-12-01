//
//  DetailAdminBookViewController.swift
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

class DetailAdminBookViewController: UIViewController {

    @IBOutlet weak var bookNameLabel: UILabel!
    
    @IBOutlet weak var bookEmailLabel: UILabel!
    
   
    @IBOutlet weak var bookDescTextView: UITextView!
    
    @IBOutlet weak var bookTimeLabel: UILabel!
    
    
    @IBOutlet weak var bookIdLabel: UILabel!
    
    @IBOutlet weak var pickupButtonTapped: UIButton!
    
    //initialize list of items and collectionref
    var bookedList = [booked]()
    var bookedCollectionRef: CollectionReference!
    var book: booked?
    //variables
    static var x : String?
    static var getDocForDelete: String?
    static var bookingId: String?
    
    
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
    
    //func for when pickup button is tapped

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

      
        
        //add to active items in database
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
        //add to history in database
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
 //removing from booked when picked up
        bookedCollectionRef.document("\(DetailAdminBookViewController.getDocForDelete!)").delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
        self.gotoAdminScreen()
    }
    

    //func to go back to admin screen
    func gotoAdminScreen() {
        
        
        let adminViewController = storyboard?.instantiateViewController(identifier:
            Constants.Story.adminViewController) as? AdminViewController
        
        
        view.window?.rootViewController = adminViewController
        view.window?.makeKeyAndVisible()

    }
    
    //func to get document id of an booked item.
    func getDoc() {

        self.bookedCollectionRef.whereField("bookId", isEqualTo: "\((book?.bookId)!)").getDocuments { (snapshot, err) in

        if let err = err {
            print("Error getting documents: \(err)")
        } else {
            for document in snapshot!.documents {
                if document == document {
                    DetailAdminBookViewController.getDocForDelete = document.documentID
                    
                    
                   }
                }
            }
        }
    }
    
    
}
