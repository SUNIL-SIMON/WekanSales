//
//  KeyChainsHandler.swift
//  Sales
//
//  Created by Sunil Simon on 15/10/23.
//

import Foundation
import Security

public let kSecClassValue = NSString(format: kSecClass)
public let kSecAttrAccountValue = NSString(format: kSecAttrAccount)
public let kSecValueDataValue = NSString(format: kSecValueData)
public let kSecClassGenericPasswordValue = NSString(format: kSecClassGenericPassword)
public let kSecAttrServiceValue = NSString(format: kSecAttrService)
public let kSecMatchLimitValue = NSString(format: kSecMatchLimit)
public let kSecReturnDataValue = NSString(format: kSecReturnData)
public let kSecMatchLimitOneValue = NSString(format: kSecMatchLimitOne)

public class KeychainService: NSObject {
    public static let userEnvironmentservice = "com.simon.ios.sharedKeychain.userEnvironment"
    public static let account = "com.simon.ios.sharedKeychain.account"
    public static let shared = KeychainService()
    class func saveKeyChainData(service: String, account:String, data: String) {
        if let dataFromString = data.data(using: String.Encoding.utf8, allowLossyConversion: false) {
            
            // Instantiate a new default keychain query
            let keychainQuery: NSMutableDictionary = NSMutableDictionary(objects: [kSecClassGenericPasswordValue, service, account, dataFromString], forKeys: [kSecClassValue, kSecAttrServiceValue, kSecAttrAccountValue, kSecValueDataValue])
            
            // Add the new keychain item
            let status = SecItemAdd(keychainQuery as CFDictionary, nil)
            
            if (status != errSecSuccess) {    // Always check the status
                if let err = SecCopyErrorMessageString(status, nil) {
                    print("keychain Write failed: \(err)")
                }
            }
        }
    }
    class func updateKeyChainData(service: String, account:String, data: String) {
        
        if let dataFromString: Data = data.data(using: String.Encoding.utf8, allowLossyConversion: false) {
            
            // Instantiate a new default keychain query
            let keychainQuery: NSMutableDictionary = NSMutableDictionary(objects: [kSecClassGenericPasswordValue, service, account], forKeys: [kSecClassValue, kSecAttrServiceValue, kSecAttrAccountValue])
            
            let status = SecItemUpdate(keychainQuery as CFDictionary, [kSecValueDataValue:dataFromString] as CFDictionary)
            
            if (status != errSecSuccess) {
                if let err = SecCopyErrorMessageString(status, nil) {
                    print("keychain update failed: \(err)")
                }
            }
        }
    }
    class func loadKeyChainData(service: String, account:String) -> String? {
        // Instantiate a new default keychain query
        // Tell the query to return a result
        // Limit our results to one item
        let keychainQuery: NSMutableDictionary = NSMutableDictionary(objects: [kSecClassGenericPasswordValue, service, account, kCFBooleanTrue!, kSecMatchLimitOneValue], forKeys: [kSecClassValue, kSecAttrServiceValue, kSecAttrAccountValue, kSecReturnDataValue, kSecMatchLimitValue])
        
        var dataTypeRef :AnyObject?
        
        // Search for the keychain items
        let status: OSStatus = SecItemCopyMatching(keychainQuery, &dataTypeRef)
        var contentsOfKeychain: String?
        
        if status == errSecSuccess {
            if let retrievedData = dataTypeRef as? Data {
                contentsOfKeychain = String(data: retrievedData, encoding: String.Encoding.utf8)
            }
        } else {
            print("Nothing was retrieved from the keychain. Status code \(status)")
        }
        
        return contentsOfKeychain
    }
    class func removeKeyChainData(service: String, account:String) {
        
        // Instantiate a new default keychain query
        let keychainQuery: NSMutableDictionary = NSMutableDictionary(objects: [kSecClassGenericPasswordValue, service, account, kCFBooleanTrue!], forKeys: [kSecClassValue, kSecAttrServiceValue, kSecAttrAccountValue, kSecReturnDataValue])
        
        // Delete any existing items
        let status = SecItemDelete(keychainQuery as CFDictionary)
        if (status != errSecSuccess) {
            if let err = SecCopyErrorMessageString(status, nil) {
                print("keychain Remove failed: \(err)")
            }
        }
        
    }

    class func getUserKeyChainCredentials(service: String, account:String)->String?
    {
        var userData : String?
        if let str = KeychainService.loadKeyChainData(service: service, account: account) {
            userData = str
        }
        return userData
    }
    class func clearUserKeyChainCredentials(service: String, account:String)
    {
        KeychainService.removeKeyChainData(service: service, account: account)
    }
}
