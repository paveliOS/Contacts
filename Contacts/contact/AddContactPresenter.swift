import Foundation

final class AddContactPresenter {
    
    private weak var view: ContactView?
    
    init(view: ContactView?) {
        self.view = view
    }
    
}

extension AddContactPresenter: ContactViewPresenter {
    
    var shouldDisplayDeleteButton: Bool {
        return false
    }
    
    func viewDidLoad() {
        
    }
    
    func onSaveAction(viewData: ContactViewData) {
        let handler: (Contact) -> Void = { newContact in
            newContact.contactID = NSUUID().uuidString
            newContact.firstName = viewData.firstName
            newContact.lastName = viewData.lastName
            newContact.phoneNumber = viewData.phoneNumber
            newContact.streetAddress1 = viewData.streetAddress1
            newContact.streetAddress2 = viewData.streetAddress2
            newContact.city = viewData.city
            newContact.state = viewData.state
            newContact.zipCode = viewData.zipCode
        }
        
        let persistenceManager = AppDelegate.persistenceManager
        persistenceManager.insertObject(ofType: Contact.self, initializationHandler: handler)
        view?.navigationController?.popViewController(animated: true)
    }
    
    func onDeleteAction() {
        
    }
    
    
}
