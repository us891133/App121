//
//  VCapp121Firebase.swift
//  App121
//
//  Created by ios on 2018/1/31.
//  Copyright © 2018年 pcschool.com. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class VCapp121Firebase: UIViewController {
  
    var handle: AuthStateDidChangeListenerHandle?
    
    var ref: DatabaseReference!
    
    
    @IBAction func singupemail(_ sender: UIButton) {
        print("singupemail")
        Auth.auth().createUser(withEmail: "abbb@gmail.ccc", password: "password") { (user, error) in
            // ...
        }
        Auth.auth().signIn(withEmail: "abbb@gmail.ccc", password: "password") { (user, error) in
            // ...
            
            self.ref.child("users").child((user?.uid)!).setValue(["username1": "11111"])
            self.ref.child("users").child((user?.uid)!).setValue(["username3": "33333"])
            
            self.ref.child("users/\(user?.uid)/username").setValue("aaaa")
            self.ref.child("users/\(user?.uid)/username").setValue("bbb")
            self.ref.child("users/\(user?.uid)/username2").setValue("ccc")
            self.ref.child("messages/\(user?.uid)/username4").setValue("m")
            
        }

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
