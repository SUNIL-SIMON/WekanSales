//
//  DBHandler.swift
//  Sales
//
//  Created by Sunil Simon on 14/10/23.
//

import Foundation
import RealmSwift
import Realm
class DBHandler
{
    public static var shared = DBHandler()
    
    var config : Realm.Configuration!
    
    init()
    {
        config = Realm.Configuration(encryptionKey: getKey())
    }
    
    func writeDB<T:Object>(items: List<T>?, completion: @escaping ( (Bool) -> ()))
    {
        guard items != nil else {return}
        do{
            let realmDB = try Realm(configuration: config)
            try! realmDB.write {
                for item in items!{
                    realmDB.add(item)
                }
            }
        }
        catch{
            print("DB WRITE Error info: \(error)")
        }

    }
    func readDB<T:Object>(type : T.Type)->List<T>?
    {
        do{
            let realmDB = try Realm(configuration: config)
            let realmObjects = realmDB.objects(type)
            print("file url = ",Realm.Configuration.defaultConfiguration.fileURL ?? "")
            var respList = List<T>()
            _ = realmObjects.reduce(List<T>()) { (list, element) -> List<T> in
                list.append(element)
                respList = list
                return list
            }
            return respList
        }
        catch{
            print("DB READ Error info: \(error)")
        }
        return nil
    }
    
    func deleteDB(completion: @escaping ( (Bool) -> ()))
    {
        do{
            let realmDB = try Realm(configuration: config)
            try! realmDB.write {
                realmDB.deleteAll()
            }
        }
        catch{
            print("DB Delete Error info: \(error)")
        }
        completion(true)
    }
    
    func getKey() -> Data {
        
        let keychainIdentifier = "com.simon.ios.realmdb"
        let keychainIdentifierData = keychainIdentifier.data(using: String.Encoding.utf8, allowLossyConversion: false)!
        var query: [NSString: AnyObject] = [
            kSecClass: kSecClassKey,
            kSecAttrApplicationTag: keychainIdentifierData as AnyObject,
            kSecAttrKeySizeInBits: 512 as AnyObject,
            kSecReturnData: true as AnyObject
        ]

        var dataTypeRef: AnyObject?
        var status = withUnsafeMutablePointer(to: &dataTypeRef) { SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer($0)) }
        if status == errSecSuccess {
            return dataTypeRef as! Data
        }

        var key = Data(count: 64)
        key.withUnsafeMutableBytes({ (pointer: UnsafeMutableRawBufferPointer) in
            let result = SecRandomCopyBytes(kSecRandomDefault, 64, pointer.baseAddress!)
            assert(result == 0, "Failed to get random bytes")
        })

        query = [
            kSecClass: kSecClassKey,
            kSecAttrApplicationTag: keychainIdentifierData as AnyObject,
            kSecAttrKeySizeInBits: 512 as AnyObject,
            kSecValueData: key as AnyObject
        ]
        status = SecItemAdd(query as CFDictionary, nil)
        assert(status == errSecSuccess, "Failed to insert the new key in the keychain")
        
        return key
    }
}
