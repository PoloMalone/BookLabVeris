//
//  MenuViewController.swift
//  bookLab
//
//  Created by Josef Jakobsson on 2021-09-14.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseAnalytics
import FirebaseFirestore
import FirebaseFirestoreSwift


class MenuViewController: UIViewController {

    @IBOutlet weak var LogoutTapped: UIButton!
    
    
    
   
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        // Do any additional setup after loading the view.
    }
    

    

    
    
    
    //func when logout button is tapped
    @IBAction func LogoutTapped(_ sender: Any) {
        
        let firebaseAuth = Auth.auth()
    do {
      try firebaseAuth.signOut()
    } catch let signOutError as NSError {
      print("Error signing out: %@", signOutError)
        
    }
      
        self.gotoStartScreen()
                
    }
        
    
    
//func to go back to start screen (before login)
func gotoStartScreen() {
    

    let startViewController = storyboard?.instantiateViewController(identifier:
        Constants.Story.startViewController) as? ViewController

    view.window?.rootViewController = startViewController
    view.window?.makeKeyAndVisible()

}

}
