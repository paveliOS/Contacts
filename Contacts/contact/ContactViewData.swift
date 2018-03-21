struct ContactViewData {
    let firstName: String
    let lastName: String
    let phoneNumber: String?
    let streetAddress1: String?
    let streetAddress2: String?
    let city: String?
    let state: String?
    let zipCode: String?
    
    init(firstName: String, lastName: String, phoneNumber: String?, streetAddress1: String?, streetAddress2: String?, city: String?, state: String?, zipCode: String?) {
        self.firstName = firstName
        self.lastName = lastName
        self.phoneNumber = phoneNumber
        self.streetAddress1 = streetAddress1
        self.streetAddress2 = streetAddress2
        self.city = city
        self.state = state
        self.zipCode = zipCode
    }
    
    init(contact: Contact) {
        self.firstName = contact.firstName
        self.lastName = contact.lastName
        self.phoneNumber = contact.phoneNumber
        self.streetAddress1 = contact.streetAddress1
        self.streetAddress2 = contact.streetAddress2
        self.city = contact.city
        self.state = contact.state
        self.zipCode = contact.zipCode
    }
    
}

