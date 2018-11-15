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
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return ["Meals", "Drinks"]
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (vm?.getRowsNumb(forSection: section, date: barTitle.title!))!
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        return cell!
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let id = tableView.cellForRow(at: indexPath)?.restorationIdentifier
            // DELETE A FOOD $$$$$$$$$
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
