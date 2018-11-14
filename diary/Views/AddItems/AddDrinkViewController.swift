//
//  AddDrinkViewController.swift
//  Food Diary
//
//  Created by Victor on 11/8/18.
//  Copyright © 2018 Victor. All rights reserved.
//

import UIKit

class AddDrinkViewController: UITableViewController {
    
    var vm: AddDrinkViewModel?
    var drinksVM: DrinksViewModel?
    
    var lastSelected = 1
    
    var infoCell: InfoCell?

    @IBOutlet weak var btnDone: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnDone.isEnabled = false
        drinksVM = (navigationController?.viewControllers[0] as! TabBarController).viewModels.drinks
        vm = (navigationController?.viewControllers[0] as! TabBarController).viewModels.addDrink
    }
    
    // MARK: - Button controller
    @IBAction func btnDoneClicked(_ sender: Any) {
        let id = tableView.cellForRow(at: IndexPath(row: lastSelected, section: 0))?.restorationIdentifier
        
        let q = (infoCell?.info.text)!
        if (q == "") {
            self.present((vm?.getAlert(message: "Missing quantity"))!, animated: true, completion: nil)
            return
        }
        
        vm?.addConsumedMeal(id: Int(id!)!, quantity: Int((infoCell?.info.text!)!)!)
        navigationController?.popViewController(animated: true)
    }
}



// MARK: - Create table
extension AddDrinkViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (drinksVM?.getRowsCount())! + 1
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        btnDone.isEnabled = true
        if indexPath.row == 0 {
            return
        }
        tableView.cellForRow(at: IndexPath(row: lastSelected, section: 0))?.accessoryType = UITableViewCellAccessoryType.none
        tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCellAccessoryType.checkmark
        lastSelected = indexPath.row
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let q = (tableView.dequeueReusableCell(withIdentifier: "quantity") as? InfoCell)
            infoCell = q
            return q!
        }
        var cell = (tableView.dequeueReusableCell(withIdentifier: "cell") as? CustomCell)
        cell = drinksVM?.getCell(byIndex: indexPath.row-1, cell: cell!)
        return cell!
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
}









