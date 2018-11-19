//
//  HistoryViewController.swift
//  diary
//
//  Created by Victor on 11/12/18.
//  Copyright © 2018 Victor. All rights reserved.
//

import UIKit

class HistoryViewController: UITableViewController {

    var vm: HistoryViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        vm = (navigationController?.viewControllers[0] as! TabBarController).viewModels.history
    }
}


// MARK: - Create table

extension HistoryViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (vm?.getNumberOfRows())!
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.textLabel?.text = vm?.getCellDate(byIndex: indexPath.row)
        return cell!
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let id = tableView.cellForRow(at: indexPath)?.restorationIdentifier
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
