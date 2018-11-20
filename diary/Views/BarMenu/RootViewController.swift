//
//  RootViewController.swift
//  Food Diary
//
//  Created by Victor on 11/8/18.
//  Copyright © 2018 Victor. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {
    
    @IBOutlet weak var labelToday: UILabel!
    var bar: TabBarController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bar = (navigationController?.viewControllers[0] as! TabBarController)
        labelToday.text = bar?.viewModels.root.getCurrentDate()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

// MARK: - Create table
extension RootViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
}
