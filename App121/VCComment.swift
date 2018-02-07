//
//  VCComment.swift
//  App121
//
//  Created by ios on 2018/1/26.
//  Copyright © 2018年 pcschool.com. All rights reserved.
//

import UIKit

class VCComentCustomCell:UITableViewCell{
    @IBOutlet weak var imgViewCustomer: UIImageView!
    
    @IBOutlet weak var imgViewProduct: UIImageView!
    
    @IBOutlet weak var customerID: UILabel!
    
    @IBOutlet weak var customerMessage: UILabel!
}




class VCComment: UIViewController,UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        return cell!
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func dismisscomment(_ sender: UIButton) {
        
        self.dismiss(animated: true) {
            
        }
        
//        self.dismiss(animated: true, completion: )
        
    }
    @IBAction func popbtn(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated:true)
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
