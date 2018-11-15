//
//  ConsumedViewModel.swift
//  diary
//
//  Created by Victor on 11/14/18.
//  Copyright © 2018 Victor. All rights reserved.
//

import UIKit

class ConsumedViewModel {
    
    var db: FoodManager?
    
    init(db: FoodManager) {
        self.db = db
    }
    
    func getRowsNumb(forSection id: Int, date: String) -> Int {
        let type = (id == 0) ? "meals" : "drinks"
        db?.getFood(byDate: date, type: type)
        return 1
    }
}
