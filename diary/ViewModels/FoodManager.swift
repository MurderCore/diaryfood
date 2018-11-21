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
    
    var populated = false
    
    private let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    private var frc: NSFetchedResultsController<NSFetchRequestResult>!
    private var fetchRequest: NSFetchRequest<NSFetchRequestResult>?
    
    init() {
        fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Days")
        fetchRequest?.sortDescriptors = [
            NSSortDescriptor(key: "date", ascending: true)
        ]
        
        frc = NSFetchedResultsController(fetchRequest: fetchRequest!, managedObjectContext: context!,
                                         sectionNameKeyPath: nil, cacheName: nil)
        
        populated = UserDefaults.standard.bool(forKey: "populated")
         if !populated {
            populateDataBase()
            UserDefaults.standard.set(true, forKey: "populated")
            UserDefaults.standard.synchronize()
         }
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

    func fetchFood(byId id: Int, type: String) -> NSManagedObject? {
        for food in fetchFood(type: type){
            if food.value(forKey: "id") as! Int32 == id {
                print("IN DB FOOD \(food.value(forKey: "Name")) has id \(food.value(forKey: "id")) ")
                return food
            }
        }
        return nil
    }
    
    
    func fetchCount(type: String) -> Int16 {
        return Int16(fetchFood(type: type).count)
    }
    
    func addFood(id: Int32, name: String, ingredients: String, image: NSData , type: String){
        
        print("Created food with id \(id)")
        
        let entity = NSEntityDescription.entity(forEntityName: "\(type)", in: context!)
        let storedItem = NSManagedObject(entity: entity!, insertInto: context)
        
        storedItem.setValue(id, forKey: "id")
        storedItem.setValue(name, forKey: "name")
        storedItem.setValue(ingredients, forKey: "ingredients")
        storedItem.setValue(image, forKey: "image")
        
        saveContext()
    }
    
    func removeFood(byId id: Int, type: String){
        let food = fetchFood(byId: id, type: type)
        context?.delete(food!)
        saveContext()
        deleteFoodFromHistory(id: id, foodType: type)
    }
    
    
    
    // MARK: -  HISTORY METHODS ######
    func fetchHistory() -> [NSManagedObject] {
        frc.fetchRequest.predicate = nil
        do {
            try frc.performFetch()
        } catch {
            print("Error fetching history")
        }
        return frc.sections?[0].objects as! [NSManagedObject]
    }
    
    func fetchHistoryCount() -> Int {
        return fetchHistory().count
    }
    
    func fetchHistory(byIndex id: Int) -> NSManagedObject {
        return fetchHistory()[id]
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
        saveContext()
    }
    
    func FoodConsumedCount(type: String) -> Int {
        let request = NSFetchRequest<NSManagedObject>(entityName: type)
        do {
            return (try (context?.fetch(request))?.count)!
        } catch {
            print("Error fetching data: \(type)")
        }
        return 0
    }
    
    
    func addFoodToDate(date: String, foodType: String, foodId: Int, quantity: String){
        
        print("Added ID \(foodId) to date")
        
        let entityName = (foodType == "Meals") ? "MealConsumed" : "DrinkConsumed"
        
        let fetchReq = NSFetchRequest<NSFetchRequestResult>(entityName: "Days")
        fetchReq.predicate = NSPredicate(format: "date = %@", date)
        
        let foodEntity = NSEntityDescription.entity(forEntityName: entityName, in: context!)
        let food = NSManagedObject(entity: foodEntity!, insertInto: context)
        
        food.setValue(FoodConsumedCount(type: entityName), forKey: "selfId")
        food.setValue(foodId, forKey: "id")
        food.setValue(quantity, forKey: "quantity")
        
        if let fetchResults = try? context?.fetch(fetchReq) as? [NSManagedObject] {
            let day = fetchResults![0]
            let key = (foodType == "Meals") ? "meals" : "drinks"
            day.mutableSetValue(forKey: key).add(food)
        }
        saveContext()
    }
    func deleteFoodFromDate(date: String, type: String, foodId: Int){
        let food = fetchConsumed(byId: foodId, type: type, date: date)
        context?.delete(food!)
        saveContext()
        checkIfFoodLeft(atDate: date)
    }
    
    
    func checkIfFoodLeft(atDate date: String) -> Bool {
        let day = findDay(byDate: date)
        if day.mutableSetValue(forKey: "drinks").allObjects.count == 0
            && day.mutableSetValue(forKey: "meals").allObjects.count == 0 {
            deleteHistory(date: date)
            return false
        }
        return true
    }
    
    func getFood(byDate date: String, type: String) -> [NSManagedObject] {
        let day = findDay(byDate: date)
        let foodIds = day.value(forKey: type) as! NSSet
        
        return foodIds.allObjects as! [NSManagedObject]
    }
    
    func getFoodCountByDate(date: String, type: String) -> Int {
        return getFood(byDate: date, type: type).count
    }
    
    func deleteHistory(date: String){
        let day = findDay(byDate: date)
        context?.delete(day)
        saveContext()
    }
    
    func fetchConsumed(byId id: Int, type: String, date: String) -> NSManagedObject? {
        
        let day = findDay(byDate: date)
        let key = (type == "DrinkConsumed") ? "drinks" : "meals"
        let days = day.mutableSetValue(forKey: key).allObjects
        
        for day in (days as! [NSManagedObject]) {
            if (day.value(forKey: "selfId") as! Int32) == id {
                return day
            }
        }
        return nil
    }
    
    func getConsumed(date: String, type: String) -> [NSManagedObject]? {
        let day = findDay(byDate: date)
        return day.mutableSetValue(forKey: type).allObjects as! [NSManagedObject]
    }
    
    func fetchConsumed(byIndex id: Int, type: String, date: String) -> NSManagedObject{
        let day = findDay(byDate: date)
        let key = (type == "DrinkConsumed") ? "drinks" : "meals"
        let consumed = day.mutableSetValue(forKey: key).allObjects[id]
        return consumed as! NSManagedObject
    }
    
    func deleteFoodFromHistory(id: Int, foodType: String){
        
        var obj: [NSManagedObject]?
        let type = (foodType == "Meals") ? "MealConsumed" : "DrinkConsumed"
        
        // fetch all FoodConsumed with given ID
        do {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: type)
            fetchRequest.predicate = NSPredicate(format: "id == %d", id)
            obj = try context?.fetch(fetchRequest) as! [NSManagedObject]
        }
        catch {
            print ("fetch task failed", error)
        }
        
        // Delete all FoodConsumed from context
        for food in obj! {
            context?.delete(food)
        }
        saveContext()
        
        // Delete all empty days
        for day in fetchHistory() {
            checkIfFoodLeft(atDate: day.value(forKey: "date") as! String)
        }
    }
    
    
    // HELPERS @@@@
    func saveContext(){
        do {
            try context?.save()
        } catch {
            print("Error saving context")
        }
    }
    
    func findDay(byDate date: String) -> NSManagedObject{
        let predicate = NSPredicate(format: "date == %@", date)
        frc.fetchRequest.predicate = predicate
        do {
            try frc.performFetch()
        } catch {
        }
        return frc.sections?[0].objects![0] as! NSManagedObject
    }
    
    func populateDataBase(){
        
        func populateFood(type: String, myDict: NSDictionary) {
            for i in 1...(myDict["\(type)Count"] as! Int) {
                
                var imgData: NSData?
                let path = ((myDict["\(type)\(i)"] as! NSDictionary)["image"]) as! String
                if let filePath = Bundle.main.path(forResource: path, ofType: ""), let image = UIImage(contentsOfFile: filePath) {
                    imgData = UIImagePNGRepresentation(image)! as NSData
                }
                let ingredients = ((myDict["\(type)\(i)"] as! NSDictionary)["ingredients"])!
                let name = ((myDict["\(type)\(i)"] as! NSDictionary)["name"])!
                let id = ((myDict["\(type)\(i)"] as! NSDictionary)["id"])!
                
                addFood(id: id as! Int32, name: name as! String, ingredients: ingredients as! String, image: imgData!, type: "\(type)s")
            }
        }
        
        if let path = Bundle.main.path(forResource: "Food", ofType: "plist"),
            let myDict = NSDictionary(contentsOfFile: path)
        {
            populateFood(type: "Meal", myDict: myDict)
            populateFood(type: "Drink", myDict: myDict)
        }
    }
}







