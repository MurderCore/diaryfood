//
//  MealsViewModel.swift
//  diary
//
//  Created by Victor on 11/12/18.
//  Copyright © 2018 Victor. All rights reserved.
//

import UIKit

class MealsViewModel {
    
    var db: FoodManager?
    
    init(foodManager: FoodManager) {
        self.db = foodManager
    }
    
    func getRowsCount() -> Int {
        return (db?.fetchCount(type: "Meals"))!
    }
}
