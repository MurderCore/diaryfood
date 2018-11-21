//
//  RootViewModel.swift
//  diary
//
//  Created by Victor on 11/12/18.
//  Copyright © 2018 Victor. All rights reserved.
//

import UIKit

class RootViewModel {
    
    func getCurrentDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        let time : String = formatter.string(from:   NSDate.init(timeIntervalSinceNow: 0) as Date)
        return time
    }
}
