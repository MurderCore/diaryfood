//
//  HistoryViewModel.swift
//  diary
//
//  Created by Victor on 11/13/18.
//  Copyright © 2018 Victor. All rights reserved.
//

import Foundation

class HistoryViewModel {
    
    var db = FoodManager.instance
    
    func getNumberOfRows() -> Int {
        return db.fetchHistoryCount()
    }
    
    func getCellDate(byIndex id: Int) -> String {
        let date = db.fetchHistory(byIndex: id).date
        return date!
    }
    
    func deleteDay(byDate date: String){
        db.deleteHistory(date: date)
    }
}
