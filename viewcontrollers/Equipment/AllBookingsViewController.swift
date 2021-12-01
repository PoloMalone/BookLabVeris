//
//  AllBookingsViewController.swift
//  bookLab
//
//  Created by Josef Jakobsson on 2021-10-12.
//

import UIKit
import Firebase
import FirebaseAnalytics
import FirebaseFirestore
import FirebaseFirestoreSwift


class AllBookingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var allBookingsTableView: UITableView!
    //initialize list and collectionref
    var bookedList = [booked]()
    var bookedCollectionRef: CollectionReference!
    
    static var allDate: Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async {
            self.allBookingsTableView.reloadData()
        }
        
        allBookingsTableView.delegate = self
        allBookingsTableView.dataSource = self
        //collectionref value = from database
        bookedCollectionRef = Firestore.firestore().collection("booked")

        // Do any additional setup after loading the view.
    }
    


    func tableView(_ allBookingsTableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "showDetailAllBook", sender: self)
      
    }
    
    func tableView(_ allBookingsTableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookedList.count
    }
    
    func tableView(_ allBookingsTableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = allBookingsTableView.dequeueReusableCell(withIdentifier: "cell5")
        
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell5")
        }
        
        let nr1time = bookedList[indexPath.row].timestamp
        let nr1Id = bookedList[indexPath.row].bookEmail
        let nr2time = "Date: "
        let nr2Id = "email: "
        let nr12 = "\(nr2time) \(nr1time!), \(nr2Id) \(nr1Id!)"
        
        cell?.textLabel?.text = bookedList[indexPath.row].bookName
        cell?.detailTextLabel?.text = nr12
        
        
        return cell!
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? DetailAllBookViewController{
            destination.book = bookedList[(allBookingsTableView.indexPathForSelectedRow?.row)!]
            allBookingsTableView.deselectRow(at: allBookingsTableView.indexPathForSelectedRow!, animated: true)
            DispatchQueue.main.async{
                self.allBookingsTableView.reloadData()
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
            //snapshot read from "booked" in database
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
                    AllBookingsViewController.allDate = stamp.dateValue()
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "YY/MM/dd, HH:mm:ss"
                    let stringifyDate = dateFormatter.string(from: AllBookingsViewController.allDate!)
                    let stringed = String(stringifyDate)
                    
                    let newBook = booked(bookDesc: bookdesc, bookEmail: bookemail, bookId: bookid, bookName: bookname, bookingId: bookingId, timestamp: stringed)
 
                    self.bookedList.append(newBook)
                    }
             
                    self.allBookingsTableView.reloadData()
                DispatchQueue.main.async {
                    self.allBookingsTableView.reloadData()
                }
            }
        }
    }




}
