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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        vm = (navigationController?.viewControllers[0] as! TabBarController).viewModels.consumed
        barTitle.title = (navigationController?.viewControllers[0] as! TabBarController).viewModels.root.getCurrentDate()
    }
}

// MARK: - Create table
extension ConsumedViewController {
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return (section == 0) ? "Meals" : "Drinks"
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (vm?.getRowsNumb(forSection: section, date: barTitle.title!))!
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell = vm?.getCell(date: barTitle.title!, byIndex: indexPath.row, cell: cell as! CustomCell, section: indexPath.section)
        return cell!
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let id = tableView.cellForRow(at: indexPath)?.restorationIdentifier
            let date = barTitle.title!
            let type = (indexPath.section == 0) ? "MealConsumed" : "DrinkConsumed"
            
            vm?.deleteFoodFromDate(date: date, type: type, id: id!)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
