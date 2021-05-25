//
//  UserDefaultHelpers.swift
//  Athany
//
//  Created by Seif Kobrosly on 1/21/21.
//

import Foundation

enum AuthState: Int {
    case loggedOut = 0
    case timedOutSession
    case validSession
    case noPIN
    case verifyPIN
    case verificationFailed
    case biometricsEnabled
    case biometricsCanceled
    case pinCreated // 8
    case wrongPIN
    case passwordExpired
    case locallyAuthenticated // 11
    case authAndSynched
    case authenticating
    case authenticationCancelled
}

protocol UserDefaultsProtocol {
    func save(state: AuthState)
    func save(code: String, date: Date)
    func save(failedAttempts: Int)
    func save(biometricEnabled: Bool)
    func save(hasRan: Bool)
    func save(isVerified: Bool)
    func save(fourteenDayExpiries: [String])
    func retrieveAuthState() -> AuthState
    func retrievePIN() -> (password: String, passwordDate: Date)
    func retrieveFailedAttempts() -> Int
    func retrieveBiometrics() -> Bool
    func retrieveHasRan() -> Bool
    func retrieveIsVerified() -> Bool
    func retrieveFourteenDayExpiries() -> [String]
    func addToFavoriteContacts(contactId: String)
    func removeFromFavoriteContacts(contactId: String)
    func isFavoriteContact(contactId: String) -> Bool
    func addToDeprioritizedAutoFavoriteContacts(contactId: String)
    func removeFromDeprioritizedAutoFavoriteContacts(contactId: String)
    func isDeprioritizedAutoFavoritedContact(contactId: String) -> Bool
    func isPasswordExpired() -> Bool
    func clearSSOCookies() -> Bool
    func resetDefaults()
}
extension UserDefaultsProtocol {
    func isPasswordExpired() -> Bool {
        let passwordCreationDate = self.retrievePIN().passwordDate
        let intervalToNow = Calendar.current.dateComponents([.day], from: passwordCreationDate, to: Date().localDate())
        let dayCount = intervalToNow.day ?? 0
        return dayCount > 89
    }
}

/// Enum to save and retrieve user defaults
final class UserDefaultsHelper: UserDefaultsProtocol {
    /// Function that saves the local authentication state so the state machine configures the screen to display the proper auth step
    /// - parameter state: the last auth step that the user reached and completed successfully
    func save(state: AuthState) {
        let stateString = "\(state.rawValue)"
        let keychain = KeychainSwift()
        keychain.set(stateString, forKey: "loginStatus")
    }
    
    /// Function that saves the pin code the user selected
    /// - parameter code: password needed to locally authenticate
    /// - parameter date: password date.  To keep track if it is more than 90 days.
    func save(code: String, date: Date) {
        let keychain = KeychainSwift()
        keychain.set(code, forKey: "authPIN")
        if let data = try? PropertyListEncoder().encode(DateHolder(date: date)) {
            keychain.set(data, forKey: "authPINDate")
        }
    }

    /// Function that saves the number of failed login attemps since last succesful login
    /// - parameter failedAttemps: the number of attempts
    func save(failedAttempts: Int) {
        let keychain = KeychainSwift()
        let failedAttemptsString = "\(failedAttempts)"
        keychain.set(failedAttemptsString, forKey: "failedAttemps")
    }

    /// Function that saves if the user wants to use biometric login
    /// - parameter bioemetricEnabled: should we use biometric login or not
    func save(biometricEnabled: Bool) {
        UserDefaults.standard.set(biometricEnabled, forKey: "useBiometrics")
    }

    /// Function that saves if the app is on its first launch
    /// - parameter hasRan: is it app's first launch... will be used to clear the keyRing would the app be deleted and reinstalled
    func save(hasRan: Bool) {
        UserDefaults.standard.set(hasRan, forKey: "hasRan")
    }

