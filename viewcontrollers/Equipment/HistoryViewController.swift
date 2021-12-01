//
//  HistoryViewController.swift
//  bookLab
//
//  Created by Josef Jakobsson on 2021-10-12.
//

import UIKit
import Firebase
import FirebaseAnalytics
import FirebaseFirestore
import FirebaseFirestoreSwift

class HistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    
    
    
    @IBOutlet weak var historyTableView: UITableView!
    
    @IBOutlet weak var searchBarHistory: UISearchBar!
    
    //initialize lists and collectionrefs
    var historyList = [history]()
    var currentHistoryList = [history]()
    var historyCollectionRef: CollectionReference!
  
    static var historyDate: Date?
    
    func tableView(_ historyTableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "showDetailHistoryTableView", sender: self)
      
    }
    
    func tableView(_ historyTableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentHistoryList.count
    }
    
    func tableView(_ historyTableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = historyTableView.dequeueReusableCell(withIdentifier: "cell6")
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell6")
        }
        
        let nr1 = currentHistoryList[indexPath.row].historyEmail
        let nr2 = "user:"
        let nr3 = currentHistoryList[indexPath.row].timestamp
        let nr4 = "Timestamp:"
        let nr12 = "\(nr2) \(nr1!),   \(nr4) \(nr3!)"
        
        cell?.textLabel?.text = currentHistoryList[indexPath.row].historyAction
        cell?.detailTextLabel?.text = nr12
        
        
        return cell!
    }

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async {
            self.historyTableView.reloadData()
        }
        historyTableView.delegate = self
        historyTableView.dataSource = self
        searchBarHistory.delegate = self
        //collectionref value = from database
        historyCollectionRef = Firestore.firestore().collection("history")
 
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? DetailHistoryViewController{
            destination.histo = currentHistoryList[(historyTableView.indexPathForSelectedRow?.row)!]
            historyTableView.deselectRow(at: historyTableView.indexPathForSelectedRow!, animated: true)
            DispatchQueue.main.async{
                self.historyTableView.reloadData()
            }
        }
    }
     

    override func viewWillAppear(_ animated: Bool) {
        //read from database on what to display on tableview
        historyCollectionRef.addSnapshotListener{QuerySnapshot, error in
            guard let snapshot = QuerySnapshot else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            //read with snapshot to get updated values
            snapshot.documentChanges.forEach {diff in
                if (diff.type == .added) {
                    
                    let data = diff.document.data()
                    
                    let historyName = data["historyName"] as? String
                    let historyId = data["historyId"] as? String ?? "0000"
                    let historyEmail = data["historyEmail"] as? String
                    let historyAction = data["historyAction"] as? String ?? "1"
                    guard let stamp = data["timeStamp"] as? Timestamp else {
                         return
                     }
                    HistoryViewController.historyDate = stamp.dateValue()
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "YY/MM/dd, HH:mm:ss"
                    let stringifyDate = dateFormatter.string(from: HistoryViewController.historyDate!)
                    let stringed = String(stringifyDate)
                    
                    let newHist = history(historyEmail: historyEmail, historyId: historyId, historyName: historyName, timestamp: stringed, historyAction: historyAction)

                    self.historyList.append(newHist)
                    }
                    self.currentHistoryList = self.historyList
                    print("View will appear")
       
                    
                    self.historyTableView.reloadData()
                }
                DispatchQueue.main.async {
                    self.historyTableView.reloadData()
                }
            }
        }
    //import searchbar to history page
    func searchBar(_ searchBarHistory: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {
            currentHistoryList = historyList;
            historyTableView.reloadData()
            return
            
        }
        currentHistoryList = historyList.filter({ history -> Bool in
            (history.historyEmail?.lowercased().contains(searchText.lowercased()))!
            || (history.historyName?.lowercased().contains(searchText.lowercased()))!
            || (history.historyAction?.lowercased().contains(searchText.lowercased()))!
            || (history.historyId?.lowercased().contains(searchText.lowercased()))!
            || (history.timestamp?.lowercased().contains(searchText.lowercased()))!
        })
    

    
        historyTableView.reloadData()
    }
    
}
