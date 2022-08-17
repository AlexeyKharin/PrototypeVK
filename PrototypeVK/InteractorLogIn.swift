
import Foundation
import FlagPhoneNumber
import Firebase
import FirebaseAuth

class InteractorLogIn: LogInInteractorInput {
    
    weak var outPut: LogInInteractorOutput?
    
    var fPNService: FPNService = FPNService()
    
    init() {
        fPNService.closureIndexCountry = { [weak self] index in
            self?.outPut?.transferIndex(index)
        }
        
        fPNService.closureValidation = { [weak self] isValid in
            self?.outPut?.validation(isValid: isValid)
        }
    }
    
    
    func prepareArrayOfCountries() -> [CountryType]? {
        
        let countries = fPNService.fpnTextFildd.countryRepository.countries.map { CountryType(
            name: $0.name,
            phoneCode: $0.phoneCode,
            flag: UIImage(named: $0.code.rawValue, in: Bundle.FlagIcons, compatibleWith: nil),
            code: $0.code.rawValue )
        }
        
        return countries
        
    }
    
    func verification() {
        guard let phoneString = fPNService.fpnTextFildd.getFormattedPhoneNumber(format: .International) else { return }
        
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneString, uiDelegate: nil) { [weak self] (verificationID, error) in
            if error != nil {
                print(error?.localizedDescription ?? "is empty")
                
            } else {
                guard let verificationID = verificationID else { return }
                self?.outPut?.successVerification(verificationID: verificationID, numberPhone: phoneString, typeAuthorization: .sigIn)
                print(phoneString)
                
            }
        }
    }
    
    func requestFullNumber(phone: String, country: CountryType) {
        fPNService.fpnTextFildd.text = phone
        let fpnCountry = fPNService.fpnTextFildd.countryRepository.countries.first(where: { $0.name == country.name } )
        fPNService.fpnTextFildd.selectedCountry = fpnCountry
    }
    
    func showListController() {
        let list = fPNService.listCotroller
        outPut?.showListController(listController: list)
    }
    
    func convertContryToPhoneNumber(_ country: CountryType) {
        guard let fpnCode = FPNCountryCode(rawValue: country.code) else { return }
        fPNService.fpnTextFildd.setFlag(countryCode: fpnCode)
        
        guard let typePhone = fPNService.fpnTextFildd.placeholder else { return }
        outPut?.sendTypePhone(typePhone)
    }
}
