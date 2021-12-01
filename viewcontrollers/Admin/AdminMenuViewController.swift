//
//  AdminMenuViewController.swift
//  bookLab
//
//  Created by Josef Jakobsson on 2021-09-17.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseAnalytics
import FirebaseFirestore
import FirebaseFirestoreSwift


class AdminMenuViewController: UIViewController {

    @IBOutlet weak var SignoutTapped: UIButton!
    //what to show on phone
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
//func when signout button is tapped
    @IBAction func SignoutTapped(_ sender: Any) {
        //check what user
        let firebaseAuth = Auth.auth()
    do {
        //signout user
      try firebaseAuth.signOut()
    } catch let signOutError as NSError {
      print("Error signing out: %@", signOutError)
        
    }
      //go back to start screen before login page
        self.gotoStartScreen()
        
    }
    
    //go back to start
    func gotoStartScreen() {
        

        let startViewController = storyboard?.instantiateViewController(identifier:
            Constants.Story.startViewController) as? ViewController

        view.window?.rootViewController = startViewController
        view.window?.makeKeyAndVisible()

    }

}
