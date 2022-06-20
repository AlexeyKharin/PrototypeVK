
import Foundation
import FlagPhoneNumber

class FPNService: NSObject, UITextFieldDelegate {
    
    var closureIndexCountry: ((Int) -> Void)?
    var closureValidation: ((Bool) -> Void)?
    
    var listCotroller: FPNCountryListViewController = {
        let listCountry = FPNCountryListViewController(style: .grouped)
        listCountry.title = NSLocalizedString("Countries", comment: "")
        return listCountry
    }()
    
    lazy var fpnTextFildd: FPNTextField = {
        let fpnTextFildd = FPNTextField()
        fpnTextFildd.delegate = self
        fpnTextFildd.displayMode = .list
        return fpnTextFildd
    }()
    
    override init() {
        super.init()
        
        fpnTextFildd.delegate = self
        listCotroller.setup(repository: fpnTextFildd.countryRepository)
        
        listCotroller.didSelect = { [weak self] country in
            self?.fpnTextFildd.setFlag(countryCode: country.code)
            
            let array = self?.fpnTextFildd.countryRepository.countries
            if let currentIndex = array?.firstIndex(of: country) {
                let index: Int = Int(currentIndex)
        
                self?.closureIndexCountry?(index)
            }
        }
    }
}

extension FPNService: FPNTextFieldDelegate {
    
    func fpnDidSelectCountry(name: String, dialCode: String, code: String) { }
    
    func fpnDidValidatePhoneNumber(textField: FPNTextField, isValid: Bool) {
        print(textField.text)
        print(textField.phoneCodeTextField.text)
        closureValidation?(isValid)
    }
    
    func fpnDisplayCountryList() { }
}

