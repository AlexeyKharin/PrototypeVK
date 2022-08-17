
import Foundation
import FlagPhoneNumber

class PresenterLogIn {
    
    var router: LogInRouterProtocol?
    
    weak var view: LogInViewProtocol?
    
    var interactor: LogInInteractorInput?
    
}

extension PresenterLogIn: LogInPresenterProtocol {
    func confugureArray() -> [CountryType]? {
        
        return interactor?.prepareArrayOfCountries()
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
    
    func verificationOfPhoneNumber() {
        interactor?.verification()
    }
}

extension PresenterLogIn: LogInInteractorOutput {
    
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
}
