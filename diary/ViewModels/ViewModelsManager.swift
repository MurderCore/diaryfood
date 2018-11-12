//
//  File.swift
//  diary
//
//  Created by Victor on 11/12/18.
//  Copyright © 2018 Victor. All rights reserved.
//

import Foundation

class ViewModels {
    
    var db: FoodManager()
    
    var root = RootViewModel()
    var meals = MealsViewModel(foodManager: db)
}

