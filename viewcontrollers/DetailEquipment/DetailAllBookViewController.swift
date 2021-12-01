//
//  DetailAllBookViewController.swift
//  bookLab
//
//  Created by Josef Jakobsson on 2021-10-13.
//

import UIKit
import Firebase
import FirebaseAnalytics
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth

class DetailAllBookViewController: UIViewController {
    
    
    @IBOutlet weak var bookNameLabel: UILabel!
    
    
    @IBOutlet weak var bookDescTextView: UITextView!
    
    @IBOutlet weak var bookEmailLabel: UILabel!
    
    @IBOutlet weak var bookIdLabel: UILabel!
    
    @IBOutlet weak var bookTimeLabel: UILabel!
    var bookedList = [booked]()
    var bookedCollectionRef: CollectionReference!
    var book: booked?
    
    override func viewDidLoad() {
        super.viewDidLoad()
//what to show on phone
        bookNameLabel.text = "\((book?.bookName)!)"
        bookEmailLabel.text = "\((book?.bookEmail)!)"
        bookDescTextView.text = "\((book?.bookDesc)!)"
        bookTimeLabel.text = "\((book?.timestamp)!)"
        bookIdLabel.text = "\((book?.bookId)!)"
        
    }
    



}
