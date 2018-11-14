//
//  HistoryViewModel.swift
//  diary
//
//  Created by Victor on 11/13/18.
//  Copyright © 2018 Victor. All rights reserved.
//

import Foundation

class HistoryViewModel {
    
    var db: FoodManager?
    
    init(db: FoodManager) {
        self.db = db
    }
    
    func getNumberOfRows() -> Int {
        return (db?.fetchHistoryCount())!
    }
    
    func getCellDate(byId id: Int) -> String {
        let date = db?.fetchHistory(byId: id).value(forKey: "date") as! NSDate
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        let time : String = formatter.string(from: date as Date)
        return time
    }
}
