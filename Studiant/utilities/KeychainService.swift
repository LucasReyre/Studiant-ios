import Foundation
import Security

// Constant Identifiers
let userAccount = "AuthenticatedUser"
let accessGroup = "SecuritySerivice"


/**
 *  User defined keys for new entry
 *  Note: add new keys for new secure item and use them in load and save methods
 */

let passwordKey = "KeyForPassword"

let idUserKey = "idUserKey"
let typeUtilisateurKey = "typeUtilisateurKey"
let idMangoPayUtilisateurKey = "idMangoPayUtilisateurKey"
let photoUtilisateurKey = "photoUtilisateurKey"
let nomUtilisateurKey = "nomUtilisateurKey"
let prenomUtilisateurKey = "prenomUtilisateurKey"
let diplomeUtilisateurKey = "diplomeUtilisateurKey"
let mailUtilisateurKey = "mailUtilisateurKey"

// Arguments for the keychain queries
let kSecClassValue = NSString(format: kSecClass)
let kSecAttrAccountValue = NSString(format: kSecAttrAccount)
let kSecValueDataValue = NSString(format: kSecValueData)
let kSecClassGenericPasswordValue = NSString(format: kSecClassGenericPassword)
let kSecAttrServiceValue = NSString(format: kSecAttrService)
let kSecMatchLimitValue = NSString(format: kSecMatchLimit)
let kSecReturnDataValue = NSString(format: kSecReturnData)
let kSecMatchLimitOneValue = NSString(format: kSecMatchLimitOne)

public class KeychainService: NSObject {
    
    /**
     * Exposed methods to perform save and load queries.
     */
    
    public class func savePassword(token: NSString) {
        self.save(service: passwordKey as NSString, data: token)
    }
    
    public class func loadPassword() -> NSString? {
        return self.load(service: passwordKey as NSString)
    }
    
    public class func saveUser(user: User){
        self.save(service: idUserKey as NSString, data: user.idUtilisateur! as NSString)
        if user.nomUtilisateur != nil {
            let nomUtilisateur = String(describing: user.nomUtilisateur!)
            self.save(service: nomUtilisateurKey as NSString, data: nomUtilisateur as NSString)
        }
        if user.prenomUtilisateur != nil {
            let prenomUtilisateur = String(describing: user.prenomUtilisateur!)
            self.save(service: prenomUtilisateurKey as NSString, data: prenomUtilisateur as NSString)
        }
        if user.diplomeUtilisateur != nil {
            let diplomeUtilisateur = String(describing: user.diplomeUtilisateur!)
            self.save(service: diplomeUtilisateurKey as NSString, data: diplomeUtilisateur as NSString)
        }
        if user.typeUtilisateur != nil {
            let typeUtilisateur = String(describing: user.typeUtilisateur!)
            self.save(service: typeUtilisateurKey as NSString, data: typeUtilisateur as NSString)
        }
        if user.idMangoPayUtilisateur != nil {
            let idMangoPayUtilisateur = String(describing: user.idMangoPayUtilisateur!)
            self.save(service: idMangoPayUtilisateurKey as NSString, data: idMangoPayUtilisateur as NSString)
        }
        if user.photoUtilisateur != nil {
            let photoUtilisateur = String(describing: user.photoUtilisateur!)
            self.save(service: photoUtilisateurKey as NSString, data: photoUtilisateur as NSString)
        }
        
        if user.mailUtilisateur != nil {
            let mailUtilisateur = String(describing: user.mailUtilisateur!)
            self.save(service: mailUtilisateurKey as NSString, data: mailUtilisateur as NSString)
        }
    }
    
    public class func loadUser() -> User! {
        let user = User()
        if let idUtilisateur = self.load(service: idUserKey as String as NSString){
                user.idUtilisateur = idUtilisateur as String
        }
        if let typeUtilisateur = self.load(service: typeUtilisateurKey as String as NSString){
                user.typeUtilisateur = Int(typeUtilisateur as String)
        }
        if let idMangoPayUtilisateur = self.load(service: idMangoPayUtilisateurKey as String as NSString){
            user.idMangoPayUtilisateur = idMangoPayUtilisateur as String
        }
        
        if let photoUtilisateur = self.load(service: photoUtilisateurKey as String as NSString){
            user.photoUtilisateur = photoUtilisateur as String
        }
        if let nomUtilisateur = self.load(service: nomUtilisateurKey as String as NSString){
            user.nomUtilisateur = nomUtilisateur as String
        }
        if let prenomUtilisateur = self.load(service: prenomUtilisateurKey as String as NSString){
            user.prenomUtilisateur = prenomUtilisateur as String
        }
        if let diplomeUtilisateur = self.load(service: diplomeUtilisateurKey as String as NSString){
            user.diplomeUtilisateur = diplomeUtilisateur as String
        }
        if let mailUtilisateur = self.load(service: mailUtilisateurKey as String as NSString){
            user.mailUtilisateur = mailUtilisateur as String
        }
        return user
    }
    
    public class func deleteAll(){
        self.delete(service: idUserKey as NSString)
        self.delete(service: typeUtilisateurKey as NSString)
        self.delete(service: photoUtilisateurKey as NSString)
    }
    
    /**
     * Internal methods for querying the keychain.
     */
    
    private class func save(service: NSString, data: NSString) {
        let dataFromString: NSData = data.data(using: String.Encoding.utf8.rawValue, allowLossyConversion: false)! as NSData
        
        // Instantiate a new default keychain query
        let keychainQuery: NSMutableDictionary = NSMutableDictionary(objects: [kSecClassGenericPasswordValue, service, userAccount, dataFromString], forKeys: [kSecClassValue, kSecAttrServiceValue, kSecAttrAccountValue, kSecValueDataValue])
        
        // Delete any existing items
        SecItemDelete(keychainQuery as CFDictionary)
        
        // Add the new keychain item
        SecItemAdd(keychainQuery as CFDictionary, nil)
    }
    
    private class func delete(service: NSString){
        // Instantiate a new default keychain query
        let keychainQuery: NSMutableDictionary = NSMutableDictionary(objects: [kSecClassGenericPasswordValue, service, userAccount], forKeys: [kSecClassValue, kSecAttrServiceValue, kSecAttrAccountValue])
        
        SecItemDelete(keychainQuery as CFDictionary)
    }
    
    private class func load(service: NSString) -> NSString? {
        // Instantiate a new default keychain query
        // Tell the query to return a result
        // Limit our results to one item
        let keychainQuery: NSMutableDictionary = NSMutableDictionary(objects: [kSecClassGenericPasswordValue, service, userAccount, kCFBooleanTrue, kSecMatchLimitOneValue], forKeys: [kSecClassValue, kSecAttrServiceValue, kSecAttrAccountValue, kSecReturnDataValue, kSecMatchLimitValue])
        
        var dataTypeRef :AnyObject?
        
        // Search for the keychain items
        let status: OSStatus = SecItemCopyMatching(keychainQuery, &dataTypeRef)
        var contentsOfKeychain: NSString? = nil
        
        if status == errSecSuccess {
            if let retrievedData = dataTypeRef as? NSData {
                contentsOfKeychain = NSString(data: retrievedData as Data, encoding: String.Encoding.utf8.rawValue)
            }
        } else {
            print("Nothing was retrieved from the keychain. Status code \(status)")
        }
        
        return contentsOfKeychain
    }
}
