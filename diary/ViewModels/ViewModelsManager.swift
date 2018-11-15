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
    var createDrink: CreateDrinkViewModel?
    var history: HistoryViewModel?
    var addMeal: AddMealViewModel?
    var addDrink: AddDrinkViewModel?
    var consumed: ConsumedViewModel?
    
    init() {
        meals = MealsViewModel(foodManager: db)
        drinks = DrinksViewModel(foodManager: db)
        createMeal = CreateMealViewModel(db: db)
        createDrink = CreateDrinkViewModel(db: db)
        history = HistoryViewModel(db: db)
        addMeal = AddMealViewModel(db: db)
        addDrink = AddDrinkViewModel(db: db)
        consumed = ConsumedViewModel(db: db)
    }
}

