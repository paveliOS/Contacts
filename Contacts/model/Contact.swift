import CoreData

final class Contact: NSManagedObject {
    
    @NSManaged var contactID: String
    @NSManaged var firstName: String
    @NSManaged var lastName: String
    @NSManaged var phoneNumber: String?
    @NSManaged var streetAddress1: String?
    @NSManaged var streetAddress2: String?
    @NSManaged var city: String?
    @NSManaged var state: String?
    @NSManaged var zipCode: String?
    
    @objc var lastNameLetter: String? {
        return String(lastName.first!).uppercased()
    }
    
}

extension Contact {
    
    enum Key: String {
        case contactID
        case firstName
        case lastName
        case phoneNumber
        case streetAddress1
        case streetAddress2
        case city
        case state
        case zipCode
        case lastNameLetter
    }
    
    func populateFromJSON(_ json: [String : Any]) throws {
        guard let contactID = json[Key.contactID.rawValue] as? String, let firstName = json[Key.firstName.rawValue] as? String, let lastName = json[Key.lastName.rawValue] as? String else {
            throw SerializationError.Failure("Failed to populate \(type(of: self)) with json: \(json.debugDescription)")
        }
        self.contactID = contactID
        self.firstName = firstName
        self.lastName = lastName
        self.phoneNumber = json[Key.phoneNumber.rawValue] as? String
        self.streetAddress1 = json[Key.streetAddress1.rawValue] as? String
        self.streetAddress2 = json[Key.streetAddress2.rawValue] as? String
        self.city = json[Key.city.rawValue] as? String
        self.state = json[Key.state.rawValue] as? String
        self.zipCode = json[Key.zipCode.rawValue] as? String
    }
    
}
