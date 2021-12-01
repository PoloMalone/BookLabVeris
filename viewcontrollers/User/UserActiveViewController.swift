//
//  UserActiveViewController.swift
//  bookLab
//
//  Created by Josef Jakobsson on 2021-10-16.
//

import UIKit
import Firebase
import FirebaseAnalytics
import FirebaseFirestore
import FirebaseFirestoreSwift


class UserActiveViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var userActiveTableView: UITableView!
    
    //variables / lists
    var activeList = [active]()
    var activeCollectionRef: CollectionReference!
    
    static var userActiveDate: Date?
    static var userActiveUser: String?
    

    override func viewDidLoad() {
        super.viewDidLoad()

        let user = Auth.auth().currentUser
        if let user = user {
            let name = user.email
            UserActiveViewController.userActiveUser = name!
        }
        
        userActiveTableView.delegate = self
        userActiveTableView.dataSource = self
        
        activeCollectionRef = Firestore.firestore().collection("active")
    }
    
    func tableView(_ userActiveTableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
       performSegue(withIdentifier: "showDetailUserActive", sender: self)
        
    }
    
    func tableView(_ userActiveTableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let filteredList = activeList.filter {$0.activeEmail == UserActiveViewController.userActiveUser}
        return filteredList.count
    }
    
    func tableView(_ userActiveTableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = userActiveTableView.dequeueReusableCell(withIdentifier: "cell10")
        let filteredList = activeList.filter {$0.activeEmail == UserActiveViewController.userActiveUser}
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell10")
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
        let filteredList = activeList.filter {$0.activeEmail == UserActiveViewController.userActiveUser}
        if let destination = segue.destination as? DetailUserActiveViewController{
            destination.activeClass = filteredList[(userActiveTableView.indexPathForSelectedRow?.row)!]
            userActiveTableView.deselectRow(at: userActiveTableView.indexPathForSelectedRow!, animated: true)
            DispatchQueue.main.async{
                self.userActiveTableView.reloadData()
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
                    UserActiveViewController.userActiveDate = stamp.dateValue()
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "YY/MM/dd, HH:mm:ss"
                    let stringifyDate = dateFormatter.string(from: UserActiveViewController.userActiveDate!)
                    let stringed = String(stringifyDate)
                    
                    let newActive = active(activeDesc: activedesc, activeEmail: activeemail, activeId: activeid, activeName: activename, activeBookingId: activeBookingId, timestamp: stringed)

                    self.activeList.append(newActive)
                    }
             
                    self.userActiveTableView.reloadData()
                DispatchQueue.main.async {
                    self.userActiveTableView.reloadData()
                }
            }
        }
    }




}
