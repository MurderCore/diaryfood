//
//  DrinksViewController.swift
//  diary
//
//  Created by Victor on 11/12/18.
//  Copyright © 2018 Victor. All rights reserved.
//

import UIKit

class DrinksViewController: UITableViewController {

    var vm: DrinksViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        vm = (navigationController?.viewControllers[0] as! TabBarController).viewModels.drinks
    }
}


// MARK: - Create table
extension DrinksViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (vm?.getRowsCount())!
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = (tableView.dequeueReusableCell(withIdentifier: "cell") as? CustomCell)
        cell = vm?.getCell(byIndex: indexPath.row, cell: cell!)
        return cell!
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let id = tableView.cellForRow(at: indexPath)?.restorationIdentifier
            vm?.remove(atId: Int(id!)!)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
