
import Foundation
import FlagPhoneNumber

class PresenterLogIn {
    
    var router: LogInRouterProtocol?
    
    var view: LogInViewProtocol?
    
    var interactor: LogInInteractorInput?
    
}

extension PresenterLogIn: LogInPresenterProtocol {
        
    func verificationOfPhoneNumber() {
        interactor?.verification()
    }
    
    func requestFullPhoneNumber(number: String) {
        interactor?.requestFullNumber(phone: number)
    }
    
    func doubleTap() {
        interactor?.showListController()
    }
    
    func configureDate() {
        interactor?.transferData()
    }
    
    func getPhoneCodeExample(country: FPNCountry) {
        interactor?.convertContryToPhoneNumber(country)
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
    
    func transferData(data: [FPNCountry]) {
        view?.generateCountries(data)
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
