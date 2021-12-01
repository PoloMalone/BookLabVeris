//
//  AdminActiveViewController.swift
//  bookLab
//
//  Created by Josef Jakobsson on 2021-10-14.
//

import UIKit
import Firebase
import FirebaseAnalytics
import FirebaseFirestore
import FirebaseFirestoreSwift

class AdminActiveViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var adminActiveTableView: UITableView!
    //initialize list of items and collectionref
    var activeList = [active]()
    var activeCollectionRef: CollectionReference!
    //variables
    static var adminActiveDate: Date?
    static var adminActiveUser: String?
    
  
    override func viewDidLoad() {
        super.viewDidLoad()
        let user = Auth.auth().currentUser
        if let user = user {
            let name = user.email
            AdminActiveViewController.adminActiveUser = name!
        }
        
        adminActiveTableView.delegate = self
        adminActiveTableView.dataSource = self
        
        activeCollectionRef = Firestore.firestore().collection("active")
    }
    


    func tableView(_ adminActiveTableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "showDetailAdminActive", sender: self)
        
    }
    
    func tableView(_ adminActiveTableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let filteredList = activeList.filter {$0.activeEmail == AdminActiveViewController.adminActiveUser}
        return filteredList.count
    }
    
    func tableView(_ adminActiveTableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = adminActiveTableView.dequeueReusableCell(withIdentifier: "cell8")
        let filteredList = activeList.filter {$0.activeEmail == AdminActiveViewController.adminActiveUser}
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell8")
        }
        
        let nr1time = filteredList[indexPath.row].timestamp
        let nr1Id = filteredList[indexPath.row].activeEmail
        let nr2time = "Date: "
        let nr2Id = "email: "
        let nr12 = "\(nr2time) \(nr1time!), \(nr2Id) \(nr1Id!)"
         
        cell?.textLabel?.text = filteredList[indexPath.row].activeName
        cell?.detailTextLabel?.text = nr12
        
        
        return cell!
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let filteredList = activeList.filter {$0.activeEmail == AdminActiveViewController.adminActiveUser}
        if let destination = segue.destination as? DetailAdminActiveViewController{
            destination.activeClass = filteredList[(adminActiveTableView.indexPathForSelectedRow?.row)!]
            adminActiveTableView.deselectRow(at: adminActiveTableView.indexPathForSelectedRow!, animated: true)
            DispatchQueue.main.async{
                self.adminActiveTableView.reloadData()
            }
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        //read from database on what to display on tableview
        activeCollectionRef.addSnapshotListener{QuerySnapshot, error in
            guard let snapshot = QuerySnapshot else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            //snapshot read from "active" in database
            snapshot.documentChanges.forEach {diff in
                if (diff.type == .added) {
                    
                    let data = diff.document.data()
                    
                    let activedesc = data["activeDesc"] as? String
                    let activeid = data["activeId"] as? String ?? "0000"
                    let activeemail = data["activeEmail"] as? String
                    let activename = data["activeName"] as? String
                    let activeBookingId = data["activeBookingId"] as? String
                    guard let stamp = data["timeStamp"] as? Timestamp else {
                         return
                     }
                    AdminActiveViewController.adminActiveDate = stamp.dateValue()
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "YY/MM/dd, HH:mm:ss"
                    let stringifyDate = dateFormatter.string(from: AdminActiveViewController.adminActiveDate!)
                    let stringed = String(stringifyDate)
                    
                    let newActive = active(activeDesc: activedesc, activeEmail: activeemail, activeId: activeid, activeName: activename, activeBookingId: activeBookingId, timestamp: stringed)

                    self.activeList.append(newActive)
                    }
             
                    self.adminActiveTableView.reloadData()
                DispatchQueue.main.async {
                    self.adminActiveTableView.reloadData()
                }
            }
        }
    }


}
