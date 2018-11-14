//
//  AddDrinkViewController.swift
//  Food Diary
//
//  Created by Victor on 11/8/18.
//  Copyright © 2018 Victor. All rights reserved.
//

import UIKit

class AddDrinkViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}



// MARK: - Create table
extension AddDrinkViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let q = (tableView.dequeueReusableCell(withIdentifier: "quantity") as? CustomCell)
            return q!
        }
        let cell = (tableView.dequeueReusableCell(withIdentifier: "cell") as? CustomCell)
        return cell!
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
}



class CustomCell: UITableViewCell {
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var ingredients: UILabel!
}









