//
//  AllActiveViewController.swift
//  bookLab
//
//  Created by Josef Jakobsson on 2021-10-14.
//

import UIKit
import Firebase
import FirebaseAnalytics
import FirebaseFirestore
import FirebaseFirestoreSwift


class AllActiveViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var allActiveTableView: UITableView!
    //initialize list and collectionref
    var activeList = [active]()
    var activeCollectionRef: CollectionReference!
    
    static var allActiveDate: Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        allActiveTableView.delegate = self
        allActiveTableView.dataSource = self
        
        activeCollectionRef = Firestore.firestore().collection("active")
       
    }
    
    
    func tableView(_ allActiveTableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "showDetailAllActive", sender: self)
        
    }
    
    func tableView(_ allActiveTableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activeList.count
    }
    
    func tableView(_ allActiveTableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = allActiveTableView.dequeueReusableCell(withIdentifier: "cell7")
        
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell7")
        }
        
        let nr1time = activeList[indexPath.row].timestamp
        let nr1Id = activeList[indexPath.row].activeEmail
        let nr2time = "Date: "
        let nr2Id = "email: "
        let nr12 = "\(nr2time) \(nr1time!), \(nr2Id) \(nr1Id!)"
         
        cell?.textLabel?.text = activeList[indexPath.row].activeName
        cell?.detailTextLabel?.text = nr12
        
        
        return cell!
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? DetailAllActiveViewController{
            destination.activeClass = activeList[(allActiveTableView.indexPathForSelectedRow?.row)!]
            allActiveTableView.deselectRow(at: allActiveTableView.indexPathForSelectedRow!, animated: true)
            DispatchQueue.main.async{
                self.allActiveTableView.reloadData()
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
                    AllActiveViewController.allActiveDate = stamp.dateValue()
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "YY/MM/dd, HH:mm:ss"
                    let stringifyDate = dateFormatter.string(from: AllActiveViewController.allActiveDate!)
                    let stringed = String(stringifyDate)
                    
                    let newActive = active(activeDesc: activedesc, activeEmail: activeemail, activeId: activeid, activeName: activename, activeBookingId: activeBookingId, timestamp: stringed)

                    self.activeList.append(newActive)
                    }
             
                    self.allActiveTableView.reloadData()
                DispatchQueue.main.async {
                    self.allActiveTableView.reloadData()
                }
            }
        }
    }



}
