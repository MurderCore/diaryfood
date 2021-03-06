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
    
    static let instance = FoodManager()
    
    var populated = false
    
    private let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    private var frc: NSFetchedResultsController<NSFetchRequestResult>!
    private var fetchRequest: NSFetchRequest<NSFetchRequestResult>?
    
    
    init() {
        configFetchRequestController()
        PopulateIfFirstLaunch()
    }
    
    
    
    
    
    
    // FOOD METHODS
    
    func fetchFood(type: String) -> [FoodModel] {
        var fetched: [FoodModel] = []
        var res: [NSManagedObject] = []
        
        let request = NSFetchRequest<NSManagedObject>(entityName: type)
        do {
            try res = (context?.fetch(request))!
        } catch {
            fatalError("Failed to load data from Database")
        }
        
        for food in res {
            let fd = FoodModel()
            fd.id = food.value(forKey: "id") as? Int32
            fd.image = food.value(forKey: "image") as? NSData
            fd.ingredients = food.value(forKey: "ingredients") as? String
            fd.name = food.value(forKey: "name") as? String
            fetched.append(fd)
        }
        return fetched
    }
    
    func fetchFood(byIndex id: Int, type: String) -> FoodModel {
        return fetchFood(type: type)[id]
    }
    func fetchFood(byId id: Int, type: String) -> FoodModel? {
        for food in fetchFood(type: type){
            if food.id! == id {
                return food
            }
        }
        return nil
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
        
        saveContext()
    }
    
    func removeFood(byId id: Int, type: String){
        deleteFoodFromHistory(id: id, foodType: type)
        let food = fetchFoodManaged(byId: id, type: type)
        
        context?.delete(food!)
        saveContext()
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
    
    func deleteFoodFromDate(date: String, type: String, foodId: Int){
        let food = fetchConsumed(byId: foodId, type: type, date: date)
        context?.delete(food!)
        saveContext()
    }
    
    func addFoodToDate(date: String, foodType: String, foodId: Int, quantity: String){
        
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
    
    private func fetchFoodManaged(type: String) -> [NSManagedObject] {
        var res: [NSManagedObject] = []
        
        let request = NSFetchRequest<NSManagedObject>(entityName: type)
        do {
            try res = (context?.fetch(request))!
        } catch {
            fatalError("Failed to load data from Database")
        }
        return res
    }
    
    
    
    
    
    // HISTORY METHODS
    
    func fetchHistory() -> [DayModel] {
        performFetchRequestController(predicate: nil)
        let days = frc.sections?[0].objects as! [NSManagedObject]
        var result: [DayModel] = []
        
        for day in days {
            let d = DayModel()
            d.date = day.value(forKey: "date") as? String
            result.append(d)
        }
        return result
    }
    
    func fetchHistoryCount() -> Int {
        return fetchHistory().count
    }
    
    func fetchHistory(byIndex id: Int) -> DayModel {
        return fetchHistory()[id]
    }
    
    func existDay(date: String) -> Bool {
        for day in fetchHistory() {
            if day.date == date {
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
    
    func deleteHistory(date: String){
        if !existDay(date: date) {
            return
        }
        let day = findDay(byDate: date)
        context?.delete(day)
        saveContext()
    }
    
    
    
    
    
    // CONSUMED FOOD METHODS
    
    func FoodConsumedCount(type: String) -> Int {
        let request = NSFetchRequest<NSManagedObject>(entityName: type)
        return (contextFetch(request: request as! NSFetchRequest<NSFetchRequestResult>)?.count)!
    }
    
    func getFoodCountByDate(date: String, type: String) -> Int {
        return getFood(byDate: date, type: type).count
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
    
    func getConsumed(date: String, type: String) -> [ConsumedModel]? {
        var result: [ConsumedModel] = []
        
        if !existDay(date: date) {
            return nil
        }
        let day = findDay(byDate: date)
        let objects = (day.mutableSetValue(forKey: type).allObjects as! [NSManagedObject])
        
        for obj in objects {
            let consumed = ConsumedModel()
            consumed.id = obj.value(forKey: "id") as? Int32
            consumed.quantity = obj.value(forKey: "quantity") as? String
            consumed.selfId = obj.value(forKey: "selfId") as? Int32
            result.append(consumed)
        }
        return result
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
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: type)
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)
        obj = contextFetch(request: fetchRequest)
        
        for food in obj! {
            context?.delete(food)
        }
        saveContext()
        
        for day in fetchHistory() {
           let _ = checkIfFoodLeft(atDate: day.date!)
        }
    }
    
    
    
    
    // HELPERS
    
    func configFetchRequestController() {
        fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Days")
        fetchRequest?.sortDescriptors = [
            NSSortDescriptor(key: "date", ascending: true)
        ]
        
        frc = NSFetchedResultsController(fetchRequest: fetchRequest!, managedObjectContext: context!,
                                         sectionNameKeyPath: nil, cacheName: nil)
    }
    
    func contextFetch(request: NSFetchRequest<NSFetchRequestResult>) -> [NSManagedObject]? {
        do {
            return try context?.fetch(request) as? [NSManagedObject]
        }
        catch {
            fatalError("Failed to load data from Database")
        }
        return nil
    }
    
    func saveContext(){
        do {
            try context?.save()
        } catch {
            fatalError("Failed to save data to Database")
        }
    }
    
    func performFetchRequestController(predicate: NSPredicate?) {
        frc.fetchRequest.predicate = predicate
        do {
            try frc.performFetch()
        } catch {
            fatalError("Failed to load data from Database")
        }
    }
    
    func findDay(byDate date: String) -> NSManagedObject {
        let predicate = NSPredicate(format: "date == %@", date)
        performFetchRequestController(predicate: predicate)
        return frc.sections?[0].objects![0] as! NSManagedObject
    }
    
    
    
    
    // POPULATE DB FROM PLIST
    
    func PopulateIfFirstLaunch(){
        populated = UserDefaults.standard.bool(forKey: "populated")
        if !populated {
            populateDataBase()
            UserDefaults.standard.set(true, forKey: "populated")
            UserDefaults.standard.synchronize()
        }
    }
    
    func populateDataBase(){
        
        func addForDict(name: String, userDefaultKey: String) {
            
            if let path = Bundle.main.path(forResource: name, ofType: "plist"){
                if let arrayOfDictionaries = NSArray(contentsOfFile: path)
                {
                    let foodCount = arrayOfDictionaries.count
                    UserDefaults.standard.set(foodCount, forKey: userDefaultKey)
                    
                    for dict in arrayOfDictionaries {
                        populateFood(type: name, dict: dict as! NSDictionary)
                    }
                }
            }
        }
        func populateFood(type: String, dict: NSDictionary) {
            var imgData: NSData?
            let path = dict["image"] as! String
            if let filePath = Bundle.main.path(forResource: path, ofType: ""), let image = UIImage(contentsOfFile: filePath) {
                imgData = image.pngData()! as NSData
            }
            let ingredients = (dict["ingredients"])!
            let name = (dict["name"])!
            let id = (dict["id"])!
            
            addFood(id: id as! Int32, name: name as! String, ingredients: ingredients as! String, image: imgData!, type: type)
        }
        
        addForDict(name: "Meals", userDefaultKey: "plistMeals")
        addForDict(name: "Drinks", userDefaultKey: "plistDrinks")
    }
    
    private func fetchFoodManaged(byId id: Int, type: String) -> NSManagedObject? {
        for food in fetchFoodManaged(type: type){
            if food.value(forKey: "id") as! Int32 == id {
                return food
            }
        }
        return nil
    }
}







