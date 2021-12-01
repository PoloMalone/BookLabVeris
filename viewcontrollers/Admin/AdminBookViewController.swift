//
//  AdminBookViewController.swift
//  bookLab
//
//  Created by Josef Jakobsson on 2021-10-07.
//

import UIKit
import Firebase
import FirebaseAnalytics
import FirebaseFirestore
import FirebaseFirestoreSwift

class AdminBookViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var adminBookTableView: UITableView!
    
    //initialize list of booked items and collectionref
    var bookedList = [booked]()
    var bookedCollectionRef: CollectionReference!
    static var adminDate : Date?
    static var adminActiveUser: String?
    
    
    func tableView(_ adminBookTableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "showDetailAdminBook", sender: self)
      
    }
    
    func tableView(_ adminBookTableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let filteredList = bookedList.filter {$0.bookEmail == AdminBookViewController.adminActiveUser}
        return filteredList.count
    }
    
    func tableView(_ adminBookTableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = adminBookTableView.dequeueReusableCell(withIdentifier: "cell3")
        let filteredList = bookedList.filter {$0.bookEmail == AdminBookViewController.adminActiveUser}
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell3")
        }
        
        let nr1time = filteredList[indexPath.row].timestamp
        let nr1Id = filteredList[indexPath.row].bookId
        let nr2time = "Date: "
        let nr2Id = "id: "
        let nr12 = "\(nr2time) \(nr1time!), \(nr2Id) \(nr1Id!)"
        

        cell?.textLabel?.text = filteredList[indexPath.row].bookName
        cell?.detailTextLabel?.text = nr12
        
        
        return cell!
    }

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async {
            self.adminBookTableView.reloadData()
        }
        let user = Auth.auth().currentUser
        if let user = user {
            let name = user.email
            AdminBookViewController.adminActiveUser = name!
        }
        adminBookTableView.delegate = self
        adminBookTableView.dataSource = self
        bookedCollectionRef = Firestore.firestore().collection("booked")

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let filteredList = bookedList.filter {$0.bookEmail == AdminBookViewController.adminActiveUser}
        if let destination = segue.destination as? DetailAdminBookViewController{
            destination.book = filteredList[(adminBookTableView.indexPathForSelectedRow?.row)!]
            adminBookTableView.deselectRow(at: adminBookTableView.indexPathForSelectedRow!, animated: true)
            DispatchQueue.main.async{
                self.adminBookTableView.reloadData()
            }
        }
    }
    


    
    override func viewWillAppear(_ animated: Bool) {
        //read from database on what to display on tableview
        bookedCollectionRef.addSnapshotListener{QuerySnapshot, error in
            guard let snapshot = QuerySnapshot else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            //snapshot read from "items" in database
            snapshot.documentChanges.forEach {diff in
                if (diff.type == .added) {
                    
                    let data = diff.document.data()
                    
                    let bookdesc = data["bookDesc"] as? String
                    let bookid = data["bookId"] as? String ?? "0000"
                    let bookemail = data["bookEmail"] as? String
                    let bookname = data["bookName"] as? String
                    let bookingId = data["bookingId"] as? String
                    guard let stamp = data["timeStamp"] as? Timestamp else {
                         return
                     }
                    AdminBookViewController.adminDate = stamp.dateValue()
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "YY/MM/dd, HH:mm:ss"
                    let stringifyDate = dateFormatter.string(from: AdminBookViewController.adminDate!)
                    let stringed = String(stringifyDate)
                   
                    let newBook = booked(bookDesc: bookdesc, bookEmail: bookemail, bookId: bookid, bookName: bookname, bookingId: bookingId, timestamp: stringed)

                    self.bookedList.append(newBook)
                    }
               
                    self.adminBookTableView.reloadData()
                DispatchQueue.main.async {
                    self.adminBookTableView.reloadData()
                }
            }
        }
    }


}
