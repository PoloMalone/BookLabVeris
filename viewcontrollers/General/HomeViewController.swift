//
//  HomeViewController.swift
//  bookLab
//
//  Created by Josef Jakobsson on 2021-09-02.
//

import UIKit
import Firebase
import FirebaseAnalytics
import FirebaseFirestore
import FirebaseFirestoreSwift


class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var tableView: UITableView!
    //initialize list of items and collectionref
    var itemsList = [items]()
    var itemsCollectionRef: CollectionReference!
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "showuserdetail", sender: self)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell2")
        
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell2")
        }
        
        let nr1 = itemsList[indexPath.row].quant
        let nr2 = "Quantity: "
        let nr12 = "\(nr2) \(nr1!)"
        
        cell?.textLabel?.text = itemsList[indexPath.row].name
        cell?.detailTextLabel?.text = nr12
        
        return cell!
    }

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //what to show on phone
        tableView.delegate = self
        tableView.dataSource = self
        
        itemsCollectionRef = Firestore.firestore().collection("items")

        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? UserDetailViewController{
            destination.item = itemsList[(tableView.indexPathForSelectedRow?.row)!]
            tableView.deselectRow(at: tableView.indexPathForSelectedRow!, animated: true)
            DispatchQueue.main.async{
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //what to show on phone (tableview) from item in database
        itemsCollectionRef.addSnapshotListener{QuerySnapshot, error in
            guard let snapshot = QuerySnapshot else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            snapshot.documentChanges.forEach {diff in
                if (diff.type == .added) {
                    
                    let data = diff.document.data()
                    
                    let name = data["itemName"] as? String
                    let id = data["itemId"] as? String ?? "0000"
                    let desc = data["description"] as? String
                    let quant = data["quantity"] as? String ?? "1"
                    
                    let newitem = items(id: id, name: name, desc: desc, quant: quant)
                    self.itemsList.append(newitem)
                
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
     
    }
     
    
    



    
    

}
