import UIKit
import SkyFloatingLabelTextField

protocol ContactView: class {
    var navigationController: UINavigationController? { get }
    func setData(viewData: ContactViewData)
}

final class ContactViewController: UITableViewController {
    
    private static let storyboardName = "Contact"
    private static let vcID = "ContactViewController"
    
    @IBOutlet private var saveButton: UIBarButtonItem!
    
    @IBOutlet private var firstNameField: FloatingLabelField!
    @IBOutlet private var lastNameField: FloatingLabelField!
    @IBOutlet private var phoneNumberField: FloatingLabelField!
    @IBOutlet private var streetAddress1Field: FloatingLabelField!
    @IBOutlet private var streetAddress2Field: FloatingLabelField!
    @IBOutlet private var cityField: FloatingLabelField!
    @IBOutlet private var stateField: FloatingLabelField!
    @IBOutlet private var zipCodeField: FloatingLabelField!
    
    @IBOutlet private var deleteCell: UITableViewCell?
    
    private var presenter: ContactViewPresenter!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        presenter.viewDidLoad()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if presenter.shouldDisplayDeleteButton {
            return super.tableView(tableView, numberOfRowsInSection: section)
        } else {
            return super.tableView(tableView, numberOfRowsInSection: section) - 1
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = deleteCell, let deleteCellIndexPath = tableView.indexPath(for: cell) {
            if indexPath == deleteCellIndexPath {
                // Delete action
                tableView.deselectRow(at: indexPath, animated: false)
                let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
                let confrimationAction = UIAlertAction(title: "Delete Contact", style: .destructive, handler: { _ in self.presenter.onDeleteAction() })
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                actionSheet.addAction(confrimationAction)
                actionSheet.addAction(cancelAction)
                present(actionSheet, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction private func actionSave(_ sender: UIBarButtonItem) {
        let viewData = collectViewData()
        presenter.onSaveAction(viewData: viewData)
    }
    
    @IBAction private func actionTextFieldEditing(_ sender: UITextField) {
        saveButton.isEnabled = !firstNameField.text!.isEmpty && !lastNameField.text!.isEmpty
    }
    
    private func collectViewData() -> ContactViewData {
        let firstName = firstNameField.textValue!
        let lastName = lastNameField.textValue!
        let phoneNumber = phoneNumberField.textValue
        let streetAddress1 = streetAddress1Field.textValue
        let streetAddress2 = streetAddress2Field.textValue
        let city = cityField.textValue
        let state = stateField.textValue
        let zipCode = zipCodeField.textValue
        let viewData = ContactViewData(firstName: firstName, lastName: lastName, phoneNumber: phoneNumber, streetAddress1: streetAddress1, streetAddress2: streetAddress2, city: city, state: state, zipCode: zipCode)
        return viewData
    }

}

extension ContactViewController: ContactView {
    
    func setData(viewData: ContactViewData) {
        firstNameField.text = viewData.firstName
        lastNameField.text = viewData.lastName
        phoneNumberField.text = viewData.phoneNumber
        streetAddress1Field.text = viewData.streetAddress1
        streetAddress2Field.text = viewData.streetAddress2
        cityField.text = viewData.city
        stateField.text = viewData.state
        zipCodeField.text = viewData.zipCode
        navigationItem.title = "\(viewData.firstName) \(viewData.lastName)"
    }
    
}

extension ContactViewController {
    
    static func instantiateWithAddIntent() -> UIViewController {
        let vc = UIStoryboard(name: storyboardName, bundle: nil).instantiateViewController(withIdentifier: vcID) as! ContactViewController
        vc.presenter = AddContactPresenter(view: vc)
        return vc
    }
    
    static func instantiateWithEditIntent(contact: Contact) -> UIViewController {
        let vc = UIStoryboard(name: storyboardName, bundle: nil).instantiateViewController(withIdentifier: vcID) as! ContactViewController
        vc.presenter = EditContactPresenter(view: vc, contact: contact)
        return vc
    }
}
