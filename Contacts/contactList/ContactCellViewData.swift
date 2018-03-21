struct ContactCellViewData {
    let firstName: String
    let lastName: String
    
    init(contact: Contact) {
        self.firstName = contact.firstName
        self.lastName = contact.lastName
    }
}
