
import Foundation
import FlagPhoneNumber
import Firebase
import FirebaseAuth

class InteractorLogIn: LogInInteractorInput {
    
    var outPut: LogInInteractorOutput?
    
    var fPNService: FPNService = FPNService()
    
    init() {
        fPNService.closureIndexCountry = { [weak self] index in
            self?.outPut?.transferIndex(index)
        }
        
        fPNService.closureValidation = { [weak self] isValid in
            self?.outPut?.validation(isValid: isValid)
        }
    }
    
    func verification() {
        guard let phoneString = fPNService.fpnTextFildd.getFormattedPhoneNumber(format: .International) else { return }
        
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneString, uiDelegate: nil) { [weak self] (verificationID, error) in
            if error != nil {
                print(error?.localizedDescription ?? "is empty")
                
            } else {
                guard let verificationID = verificationID else { return }
                self?.outPut?.successVerification(verificationID: verificationID, numberPhone: phoneString, typeAuthorization: .logIn)
                print(phoneString)
            }
        }
    }
    
    func requestFullNumber(phone: String) {
        fPNService.fpnTextFildd.text = phone
        fPNService.fpnTextFildd.didEditText()
    }
    
    func showListController() {
        let list = fPNService.listCotroller
        outPut?.showListController(listController: list)
    }
    
    func transferData() {
        let country = fPNService.fpnTextFildd.countryRepository.countries
        outPut?.transferData(data: country)
    }
    
    func convertContryToPhoneNumber(_ country: FPNCountry) {
        fPNService.fpnTextFildd.setFlag(countryCode: country.code)
        
        guard let typePhone = fPNService.fpnTextFildd.placeholder else { return }
        outPut?.sendTypePhone(typePhone)
    }
}


