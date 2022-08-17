
import Foundation
import FlagPhoneNumber

class PresenterSignIn {
    
    var router: RouterSignIn?
    
    weak var view: SignInViewProtocol?
    
    var interactor: SignInteractorInput?
    
}

extension PresenterSignIn: SignInPresenterProtocol {
    
    func confugureArray() -> [CountryType]? {
        
        return interactor?.prepareArrayOfCountries()
    }
    
    
    func attemptBiometricAuthorization() {
        interactor?.requestBiometricAuthorization()
    }
    
    func verificationOfPhoneNumber() {
        interactor?.verification()
    }
    
    func requestFullPhoneNumber(number: String, country: CountryType) {
        interactor?.requestFullNumber(phone: number, country: country)
    }
    
    func doubleTap() {
        interactor?.showListController()
    }
    
    func getPhoneCodeExample(country: CountryType) {
        interactor?.convertContryToPhoneNumber(country)
    }
    
}

extension PresenterSignIn: SignInInteractorOutput {
    
    func validation(isValid: Bool) {
        view?.validationPhoneNumber(isValid: isValid)
    }
    
    func showListController(listController: FPNCountryListViewController) {
        let list = listController
        router?.showListController(list: list)
        
    }
    
    func sendTypePhone(_ phone: String) {
        view?.upDatePlaceHolder(typePhone: phone)
        
    }
    
    func transferIndex(_ index: Int) {
        view?.selectComponentInPickerView(row: index)
        
    }
    
    func successVerification(verificationID: String, numberPhone: String, typeAuthorization: TypeAuthorization) {
        router?.successVerification(verificationID: verificationID, numberPhone: numberPhone, typeAuthorization: typeAuthorization)
    }
    
    func succesBiometricAuthorization() {
        router?.succesBiometricAuthorization()
    }
    
    func errorAuthorization(tittle: String, message: String) {
        router?.showAlerAuthorization(tittle: tittle, message: message)
    }
    
    func setBiometricImage(image: UIImage) {
        view?.setBiometricImage(image)
    }
}
