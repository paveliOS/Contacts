import UIKit

final class ContactCell: UITableViewCell {
    
    @IBOutlet private var firstNameLabel: UILabel!
    @IBOutlet private var lastNameLabel: UILabel!

}

extension ContactCell {
    
    static let identifier = "Contact"
    
    func setData(contact: ContactCellViewData) {
        firstNameLabel.text = contact.firstName
        lastNameLabel.text = contact.lastName
    }
    
}
