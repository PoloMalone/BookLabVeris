//
//  DetailsViewController.swift
//  bookLab
//
//  Created by Josef Jakobsson on 2021-10-01.
//
import UIKit
import Firebase
import FirebaseAnalytics
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth

class DetailsViewController: UIViewController {

    var admin: AdminViewController?
    
    
    @IBOutlet weak var itemIdLabel: UILabel!
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var itemQuantLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    @IBOutlet weak var deleteItemButton: UIButton!
    
    @IBOutlet weak var editTapped: UIButton!
    

    @IBOutlet weak var bookTapped: UIButton!
    
    
    @IBOutlet weak var statusColor: UILabel!
    
    //initialize objects from helper
    var item: items?
    
    var itemsCollectionRef: CollectionReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        itemsCollectionRef = Firestore.firestore().collection("items")
        descriptionTextView.text = "\((item?.desc)!)"
        itemNameLabel.text = "\((item?.name)!)"
        itemQuantLabel.text = "\((item?.quant)!)"
        itemIdLabel.text = "\((item?.id)!)"
        getDoc()
        
        
        //check availabilty of item
        let nrForColor = Int((item?.quant)!)
        print(nrForColor!)
        if nrForColor == 0{
            statusColor.text = "Unavailable"
            statusColor.textColor = UIColor.red
            bookTapped.isHidden = true
        } else {
            statusColor.text = "Available"
            statusColor.textColor = UIColor.green
            bookTapped.isHidden = false
        }
    }
    
    static var x : String?
    static var dcId : String?
    
    
    //func when deletebutton is tapped
    @IBAction func deleteTapped(_ sender: Any) {
        
       //verify user
        var email = ""
        let user = Auth.auth().currentUser
        if let user = user {
            _ = user.uid
            let bookEmail = user.email
            email = bookEmail!
            print(bookEmail!)
        }
        //delete document
        let bookName = item?.name!
         let itemId = (self.item?.id)!
        DetailsViewController.x = itemId
        Firestore.firestore().collection("items").whereField("itemId", isEqualTo: itemId).getDocuments() { (querySnapshot, err) in
          if let err = err {
            print("Error getting documents: \(err)")
          } else {
            for document in querySnapshot!.documents {
              document.reference.delete()
               
                
            }
          }
        }
        //add deleted item to history
        let bookId = item?.id!
        Firestore.firestore().collection("history").addDocument(data:  [
                                                                "historyAction": "Deleted item",
                                                                "historyId": bookId!,
                                                                "historyEmail": email,
                                                                "historyName": bookName!,
                                                                "timeStamp": Timestamp(date: Date())]){ (err) in
            if err != nil {
                print("could not book item")
            }
                                                                }
        goBack()

        }
    
    
    
    //func when edit button tapped
    @IBAction func editTapped(_ sender: Any) {
        getDoc()
       

        //alert controllers
        let alertController = UIAlertController(title: self.item?.name, message: "Edit the item below", preferredStyle: .alert)
        //buttons on alert controller
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let edit = UIAlertAction(title: "Edit", style:.default){(_)in

            let id = self.item?.id
        
            print(id!)
            let name = alertController.textFields?[0].text?.trimmingCharacters(in: .whitespacesAndNewlines)
            print(name!)
            let desc = alertController.textFields?[1].text?.trimmingCharacters(in: .whitespacesAndNewlines)
            print(desc!)
            let quant = alertController.textFields?[2].text?.trimmingCharacters(in: .whitespacesAndNewlines)
            print(quant!)
            
            //call edit item func
            self.editItem(name: name!, id: id!, desc: desc!, quant: quant!)
            //go back to admin screen
            self.gotoAdminScreen()
        }
        
        
        
        alertController.addTextField(configurationHandler: { (textField : UITextField!) -> Void in
            textField.text = self.item?.name
        })
        
        alertController.addTextField(configurationHandler: { (textField : UITextField!) -> Void in
            textField.text = self.item?.desc
        })
    
        alertController.addTextField(configurationHandler: { (textField : UITextField!) -> Void in
            textField.text = self.item?.quant
        })
        
        
        alertController.addAction(edit)
        alertController.addAction(cancel)
        self.present(alertController, animated: true)
        }
    
    
    
    //func to edit item after button is tapped
    func editItem(name: String, id: String, desc: String, quant: String){
     
        
        print("checking item id")
        print(id)
        print("ute")
        print(DetailsViewController.dcId!)
        let itemsRef = Firestore.firestore().collection("items").document("\(DetailsViewController.dcId!)")

        itemsRef.updateData([
            "itemName": name,
            "description": desc,
            "quantity": quant
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
        Firestore.firestore().collection("history").addDocument(data:  [
                                                                "historyAction": "Edited item",
                                                                "historyId": bookId!,
                                                                "historyEmail": email,
                                                                "historyName":bookName!,
                                                                "timeStamp": Timestamp(date: Date())]){ (err) in
            if err != nil {
                print("could not book item")
            }
                                                                }

    }

    
    //func to go back to admin screen
    func gotoAdminScreen() {
        
        
        let adminViewController = storyboard?.instantiateViewController(identifier:
            Constants.Story.adminViewController) as? AdminViewController
        
        
        view.window?.rootViewController = adminViewController
        view.window?.makeKeyAndVisible()

    }
    //func to go back one step in screen
    func goBack()  {
        if let nav = self.navigationController {
            nav.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    //func to get the docuemnt id on whhat document you want to alter
    func getDoc() {

     self.itemsCollectionRef.whereField("itemId", isEqualTo: "\((item?.id)!)").getDocuments { (snapshot, err) in

        if let err = err {
            print("Error getting documents: \(err)")
        } else {
            for document in snapshot!.documents {
                if document == document {
                    DetailsViewController.dcId = document.documentID
                    print(DetailsViewController.dcId!)
                   }
                }
            }
        }
    }
    
//func when book button is tapped
    @IBAction func bookTapped(_ sender: Any) {
        
        print(DetailsViewController.dcId!)
        let itemsRef = Firestore.firestore().collection("items").document("\(DetailsViewController.dcId!)")
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
       //generate random book id
        let bookBookingId = Int.random(in: 0...10000) + Int.random(in: 0...30000)
        let stringedBookingId = String(bookBookingId)
        //add booked item to booked list with booking id
        Firestore.firestore().collection("booked").addDocument(data:  [
                                                                "bookDesc": bookDesc!,
                                                                "bookEmail": email,
                                                                "bookId": bookId!,
                                                                "bookName": bookName!,
                                                                "bookingId":stringedBookingId,
                                                                "timeStamp": Timestamp(date: Date())]){ (err) in
            if err != nil {
                print("could not book item")
            }
                                                                }
        //also add booked item to history
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
        self.gotoAdminScreen()


    }
    
}
    

