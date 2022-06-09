
import Foundation
import LocalAuthentication
import UIKit

enum ObtainResult: Error {
    case failure(error: Error)
    case success(result: Bool)
    case featureFailure
}

enum BiometryType {
    case faceId
    case touchId
    case dontSupportBiometry
}

class LocalAuthorizationService {
    
    // Контекст LocalAuthentication
    private let laContext = LAContext()
    
    // Получатель ошибок
    private var error: NSError?
    
    func authorizeIfPossible(_ authorizetionFinished: @escaping(ObtainResult) -> Void) {
        // Проверка на доступ к биометрии
        if laContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            
            laContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "To acces data") { (succes, error) in
                if let error = error {
                    print("Try another method, \(error.localizedDescription)")
                    authorizetionFinished(.failure(error: error))
                    return
                }
                
                authorizetionFinished(.success(result: succes))
            }
        } else {
            authorizetionFinished(.featureFailure)
        }
    }
    
    private func supportedBiometryType() -> BiometryType {
        var type: BiometryType = .dontSupportBiometry
        
        if laContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            
            switch laContext.biometryType.rawValue {
            case 1:
                type = .touchId
            case 2:
                type = .faceId
            default:
                type = .dontSupportBiometry
            }
        }
        
        return type
    }
    
    func biometryImage() -> UIImage {
        
        var type: BiometryType = supportedBiometryType()
        
        switch type {
        
        case .dontSupportBiometry:
            return UIImage(systemName: "stop.circle.fill") ?? UIImage()
            
        case .faceId:
            return UIImage(systemName: "faceid") ?? UIImage()
            
        case .touchId:
            return UIImage(systemName: "touchid") ?? UIImage()
        }
    }
}
