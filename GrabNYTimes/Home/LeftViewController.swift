//
//  LeftViewController.swift
//  GrabNYTimes
//
//  Created by Jitesh Sharma on 04/10/18.
//  Copyright © 2018 Jitesh Sharma. All rights reserved.
//

import UIKit


class LeftViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet var leftView: UIView!
    
    var menuArray = Array<Any>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        leftView.backgroundColor = navBarTintColor
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuItemCell")!
        cell.selectionStyle = .none
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "Home"
            break
        
        default:
            cell.textLabel?.text = ""
        }
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
    
}
