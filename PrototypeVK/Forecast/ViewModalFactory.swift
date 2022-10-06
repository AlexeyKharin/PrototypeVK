
import Foundation

protocol ControllerFactory {
    func makeViewModal() -> (viewModal: ViewModelDelegate, realm: RealmDataProvider)
}

class ViewModalFactory: ControllerFactory {
    
    func makeViewModal() -> (viewModal: ViewModelDelegate, realm: RealmDataProvider) {
        let realm = RealmDataProvider()
        let convert = ConverterModelData()
        let viewModal = ViewModel()
        viewModal.realm = realm
        viewModal.convert = convert
        
        return (viewModal, realm)
    }
}
