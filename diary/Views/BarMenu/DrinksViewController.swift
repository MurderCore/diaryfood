//
//  DrinksViewController.swift
//  diary
//
//  Created by Victor on 11/12/18.
//  Copyright © 2018 Victor. All rights reserved.
//

import UIKit

class DrinksViewController: UITableViewController {

    var bar: TabBarController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bar = (navigationController?.viewControllers[0] as! TabBarController)
    }
}


// MARK: - Create table
extension DrinksViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (bar?.viewModels.drinks?.getRowsCount())!
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = (tableView.dequeueReusableCell(withIdentifier: "cell") as? CustomCell)
        return cell!
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
}
