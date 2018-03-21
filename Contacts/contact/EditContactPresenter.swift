final class EditContactPresenter {
    
    private weak var view: ContactView?
    private let contact: Contact
    
    init(view: ContactView?, contact: Contact) {
        self.view = view
        self.contact = contact
    }
    
}

extension EditContactPresenter: ContactViewPresenter {
    
    var shouldDisplayDeleteButton: Bool {
        return true
    }
    
    func viewDidLoad() {
        let viewData = ContactViewData(contact: contact)
        view?.setData(viewData: viewData)
    }
    
    func onSaveAction(viewData: ContactViewData) {
        let handler: (Contact) -> Void = { contact in
            contact.firstName = viewData.firstName
            contact.lastName = viewData.lastName
            contact.phoneNumber = viewData.phoneNumber
            contact.streetAddress1 = viewData.streetAddress1
            contact.streetAddress2 = viewData.streetAddress2
            contact.city = viewData.city
            contact.state = viewData.state
            contact.zipCode = viewData.zipCode
        }
        
        let persistenceManager = AppDelegate.persistenceManager
        persistenceManager.updateObject(object: contact, updateHandler: handler)
        view?.navigationController?.popViewController(animated: true)
    }
    
    func onDeleteAction() {
        let persistenceManager = AppDelegate.persistenceManager
        persistenceManager.deleteObject(object: contact)
        view?.navigationController?.popViewController(animated: true)
    }
    
    
}
