//
//  FoodManager.swift
//  diary
//
//  Created by Victor on 11/12/18.
//  Copyright © 2018 Victor. All rights reserved.
//

import UIKit
import CoreData

class FoodManager {
    
    private let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    private var frc: NSFetchedResultsController<NSFetchRequestResult>!
    
    init() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Days")
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "date", ascending: true)
        ]
        
        frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context!,
                                         sectionNameKeyPath: nil, cacheName: nil)
        
    }
    
    
    func fetchFood(type: String) -> [NSManagedObject] {
        var res: [NSManagedObject] = []
        
        let request = NSFetchRequest<NSManagedObject>(entityName: type)
        do {
            try res = (context?.fetch(request))!
        } catch {
            print("Error fetching data: \(type)")
        }
        return res
    }

    
    func fetchFood(byIndex id: Int, type: String) -> NSManagedObject {
        return fetchFood(type: type)[id]
    }

    func fetchFood(byId id: Int, type: String) -> NSManagedObject {
        var obj = NSManagedObject()
        for food in fetchFood(type: type){
            if food.value(forKey: "id") as! Int32 == id {
                obj = food
                break
            }
        }
        return obj
    }
    
    
    func fetchCount(type: String) -> Int16 {
        return Int16(fetchFood(type: type).count)
    }
    
    func addFood(id: Int32, name: String, ingredients: String, image: NSData , type: String){
        
        let entity = NSEntityDescription.entity(forEntityName: "\(type)", in: context!)
        let storedItem = NSManagedObject(entity: entity!, insertInto: context)
        
        storedItem.setValue(id, forKey: "id")
        storedItem.setValue(name, forKey: "name")
        storedItem.setValue(ingredients, forKey: "ingredients")
        storedItem.setValue(image, forKey: "image")
        
        do {
            try context?.save()
            print("\(name) saved succesfully")
        } catch {
            print("Error saving \(name) to DB")
        }
        print("stored item id now is \(storedItem.value(forKey: "id")!)")
    }
    
    func removeFood(byId id: Int, type: String){
        let food = fetchFood(byId: id, type: type)
        context?.delete(food)
    }
    
    
    
    // MARK: -  HISTORY METHODS ######
    func fetchHistory() -> [NSManagedObject] {
        var res: [NSManagedObject] = []
        let request = NSFetchRequest<NSManagedObject>(entityName: "Days")
        do {
            try res = (context?.fetch(request))!
        } catch {
            print("Error fetching history")
        }
        return res
    }
    
    func fetchHistoryCount() -> Int {
        return fetchHistory().count
    }
    
    func fetchHistory(byId id: Int) -> NSManagedObject {
        var res = NSManagedObject()
        for hist in fetchHistory() {
            if hist.value(forKey: "id") as! Int32 == id {
                res = hist
                break
            }
        }
        return res
    }
    
    func existDay(date: String) -> Bool {
        for day in fetchHistory() {
            if day.value(forKey: "date") as! String == date {
                return true
            }
        }
        return false
    }
    
    
    func addDate(date: String){
        let entity = NSEntityDescription.entity(forEntityName: "Days", in: context!)
        let stored = NSManagedObject(entity: entity!, insertInto: context)
        
        stored.setValue(date, forKey: "date")
        do {
            try context?.save()
        } catch {
            print("Saving date error")
        }
    }
    
    
    func addFoodToDate(date: String, foodType: String, foodId: Int, quantity: Int){
        
        let fetchReq = NSFetchRequest<NSFetchRequestResult>(entityName: "Days")
        fetchReq.predicate = NSPredicate(format: "date = %@", date)
        
        let foodEntity = NSEntityDescription.entity(forEntityName: foodType, in: context!)
        let food = NSManagedObject(entity: foodEntity!, insertInto: context)
        
        food.setValue(foodId, forKey: "id")
        food.setValue(quantity, forKey: "quantity")
        
        if let fetchResults = try? context?.fetch(fetchReq) as? [NSManagedObject] {
            var day = fetchResults![0]
            let key = (foodType == "MealConsumed") ? "meals" : "drinks"
            day.mutableSetValue(forKey: key).add(food)
            print("To date \(date) added meal id \(foodId) (\(quantity)g")
        }
    }
}


/*
class Blabla {
    
    func save(item: Item, labels: [Label]) {
        
        let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Item", in: context!)
        
        let storedItem = NSManagedObject(entity: entity!, insertInto: context)
        storedItem.setValue(item.name, forKey: "name")
        storedItem.setValue(NSSet(objects: labels), forKey: "labels")
        
        do {
            try context?.save()
            items.append(storedItem)
        } catch {
            print("Saving data error")
        }
        
    }
    
    func fetchData(){
        
        let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
        let request = NSFetchRequest<NSManagedObject>(entityName: "Items")
        
        do {
            try items = (context?.fetch(request))!
        } catch {
            print("Error fetching data")
        }
    }
}
 */