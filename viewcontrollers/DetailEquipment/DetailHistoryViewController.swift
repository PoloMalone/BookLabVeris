//
//  DetailHistoryViewController.swift
//  bookLab
//
//  Created by Josef Jakobsson on 2021-10-17.
//

import UIKit

class DetailHistoryViewController: UIViewController {

    
    @IBOutlet weak var actionLabel: UILabel!
    
    
    @IBOutlet weak var userLabel: UILabel!
    
    @IBOutlet weak var itemNameLabel: UILabel!
    
    @IBOutlet weak var timestampLabel: UILabel!
    
    @IBOutlet weak var itemIdLabel: UILabel!
    var histo: history?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //what to show on phone
        actionLabel.text = "\((histo?.historyAction)!)"
        userLabel.text = "\((histo?.historyEmail)!)"
        itemNameLabel.text = "\((histo?.historyName)!)"
        timestampLabel.text = "\((histo?.timestamp)!)"
        itemIdLabel.text = "\((histo?.historyId)!)"

     
    }
    
    
    
    


}
