//
//  LocalAuthorizationService.swift
//  iosadv-8
//
//  Created by Dmitrii Lobanov on 16.06.2022.
//

import Foundation
import LocalAuthentication

enum BioAuth {
    case faceID
    case touchID
    case none
}

class LocalAuthorizationService {
    
    // Заглушка для сервиса авторизации по логин/паролю
    var login: String = "123"
    var password: String = "123"
    
    let context = LAContext()
    var error: NSError?
    
    // Метод проверки на возможность использовать авторизацию по биометрии
    func checkBioAuthPossibility() -> BioAuth {
        
        // context.biometryType.rawValue (2 - faceID, 1 - touchID)
        
        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else { return BioAuth.none}
        
        switch context.biometryType.rawValue {
        case 2:
            return BioAuth.faceID
        case 1:
            return BioAuth.touchID
        default:
            return BioAuth.none
        }
    }
    
    func authorizeIfPossible(_ authorizationFinished: @escaping (Bool) -> Void) {
        
        // Текст для TouchID (текст для FaceID задается в info.plist)
        let reason = "Хотите использовать Touch ID для авторизации?"
        
        // Вызов биометрии
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
            
            if success {
                authorizationFinished(success)
            }
        }
    }
    
    func authorizationFinished() -> Bool {
        return true
    }
    
    // метод проверки логина и пароля (заглушка)
    func loginSuccess(login: String, password: String) -> Bool {
        
        if login == self.login && password == self.password {
            return true
        } else {
            return false
        }
    }
}
