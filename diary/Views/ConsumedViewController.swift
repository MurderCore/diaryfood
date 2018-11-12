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
    
    var bar: TabBarController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bar = (navigationController?.viewControllers[0] as! TabBarController)
        
        barTitle.title = bar?.viewModels.root.getCurrentDate()
    }
}

// MARK: - Create table
extension ConsumedViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        return cell!
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
}
