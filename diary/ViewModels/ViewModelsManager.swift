//
//  File.swift
//  diary
//
//  Created by Victor on 11/12/18.
//  Copyright © 2018 Victor. All rights reserved.
//

import Foundation

class ViewModels {
    
    var db = FoodManager()
    
    var root = RootViewModel()
    var food: FoodViewModel?
    var createFood: CreateFoodViewModel?
    var history: HistoryViewModel?
    var addFood: AddFoodViewModel?
    var consumed: ConsumedViewModel?
    
    init() {
        food = FoodViewModel(foodManager: db)
        createFood = CreateFoodViewModel(db: db)
        history = HistoryViewModel(db: db)
        addFood = AddFoodViewModel(db: db)
        consumed = ConsumedViewModel(db: db)
    }
}

