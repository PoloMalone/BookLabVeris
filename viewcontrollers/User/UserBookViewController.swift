//
//  UserBookViewController.swift
//  bookLab
//
//  Created by Josef Jakobsson on 2021-10-07.
//

import UIKit
import Firebase
import FirebaseAnalytics
import FirebaseFirestore
import FirebaseFirestoreSwift

class UserBookViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
        
    
    @IBOutlet weak var userBookTableView: UITableView!
    
    
//variables / lists
    var bookedList = [booked]()
    var bookedCollectionRef: CollectionReference!
    
    static var userDate: Date?
    static var userActiveUser: String?
    
    func tableView(_ userBookTableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "showDetailUserBook", sender: self)
      
    }
    
    func tableView(_ userBookTableView: UITableView, numberOfRowsInSection section: Int) -> Int {
   
        let filteredList = bookedList.filter { $0.bookEmail == UserBookViewController.userActiveUser }
        return filteredList.count
    }
    
    func tableView(_ userBookTableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = userBookTableView.dequeueReusableCell(withIdentifier: "cell4")
        let filteredList = bookedList.filter { $0.bookEmail == UserBookViewController.userActiveUser }
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell4")
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
            self.userBookTableView.reloadData()
        }
        let user = Auth.auth().currentUser
        if let user = user {
            let name = user.email
            UserBookViewController.userActiveUser = name!
        }
        userBookTableView.delegate = self
        userBookTableView.dataSource = self
        bookedCollectionRef = Firestore.firestore().collection("booked")
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let filteredList = bookedList.filter { $0.bookEmail == UserBookViewController.userActiveUser }
        if let destination = segue.destination as? DetailUserBookViewController{
            destination.book = filteredList[(userBookTableView.indexPathForSelectedRow?.row)!]
            userBookTableView.deselectRow(at: userBookTableView.indexPathForSelectedRow!, animated: true)
            DispatchQueue.main.async{
                self.userBookTableView.reloadData()
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
                    UserBookViewController.userDate = stamp.dateValue()
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "YY/MM/dd, HH:mm:ss"
                    let stringifyDate = dateFormatter.string(from: UserBookViewController.userDate!)
                    let stringed = String(stringifyDate)
                    
                    let newBook = booked(bookDesc: bookdesc, bookEmail: bookemail, bookId: bookid, bookName: bookname, bookingId: bookingId, timestamp: stringed)
  
                    self.bookedList.append(newBook)
                    }

                    self.userBookTableView.reloadData()
                DispatchQueue.main.async {
                    self.userBookTableView.reloadData()
                }
                
                
            }
        }
    }




}
