
import Foundation
import Firebase
import FirebaseAuth
import FlagPhoneNumber

protocol CheckCodeInteractorInput {
    func attemptCheckCode(withVerificationID: String, verificationCode: String)
}

protocol CheckCodeInteractorOutput {
    func errorAthorization(description tittle: String)
    func succesAuthorization()
}

class InteractorCheckCode: CheckCodeInteractorInput {
    
    var outPut: CheckCodeInteractorOutput?
    
    func attemptCheckCode(withVerificationID: String, verificationCode: String) {
        
        let credetional = PhoneAuthProvider.provider().credential(withVerificationID: withVerificationID, verificationCode: verificationCode)
        
        Auth.auth().signIn(with: credetional) { [weak self] (_, error) in
            if error != nil {
                self?.outPut?.errorAthorization(description: error?.localizedDescription ?? "")
            } else {
                self?.outPut?.succesAuthorization()
            }
        }
    }
}
