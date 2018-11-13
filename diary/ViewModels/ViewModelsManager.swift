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
    var meals: MealsViewModel?
    var drinks: DrinksViewModel?
    var createMeal: CreateMealViewModel?
    
    init() {
        meals = MealsViewModel(foodManager: db)
        drinks = DrinksViewModel(foodManager: db)
        createMeal = CreateMealViewModel(db: db)
    }
}

