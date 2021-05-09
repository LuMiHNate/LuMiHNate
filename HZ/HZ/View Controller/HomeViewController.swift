//
//  HomeViewController.swift
//  HZ
//
//  Created by Fate  on 5/7/21.
//

import UIKit
import Parse
import AlamofireImage


class HomeViewController: UIViewController, UITableViewDelegate {
    
    //,UITableViewDataSource
    
    @IBOutlet weak var tableView: UITableView!
    
    var posts = [PFObject]()
    var showsCommentBar = false
    var selectedPost:PFObject!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        //tableView.dataSource = self
        

        // Do any additional setup after loading the view.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return posts.count
    }
    
    
   // func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
   // }
    
   // func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
   // }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
