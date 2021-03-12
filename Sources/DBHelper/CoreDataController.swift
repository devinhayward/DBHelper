//
//  CoreDataController.swift
//  
//
//  Created by Devin Hayward on 2021-03-08.
//

import Foundation
import CoreData

@available(iOS 10.0, *)
public struct CoreDataController: DBHelperProtocol {
    public typealias ObjectType = NSManagedObject
    
    public typealias PredicateType = NSPredicate
    
    public var context: NSManagedObjectContext
    
    public init(context: NSManagedObjectContext) {
        self.context = context
    }

    public func create(_ object: ObjectType) {
        // object is fed to the context and saved
        do {
            try context.save()
        } catch {
            if let nserror = error as NSError? {
                fatalError("Unresolved error when creating this object \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    public func fetch<T: NSManagedObject>(_ objectType: T.Type, predicate: NSPredicate? = nil, limit: Int? = nil) -> Result<[T], Error> {
        
        let request = objectType.fetchRequest()
        
        request.predicate = predicate
        
        if let limit = limit {
            request.fetchLimit = limit
        }
        
        do {
            let result = try context.fetch(request)
            return .success(result as? [T] ?? [])
        } catch {
            return .failure(error)
        }
    }
    
    public func fetchFirstContact<T: NSManagedObject>(_ objectType: T.Type, predicate: PredicateType?) -> Result<T?, Error> {
        let result = fetch(objectType, predicate: predicate, limit: 1)
                switch result {
                case .success(let contacts):
                    return .success(contacts.first as? T)
                case .failure(let error):
                    return .failure(error)
                }
    }
    
    public func update(_ object: ObjectType) {
        // object is fed to the context for update and saved
        do {
            try context.save()
        } catch {
            if let nserror = error as NSError? {
                fatalError("Unresolved error when updating this object \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    public func delete(_ object: ObjectType) {
        // delete the object here and save
        do {
            context.delete(object)
            try context.save()
        } catch {
            if let nserror = error as NSError? {
                fatalError("Unresolved error when deleting this object \(nserror), \(nserror.userInfo)")
            }
        }
        
    }
}
