//
//  DetailTableViewController.swift
//  SmartOrder
//
//  Created by Lu Kevin on 2018/11/19.
//  Copyright © 2018年 Eason. All rights reserved.
//

import UIKit


class DetailTableViewController: UITableViewController {

    @IBOutlet weak var detailPrice: UILabel!
    @IBOutlet weak var detailImage: UIImageView!
    var menuSelectedNumber = 0
    var detailImageNumber = 0
    var currentPrice = ""
    
    
    var hamburgerImages = ["BeefHamburger","ChickenHamburger","PorkHamburger"]
    var hamburgerName = ["牛肉漢堡","雞肉漢堡","豬肉漢堡"]
    var hamburgerEngName = ["BeefHamburger","ChickenHamburger","PorkHamburger"]
    var hamburgurPrice = ["70","80","90"]
    
    var spaghettiImages = ["TomatoSpaghetti","PestoSpaghetti","CarbonaraSpaghetti"]
    var spaghettiName = ["紅醬義大利麵","青醬義大利麵","白醬義大利麵"]
    var spaghettiEngName = ["TomatoSpaghetti","PestoSpaghetti","CarbonaraSpaghetti"]
    var spaghettiPrice = ["70","80","90"]
    
    
    var pizzaImages = ["CheesePizza","TomatoPizza","OlivaPizza"]
    var pizzaName = ["起司披薩","番茄披薩","橄欖披薩"]
    var pizzaEngName = ["CheesePizza","TomatoPizza","OlivaPizza"]
    var pizzaPrice = ["70","80","90"]
    
    
    var steakImages = ["FiletMigon","RibeyeSteak","GrilledSteak"]
    var steakName = ["牛菲力","牛肋排","炙燒牛排"]
    var steakEngName = ["FiletMigon","RibeyeSteak","GrilledSteak"]
    var steakPrice = ["70","80","90"]
    
    
    var dessertImages = ["Macaron","ChocolateCake","Sundae"]
    var dessertName = ["馬卡龍","巧克力蛋糕","聖代"]
    var dessertEngName = ["Macaron","ChocolateCake","Sundae"]
    var dessertPrice = ["70","80","90"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        switch menuSelectedNumber {
            
        case 0:
            
            switch detailImageNumber{
                
            case 0:
                detailImage.image = UIImage(named: hamburgerImages[detailImageNumber])
                detailPrice.text? = hamburgurPrice[detailImageNumber]
                currentPrice = hamburgurPrice[detailImageNumber]
                resultItem = hamburgerEngName[detailImageNumber]
                resultPrice = hamburgurPrice[detailImageNumber]
                navigationItem.title = "牛肉漢堡"
                
                
            case 1:
                detailImage.image = UIImage(named: hamburgerImages[detailImageNumber])
                detailPrice.text? = hamburgurPrice[detailImageNumber]
                currentPrice = hamburgurPrice[detailImageNumber]
                resultItem = hamburgerEngName[detailImageNumber]
                resultPrice = hamburgurPrice[detailImageNumber]
                navigationItem.title = "雞肉漢堡"



            case 2:
                detailImage.image = UIImage(named: hamburgerImages[detailImageNumber])
                detailPrice.text? = hamburgurPrice[detailImageNumber]
                currentPrice = hamburgurPrice[detailImageNumber]
                resultItem = hamburgerEngName[detailImageNumber]
                resultPrice = hamburgurPrice[detailImageNumber]
                navigationItem.title = "豬肉漢堡"


            default:
                break
            }
            
            
        case 1:
            
            switch detailImageNumber{
                
            case 0:
                detailImage.image = UIImage(named: spaghettiImages[detailImageNumber])
                detailPrice.text? = spaghettiPrice[detailImageNumber]
                currentPrice = spaghettiPrice[detailImageNumber]
                resultItem = spaghettiEngName[detailImageNumber]
                resultPrice = spaghettiPrice[detailImageNumber]
                navigationItem.title = "紅醬義大利麵"



            case 1:
                detailImage.image = UIImage(named: spaghettiImages[detailImageNumber])
                detailPrice.text? = spaghettiPrice[detailImageNumber]
                currentPrice = spaghettiPrice[detailImageNumber]
                resultItem = spaghettiEngName[detailImageNumber]
                resultPrice = spaghettiPrice[detailImageNumber]
                navigationItem.title = "青醬義大利麵"




            case 2:
                detailImage.image = UIImage(named: spaghettiImages[detailImageNumber])
                detailPrice.text? = spaghettiPrice[detailImageNumber]
                currentPrice = spaghettiPrice[detailImageNumber]
                resultItem = spaghettiEngName[detailImageNumber]
                resultPrice = spaghettiPrice[detailImageNumber]
                navigationItem.title = "白醬義大利麵"



            default:
                break
            }
        
        case 2:
            
            switch detailImageNumber{
                
            case 0:
                detailImage.image = UIImage(named: pizzaImages[detailImageNumber])
                detailPrice.text? = pizzaPrice[detailImageNumber]
                currentPrice = pizzaPrice[detailImageNumber]
                resultItem = pizzaEngName[detailImageNumber]
                resultPrice = pizzaPrice[detailImageNumber]
                navigationItem.title = "起司披薩"



            case 1:
                detailImage.image = UIImage(named: pizzaImages[detailImageNumber])
                detailPrice.text? = pizzaPrice[detailImageNumber]
                currentPrice = pizzaPrice[detailImageNumber]
                resultItem = pizzaEngName[detailImageNumber]
                resultPrice = pizzaPrice[detailImageNumber]
                navigationItem.title = "番茄披薩"


                
            case 2:
                detailImage.image = UIImage(named: pizzaImages[detailImageNumber])
                detailPrice.text? = pizzaPrice[detailImageNumber]
                currentPrice = pizzaPrice[detailImageNumber]
                resultItem = pizzaEngName[detailImageNumber]
                resultPrice = pizzaPrice[detailImageNumber]
                navigationItem.title = "橄欖披薩"



            default:
                break
            }
            
        case 3:
            
            switch detailImageNumber{
                
            case 0:
                detailImage.image = UIImage(named: steakImages[detailImageNumber])
                detailPrice.text? = steakPrice[detailImageNumber]
                currentPrice = steakPrice[detailImageNumber]
                resultItem = steakEngName[detailImageNumber]
                resultPrice = steakPrice[detailImageNumber]
                navigationItem.title = "牛菲力"



            case 1:
                detailImage.image = UIImage(named: steakImages[detailImageNumber])
                detailPrice.text? = steakPrice[detailImageNumber]
                currentPrice = steakPrice[detailImageNumber]
                resultItem = steakEngName[detailImageNumber]
                resultPrice = steakPrice[detailImageNumber]
                navigationItem.title = "牛肋排"




            case 2:
                detailImage.image = UIImage(named: steakImages[detailImageNumber])
                detailPrice.text? = steakPrice[detailImageNumber]
                currentPrice = steakPrice[detailImageNumber]
                resultItem = steakEngName[detailImageNumber]
                resultPrice = steakPrice[detailImageNumber]
                navigationItem.title = "炙燒牛排"


                
            default:
                break
            }
            
        case 4:
            
            switch detailImageNumber{
                
            case 0:
                detailImage.image = UIImage(named: dessertImages[detailImageNumber])
                detailPrice.text? = dessertPrice[detailImageNumber]
                currentPrice = dessertPrice[detailImageNumber]
                resultItem = dessertEngName[detailImageNumber]
                resultPrice = dessertPrice[detailImageNumber]
                navigationItem.title = "馬卡龍"



            case 1:
                detailImage.image = UIImage(named: dessertImages[detailImageNumber])
                detailPrice.text? = dessertPrice[detailImageNumber]
                currentPrice = dessertPrice[detailImageNumber]
                resultItem = dessertEngName[detailImageNumber]
                resultPrice = dessertPrice[detailImageNumber]
                navigationItem.title = "巧克力蛋糕"



            case 2:
                detailImage.image = UIImage(named: dessertImages[detailImageNumber])
                detailPrice.text? = dessertPrice[detailImageNumber]
                currentPrice = dessertPrice[detailImageNumber]
                resultItem = dessertEngName[detailImageNumber]
                resultPrice = dessertPrice[detailImageNumber]
                navigationItem.title = "聖代"
                

            default:
                break
            }
        
            
        default:
            break
        }
    }
    
    @IBOutlet weak var stepperCount: UILabel!
    var resultPrice = ""
    var resultCount = "1"
    var resultItem = ""
    
    
    
    @IBAction func stepper(_ sender: UIStepper)  {
    
        let count = Int(sender.value)
        resultCount = String(count)
        
        stepperCount.text = String(count)
        
        let price = Int(currentPrice)!
        resultPrice = String(price * count)
        detailPrice?.text = resultPrice
    
    }
    
    
    var addDict =  [String: [String:String]]()
    let myUserDefaults = UserDefaults.standard
    
    @IBAction func addToOrder(_ sender: Any) {
        
        if myUserDefaults.value(forKey: "resultDict") != nil {
            
            addDict = myUserDefaults.value(forKey: "resultDict") as! [String : [String:String]]
            
        }
        
        addDict.updateValue(["count":resultCount,"subtotal":resultPrice,"notReady":resultCount], forKey: resultItem)
        myUserDefaults.setValue(addDict, forKey: "resultDict")
        
        }
    
    }