    /// Function that saves if the password was ever verified
    /// - parameter isVerified: was the password verified
    func save(isVerified: Bool) {
        UserDefaults.standard.set(isVerified, forKey: "isVerified")
    }
    
    /// Function that saves guids of secure documents unuploaded after fourteen days
    /// - parameter fourteenDayExpiries: array of guids
    func save(fourteenDayExpiries: [String]) {
        UserDefaults.standard.set(fourteenDayExpiries, forKey: "fourteenDayExpiries")
    }
    
    /// Function that retrieves the local authentication state so the state machine configures the screen to display the proper auth step
    /// - returns: last authentication state step reached
    func retrieveAuthState() -> AuthState {
        let keychain = KeychainSwift()
        if let receivedData = keychain.get("loginStatus") {
            let stringState = receivedData
            guard let intState = Int(stringState) else { return AuthState.loggedOut }
            guard let state: AuthState = AuthState(rawValue: intState) else { return AuthState.loggedOut }
            return state
        }
        return AuthState.loggedOut
    }

    /// Function that retrieves the pin code the user selected
    /// - returns: a tuple composed of the pin code user selected and the date at which it was set
    func retrievePIN() -> (password: String, passwordDate: Date) {
        let keychain = KeychainSwift()
        let password = keychain.get("authPIN") ?? ""
        var date: Date?
        if let data = keychain.getData("authPINDate") {
            date = try? PropertyListDecoder().decode(DateHolder.self, from: data).date
        }
        return (password: password, passwordDate: date ?? Date.now)
    }

    /// Function that retrieves the number of failed login attemps
    /// - returns: the number of failed attemps since last successful login
    func retrieveFailedAttempts() -> Int {
        let keychain = KeychainSwift()
        if let receivedData = keychain.get("failedAttemps") {
            return Int(receivedData) ?? 0
        }
        return 0
    }

    /// Function that retrieves if the user wants to use biometric login
    /// - returns: if biometric login should be used
    func retrieveBiometrics() -> Bool {
        return UserDefaults.standard.bool(forKey: "useBiometrics")
    }

    /// Function that retrieves if the app is on its first launch
    /// - returns: if the app has launched at least once
    func retrieveHasRan() -> Bool {
        return UserDefaults.standard.bool(forKey: "hasRan")
    }

    /// Function that retrieves if the password was ever verified
    /// - returns: if the password was ever verified
    func retrieveIsVerified() -> Bool {
        return UserDefaults.standard.bool(forKey: "isVerified")
    }
    
    /// Function that retrieves guids of secure documents unuploaded after fourteen days
    /// - returns: array of guids
    func retrieveFourteenDayExpiries() -> [String] {
        let array = UserDefaults.standard.array(forKey: "fourteenDayExpiries")
        return array as? [String] ?? []
    }
    
    /// Function that adds a contact to favorites... it cannot be saved on the backend so we store locally
    /// - parameter contactId: Id to the contact we want to save as favorite
    func addToFavoriteContacts(contactId: String) {
        var currentFavorites = UserDefaults.standard.array(forKey: "favoriteContacts")
        if currentFavorites == nil {
            var newFavoritesArray: [String] = []
            newFavoritesArray.append(contactId)
            UserDefaults.standard.set(newFavoritesArray, forKey: "favoriteContacts")
        } else {
            currentFavorites?.append(contactId)
            UserDefaults.standard.set(currentFavorites, forKey: "favoriteContacts")
        }
    }
    
    /// Function that removes a contact from favorites... This cannot be saved on the backend so we store locally
    /// - parameter contactId: Id to the contact we want to remove from favorite
    func removeFromFavoriteContacts(contactId: String) {
        var currentFavorites = UserDefaults.standard.array(forKey: "favoriteContacts") as? [String]
        currentFavorites = currentFavorites?.filter { $0 != contactId }
        UserDefaults.standard.set(currentFavorites, forKey: "favoriteContacts")
    }
    
