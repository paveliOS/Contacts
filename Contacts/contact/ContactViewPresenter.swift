protocol ContactViewPresenter: class {
    var shouldDisplayDeleteButton: Bool { get }
    func viewDidLoad()
    func onSaveAction(viewData: ContactViewData)
    func onDeleteAction()
}
