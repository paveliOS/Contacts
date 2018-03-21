import CoreData

protocol PersistenceManagerProtocol: class {
    var viewContext: NSManagedObjectContext { get }
    func save()
    func insertObject<T: NSManagedObject>(ofType type: T.Type, initializationHandler: @escaping ((T) -> Void))
    func updateObject<T: NSManagedObject>(object: T, updateHandler: @escaping ((T) -> Void))
    func deleteObject<T: NSManagedObject>(object: T)
}

final class PersistenceManager {
    
    private let modelName: String
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: modelName)
        container.loadPersistentStores(completionHandler: { _,_  in })
        return container
    }()
    
    init(modelName: String) {
        self.modelName = modelName
        if MainSettings.shared.shouldFillDatabase {
            fillDatabase {
                MainSettings.shared.shouldFillDatabase = false
            }
        }
    }
    
    private func fillDatabase(callback: (() -> Void)?) {
        do {
            let contactsJSON = try fetchContactsJSON()
            let viewContext = persistentContainer.viewContext
            
            let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
            context.parent = viewContext
            
            context.perform {
                do {
                    try contactsJSON.forEach {
                        let contact = Contact(context: viewContext)
                        try contact.populateFromJSON($0)
                    }
                    try context.save()
                    viewContext.performAndWait {
                        do {
                            try viewContext.save()
                            callback?()
                        } catch {
                            NSLog("Failed to save view context: \(error)")
                        }
                    }
                } catch let error {
                    NSLog("Failed to save private context: \(error)")
                }
            }
        } catch let error {
            NSLog(error.localizedDescription)
        }
    }
    
    private func fetchContactsJSON() throws -> [[String : Any]] {
        let initialContactsJSONURL = URL(fileURLWithPath: Bundle.main.path(forResource: "InitialContacts", ofType: "json")!)
        let contactsJSONData = try Data(contentsOf: initialContactsJSONURL)
        let json = try JSONSerialization.jsonObject(with: contactsJSONData, options: [])
        guard let jsonArray = json as? [[String : Any]] else {
            throw SerializationError.Failure("Failed to convert json file to dictionary")
        }
        return jsonArray
    }
    
    private func updateConcurrently(block: @escaping (NSManagedObjectContext) -> Void) {
        let viewContext = persistentContainer.viewContext
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.parent = viewContext
        
        context.perform {
            do {
                block(context)
                try context.save()
                viewContext.performAndWait {
                    do {
                        try viewContext.save()
                    } catch {
                        NSLog("Failed to save view context: \(error)")
                    }
                }
            } catch let error {
                NSLog("Failed to save private context: \(error)")
            }
        }
    }
    
}

extension PersistenceManager: PersistenceManagerProtocol {
    
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func save() {
        do {
            let context = persistentContainer.viewContext
            try context.save()
        } catch let error {
            NSLog("Failed to save view context with error: \(error.localizedDescription)")
        }
        
    }
    
    func insertObject<T>(ofType type: T.Type, initializationHandler: @escaping ((T) -> Void)) where T : NSManagedObject {
        updateConcurrently { context in
            let object = type.init(context: context)
            initializationHandler(object)
        }
    }
    
    func updateObject<T>(object: T, updateHandler: @escaping ((T) -> Void)) where T : NSManagedObject {
        updateConcurrently { _ in
            updateHandler(object)
        }
    }
    
    func deleteObject<T>(object: T) where T : NSManagedObject {
        let objectID = object.objectID
        updateConcurrently { context in
            do {
                let objectToDelete = try context.existingObject(with: objectID)
                context.delete(objectToDelete)
            } catch let error {
                NSLog("Failed to fetch object with id: \(objectID) because of error: \(error.localizedDescription)")
            }
        }
    }
    
}

