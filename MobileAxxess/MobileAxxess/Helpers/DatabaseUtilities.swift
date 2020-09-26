//
//  DatabaseUtilities.swift
//  MobileAxxess
//
//  Created by Nannapuraju, Dheeraj R on 9/26/20.
//  Copyright © 2020 Dheeraj. All rights reserved.
//


import CoreData

class DatabaseUtilities: NSObject {
    
    //MARK: - Get Home Data From DB
    func getHomeDataFromDB(sortType : Int, offSet : Int, limit: Int, completionHandler: (_ success: Bool, _ userData: Array<HomeViewData>?,_ error: String?) ->())
    {
        let managedContext = CoreDatabase.sharedInstance().managedObjectContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "HomeViewEntity")
        let sort = NSSortDescriptor(key: "type", ascending: (sortType == SortType.Text.rawValue ? false : true))
        fetchRequest.sortDescriptors = [sort]
        fetchRequest.fetchOffset = offSet
        fetchRequest.fetchLimit = limit
        do {
            let result = try managedContext.fetch(fetchRequest)
            if result.count == 0
            {
                completionHandler(false, nil, "")
            }
            var homeViewArray = Array<HomeViewData>()

            for managedObject in result {
                let data = managedObject as! HomeViewEntity
                let homeView = HomeViewData()
                homeView.date = data.date
                homeView.id = data.id
                homeView.type = data.type
                homeView.text = data.text
                homeView.imageDownloaded = data.imageDownloaded
                homeView.imageData = data.image
                homeViewArray.append(homeView)
            }
                if homeViewArray.count > 0
                {
                    completionHandler(true, homeViewArray, "")
                }
                else
                {
                    completionHandler(false, nil, "")
                }
        } catch let error as NSError {
            completionHandler(false, nil , ("Could not fetch \(error), \(error.userInfo)"))
        }
    }
    
    //MARK: - Save Home Data In DB
    func saveHomeDataInDB(list : Array<HomeViewData>, completionHandler: (_ success: Bool, _ error: String?) ->())
    {
        self.removeDataForEntity(name: "HomeViewEntity") { (success, error) in
            let managedContext = CoreDatabase.sharedInstance().managedObjectContext
            let entity =  NSEntityDescription.entity(forEntityName: "HomeViewEntity",
                                                     in:managedContext)

            for(_, data) in list.enumerated()
            {
                let homeView = NSManagedObject(entity: entity!,
                                               insertInto: managedContext) as! HomeViewEntity
                homeView.date = data.date
                homeView.id = data.id
                homeView.type = data.type
                homeView.text = data.text
                homeView.imageDownloaded = false
            }
            do {
                try managedContext.save()
                completionHandler(true, "")
            } catch let error as NSError  {
                completionHandler(false, ("Could not save \(error), \(error.userInfo)"))
            }
        }
    }
    
    //MARK: - Remove all details From Entity inn DB
    func removeDataForEntity(name : String, completionHandler: (_ success: Bool, _ error: String?) ->())
    {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: name)
        let managedContext = CoreDatabase.sharedInstance().managedObjectContext
        var complete = true
        var errorString = ""
        if #available(iOS 9.0, *)
        {
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            
            do {
                try CoreDatabase.sharedInstance().persistentStoreCoordinator.execute(deleteRequest, with: managedContext)
            } catch let error as NSError {
                complete = false
                errorString = error.localizedDescription
            }
        }
        else
        {
            fetchRequest.includesPropertyValues = false
            let _ : NSError?
            do
            {
                let fetchedObjects = try managedContext.fetch(fetchRequest)
                for(_,element) in fetchedObjects.enumerated()
                {
                    managedContext.delete(element as! NSManagedObject)
                }
                do {
                    try managedContext.save()
                }catch let error as NSError {
                    complete = false
                    errorString = error.localizedDescription
                }
            }
            catch let error as NSError {
                complete = false
                errorString = error.localizedDescription
            }
        }
        completionHandler(complete, errorString)
    }
    
    //MARK: - Update Home Data In DB
    func updateHomeDataInDB(response : HomeViewData, completionHandler: (_ success: Bool, _ error: String?) ->())
    {
        let managedContext = CoreDatabase.sharedInstance().managedObjectContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "HomeViewEntity")
        do {
            let result = try managedContext.fetch(fetchRequest)
            if result.count == 0
            {
                completionHandler(false, "")
            }
            for managedObject in result {
                let dbValue = managedObject as! HomeViewEntity
                if dbValue.id == response.id {
                    dbValue.imageDownloaded = response.imageDownloaded!
                    dbValue.image = response.imageData
                    do {
                        try managedContext.save()
                        completionHandler(true, "")
                    } catch let error as NSError  {
                        completionHandler(false, ("Could not save \(error), \(error.userInfo)"))
                        
                    }
                }
            }
        } catch let error as NSError {
            completionHandler(false, ("Could not fetch \(error), \(error.userInfo)"))
        }
    }
}
