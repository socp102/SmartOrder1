//
//  FoodViewController.swift
//  Menu
//
//  Created by Lu Kevin on 2018/11/18.
//  Copyright © 2018年 Lu Kevin. All rights reserved.
//

import UIKit

class FoodViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    var menuSelectedNumber:Int = 0
    @IBOutlet weak var foodTableView: UITableView!
    
    var hamburgerImages = ["BeefHamburger","ChickenHamburger","PorkHamburger"]
    var hamburgerName = ["牛肉漢堡","雞肉漢堡","豬肉漢堡"]
    var hamburgurPrice = ["70","80","90"]
    var hamburgurNumber = 0
    
    var spaghettiImages = ["TomatoSpaghetti","PestoSpaghetti","CarbonaraSpaghetti"]
    var spaghettiName = ["紅醬義大利麵","青醬義大利麵","白醬義大利麵"]
    var spaghettiPrice = ["70","80","90"]
    var spaghettiNumber = 0

    
    var pizzaImages = ["CheesePizza","TomatoPizza","OlivaPizza"]
    var pizzaName = ["起司披薩","番茄披薩","橄欖披薩"]
    var pizzaPrice = ["70","80","90"]
    var pizzaNumber = 0

    
    var steakImages = ["FiletMigon","RibeyeSteak","GrilledSteak"]
    var steakName = ["牛菲力","牛肋排","炙燒牛排"]
    var steakPrice = ["70","80","90"]
    var steakNumber = 0

    
    var dessertImages = ["Macaron","ChocolateCake","Sundae"]
    var dessertName = ["馬卡龍","巧克力蛋糕","聖代"]
    var dessertPrice = ["70","80","90"]
    var dessertNumber = 0

    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "FoodCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! FoodTableViewCell
        
        switch menuSelectedNumber {
            
        case 0:
            cell.foodNmae?.text = hamburgerName[indexPath.row]
            cell.foodImage?.image = UIImage(named: hamburgerImages[indexPath.row])
            cell.foodPrice?.text = hamburgurPrice[indexPath.row]
            
        case 1:
            cell.foodNmae?.text = spaghettiName[indexPath.row]
            cell.foodImage?.image = UIImage(named: spaghettiImages[indexPath.row])
            cell.foodPrice?.text = spaghettiPrice[indexPath.row]
            
            
        case 2:
            cell.foodNmae?.text = pizzaName[indexPath.row]
            cell.foodImage?.image = UIImage(named: pizzaImages[indexPath.row])
            cell.foodPrice?.text = pizzaPrice[indexPath.row]
            
        case 3:
            cell.foodNmae?.text = steakName[indexPath.row]
            cell.foodImage?.image = UIImage(named: steakImages[indexPath.row])
            cell.foodPrice?.text = steakPrice[indexPath.row]
            
        case 4:
            cell.foodNmae?.text = dessertName[indexPath.row]
            cell.foodImage?.image = UIImage(named: dessertImages[indexPath.row])
            cell.foodPrice?.text = dessertPrice[indexPath.row]
            
            
        default:
            break
        }
        
        return cell
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ShowFoodDetail"{
            
            if let indexPath = foodTableView.indexPathForSelectedRow {
                
                let detailController = segue.destination as! DetailTableViewController
                
                switch menuSelectedNumber {
                    
                case 0:
                    
                    detailController.detailImageNumber = indexPath.row
                    detailController.menuSelectedNumber = 0
                    
                case 1:
                    
                    detailController.detailImageNumber = indexPath.row
                    detailController.menuSelectedNumber = 1

                case 2:
                    
                    detailController.detailImageNumber = indexPath.row
                    detailController.menuSelectedNumber = 2

                case 3:
                    
                    detailController.detailImageNumber = indexPath.row
                    detailController.menuSelectedNumber = 3
                    
                case 4:
                    
                    detailController.detailImageNumber = indexPath.row
                    detailController.menuSelectedNumber = 4

                    
                default:
                    break
                }
                
                
                
            }
        }
    }
    
}
