//
//  Consumed.swift
//  diary
//
//  Created by Victor on 11/12/18.
//  Copyright © 2018 Victor. All rights reserved.
//

import UIKit

class ConsumedViewController: UITableViewController {

    @IBOutlet weak var barTitle: UINavigationItem!
    var vm: ConsumedViewModel?
    
    var drinksCount = 0
    var mealsCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        vm = (navigationController?.viewControllers[0] as! TabBarController).viewModels.consumed
        barTitle.title = (navigationController?.viewControllers[0] as! TabBarController).viewModels.root.getCurrentDate()
    }
}

// MARK: - Create table
extension ConsumedViewController {
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            if mealsCount == 0 {
                return nil
            }
            return "Meals"
        } else {
            if drinksCount == 0 {
                return nil
            }
            return "Drinks"
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        drinksCount = (vm?.getRowsNumb(forSection: 1, date: barTitle.title!))!
        mealsCount = (vm?.getRowsNumb(forSection: 0, date: barTitle.title!))!
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return mealsCount
        }
        return drinksCount
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell = vm?.getCell(date: barTitle.title!, byIndex: indexPath.row, cell: cell as! CustomCell, section: indexPath.section)
        return cell!
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        vm?.updateFoods(date: barTitle.title!)
        tableView.tableFooterView = UIView()
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let id = tableView.cellForRow(at: indexPath)?.restorationIdentifier
            let date = barTitle.title!
            let type = (indexPath.section == 0) ? "MealConsumed" : "DrinkConsumed"
                    
            vm?.deleteFoodFromDate(date: date, type: type, id: id!)
            
            if !(vm?.existFood(atDate: date))! {
                navigationController?.popViewController(animated: true)
            }
            
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.reloadData()
        }
    }
}




