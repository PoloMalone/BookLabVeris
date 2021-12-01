//
//  DetailAllActiveViewController.swift
//  bookLab
//
//  Created by Josef Jakobsson on 2021-10-14.
//

import UIKit
import Firebase
import FirebaseAnalytics
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth


class DetailAllActiveViewController: UIViewController {

    
    @IBOutlet weak var activeNameLabel: UILabel!
    
    @IBOutlet weak var activeDescLabel: UITextView!
    
    @IBOutlet weak var activeEmailLabel: UILabel!
    
    @IBOutlet weak var activeTimeLabel: UILabel!
    
    @IBOutlet weak var activeIdLabel: UILabel!
    
    var activeList = [active]()
    var activeCollectionRef: CollectionReference!
    var activeClass: active?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //what to show on phone
        activeNameLabel.text = "\((activeClass?.activeName)!)"
        activeEmailLabel.text = "\((activeClass?.activeEmail)!)"
        activeDescLabel.text = "\((activeClass?.activeDesc)!)"
        activeTimeLabel.text = "\((activeClass?.timestamp)!)"
        activeIdLabel.text = "\((activeClass?.activeId)!)"
    }
    

}
