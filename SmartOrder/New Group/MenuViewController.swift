//
//  MenuViewController.swift
//  Menu
//
//  Created by Lu Kevin on 2018/11/18.
//  Copyright © 2018年 Lu Kevin. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController ,UITableViewDataSource,UITableViewDelegate{
    var menu = ["漢堡","義大利麵","披薩","牛排","甜點"]
    var menuImages = ["Hamburger","Spaghetti","Pizza","Steak","Dessert"]

    @IBOutlet weak var menuTableView: UITableView!
   
    @IBAction func unwindSegueToMenu(segue:UIStoryboardSegue) {
    }
    
    @IBOutlet weak var showBillBtn: UIBarButtonItem!
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menu.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "MenuCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! MenuTableViewCell
        cell.menuName?.text = menu[indexPath.row]
        cell.menuImage?.image = UIImage(named: menuImages[indexPath.row])
        return cell
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ShowFood"{
        
        let foodController = segue.destination as? FoodViewController
            
            if let row = menuTableView.indexPathForSelectedRow?.row {
                
                switch row {
                
                case 0 :
                    foodController?.menuSelectedNumber = 0
                    foodController?.navigationItem.title = "漢堡"
                    break
                
                case 1 :
                    foodController?.menuSelectedNumber = 1
                    foodController?.navigationItem.title = "義大利麵"

                    break
                
                case 2:
                    foodController?.menuSelectedNumber = 2
                    foodController?.navigationItem.title = "披薩"

                    break
                
                case 3:
                    foodController?.menuSelectedNumber = 3
                    foodController?.navigationItem.title = "牛排"

                    break
                    
                case 4:
                    foodController?.menuSelectedNumber = 4
                    foodController?.navigationItem.title = "甜點"

                    break
                    
                default:
                    break
                }
            }
        }
    }
}
