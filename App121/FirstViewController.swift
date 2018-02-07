//
//  FirstViewController.swift
//  App121
//
//  Created by ios on 2018/1/22.
//  Copyright © 2018年 pcschool.com. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

    @IBAction func gotocomment(_ sender: UIButton) {
       
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "chat1")
        self.present(vc!, animated: true) {
            
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

