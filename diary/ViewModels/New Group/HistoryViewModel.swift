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
    
    func getCellDate(byIndex id: Int) -> String {
        let date = db?.fetchHistory(byIndex: id).value(forKey: "date") as! String
        return date
    }
}
