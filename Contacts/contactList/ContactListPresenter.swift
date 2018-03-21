import CoreData

protocol ContactListViewPresenter: class {
    var numberOfSections: Int { get }
    func numberOfRowsInSection(section: Int) -> Int
    func titleForSection(section: Int) -> String?
    func viewData(atIndexPath indexPath: IndexPath) -> ContactCellViewData
    func onAddAction()
    func onRowSelection(atIndexPath indexPath: IndexPath)
}

final class ContactListPresenter: NSObject {
    
    private weak var view: ContactListView?
    private var fetchedResultsController: NSFetchedResultsController<Contact>
    
    init(view: ContactListView) {
        self.view = view
        let fetchRequest: NSFetchRequest<Contact> = NSFetchRequest(entityName: "Contact")
        let sortDescriptor = NSSortDescriptor(key: Contact.Key.lastName.rawValue, ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        let context = AppDelegate.persistenceManager.viewContext
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: Contact.Key.lastNameLetter.rawValue, cacheName: nil)
        super.init()
        fetchedResultsController.delegate = self
        fetch()
    }
    
    private func fetch() {
        do {
            try fetchedResultsController.performFetch()
        } catch let error {
            NSLog("Failed to fetch contact list with error: \(error.localizedDescription)")
        }
    }
    
}

extension ContactListPresenter: NSFetchedResultsControllerDelegate {
    
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        view?.listView?.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            view?.listView?.insertSections(IndexSet(integer: sectionIndex), with: .fade)
        case .delete:
            view?.listView?.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
        case .move, .update:
            break
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            view?.listView?.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            view?.listView?.deleteRows(at: [indexPath!], with: .fade)
        case .update:
            view?.listView?.reloadRows(at: [indexPath!], with: .fade)
        case .move:
            view?.listView?.moveRow(at: indexPath!, to: newIndexPath!)
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        view?.listView?.endUpdates()
    }
    
}

extension ContactListPresenter: ContactListViewPresenter {
    
    var numberOfSections: Int {
        return fetchedResultsController.sections?.count ?? 1
    }
    
    func numberOfRowsInSection(section: Int) -> Int {
        if let sections = fetchedResultsController.sections, sections.count > 0 {
            return sections[section].numberOfObjects
        } else {
            return 0
        }
    }
    
    func titleForSection(section: Int) -> String? {
        if let sections = fetchedResultsController.sections {
            return sections[section].name
        } else {
            return nil
        }
    }
    
    func viewData(atIndexPath indexPath: IndexPath) -> ContactCellViewData {
        let contact = fetchedResultsController.object(at: indexPath)
        let viewData = ContactCellViewData(contact: contact)
        return viewData
    }
    
    func onAddAction() {
        let addContactView = ContactViewController.instantiateWithAddIntent()
        view?.navigationController?.pushViewController(addContactView, animated: true)
    }
    
    func onRowSelection(atIndexPath indexPath: IndexPath) {
        let contact = fetchedResultsController.object(at: indexPath)
        let editContactView = ContactViewController.instantiateWithEditIntent(contact: contact)
        view?.navigationController?.pushViewController(editContactView, animated: true)
    }
    
}
