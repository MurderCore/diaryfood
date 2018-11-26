//
//  File.swift
//  diary
//
//  Created by Victor on 11/12/18.
//  Copyright © 2018 Victor. All rights reserved.
//

import Foundation

class ViewModels {

    var root = RootViewModel()
    var food: FoodViewModel?
    var createFood: CreateFoodViewModel?
    var history: HistoryViewModel?
    var addFood: AddFoodViewModel?
    var consumed: ConsumedViewModel?
    
    init() {
        food = FoodViewModel()
        createFood = CreateFoodViewModel()
        history = HistoryViewModel()
        addFood = AddFoodViewModel()
        consumed = ConsumedViewModel()
    }
}