    /// Function that retrieves if a contact is stored locally as a favorite
    /// - parameter contactId: Id to the contact we want to remove from favorite
    /// - returns: if contact is a favorite
    func isFavoriteContact(contactId: String) -> Bool {
        let currentFavorites = UserDefaults.standard.array(forKey: "favoriteContacts") as? [String]
        let favoriteFilteredOut = currentFavorites?.filter { $0 != contactId }
        return currentFavorites?.count != favoriteFilteredOut?.count
    }
    
    /// Function that adds a contact to the list of deprioritized auto favorited contacts... Study Coordinator, Principal Investigator, Pharmacist roles are auto favorited
    /// - parameter contactId: Id to the contact we want to save as favorite
    func addToDeprioritizedAutoFavoriteContacts(contactId: String) {
        var currentFavorites = UserDefaults.standard.array(forKey: "deprioritizedAutoFavoriteContacts")
        if currentFavorites == nil {
            var newFavoritesArray: [String] = []
            newFavoritesArray.append(contactId)
            UserDefaults.standard.set(newFavoritesArray, forKey: "deprioritizedAutoFavoriteContacts")
        } else {
            currentFavorites?.append(contactId)
            UserDefaults.standard.set(currentFavorites, forKey: "deprioritizedAutoFavoriteContacts")
        }
    }
    
    /// Function that removes a contact from the list of deprioritized auto favorited contacts... Study Coordinator, Principal Investigator, Pharmacist roles are auto favorited
    /// - parameter contactId: Id to the contact we want to remove from favorite
    func removeFromDeprioritizedAutoFavoriteContacts(contactId: String) {
        var currentFavorites = UserDefaults.standard.array(forKey: "deprioritizedAutoFavoriteContacts") as? [String]
        currentFavorites = currentFavorites?.filter { $0 != contactId }
        UserDefaults.standard.set(currentFavorites, forKey: "deprioritizedAutoFavoriteContacts")
    }
    
    /// Function that retrieves if a contact is stored locally as a deprioritized auto favorite
    /// - parameter contactId: Id to the contact we want to remove from favorite
    /// - returns: if contact is a favorite
    func isDeprioritizedAutoFavoritedContact(contactId: String) -> Bool {
        let currentDeprioritizedAutoFavorites = UserDefaults.standard.array(forKey: "deprioritizedAutoFavoriteContacts") as? [String]
        let deprioritizedFavoriteFilteredOut = currentDeprioritizedAutoFavorites?.filter { $0 != contactId }
        return currentDeprioritizedAutoFavorites?.count != deprioritizedFavoriteFilteredOut?.count
    }
    
    //// Function that resets the keys saved
    func resetDefaults() {
        let keychain = KeychainSwift()
        keychain.delete("authPin")
        UserDefaults().removeObject(forKey: "failedAttempts")
        UserDefaults().removeObject(forKey: "state")
        UserDefaults().removeObject(forKey: "biometricEnabled")
        UserDefaults().removeObject(forKey: "hasRan")
        UserDefaults().removeObject(forKey: "favoriteContacts")
        UserDefaults().removeObject(forKey: "deprioritizedAutoFavoriteContacts")
        UserDefaults().removeObject(forKey: "fourteenDayExpiries")
        UserDefaults().synchronize()
        
        UserAccountManager().logout()
        UserAccountManager().switchToUserAccount(nil)
        UserAccountManager.shared.clearAllAccountState()
        RestClient.shared.cleanup()
        SalesforceManager.shared.bootConfig?.shouldAuthenticateOnFirstLaunch = true
    }
    
    /// Function that removes any PRA SSO Cookies
    func clearSSOCookies() -> Bool {
        var removedCookie = false
        DispatchQueue.main.async {
            let dataStore = WKWebsiteDataStore.default()
            dataStore.fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { (records) in
                for record in records {
                    if record.displayName.contains("microsoftonline") {
                        dataStore.removeData(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes(), for: [record], completionHandler: {
                            removedCookie = true
                        })
                    }
                }
            }
        }
    
        return removedCookie
    }
    
}

