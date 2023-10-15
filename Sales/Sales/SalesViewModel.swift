//
//  SalesViewModel.swift
//  Sales
//
//  Created by Sunil Simon on 14/10/23.
//

import Foundation
import RealmSwift
public protocol SalesModelViewDelegate: AnyObject{
    func getSearcText()->String?
}
class SalesViewModel{
    
    public weak var salesModelViewDelegate : SalesModelViewDelegate?
    let requestHandler = URLRequestHandler.shared
    let dbHandler = DBHandler.shared
    var filteredSales  : Sales?
    {
        didSet
        {
            listModifiedBindingNotifier()
        }
    }
    var listModifiedBindingNotifier : (() -> ()) = {}
    var loginState : LoginState
    {
        didSet
        {
            loginStateChangedBindingNotifier()
        }
    }
    var loginStateChangedBindingNotifier : (() -> ()) = {}
    
    init() {
        loginState = .LOGGEDIN
        applyFilter()
    }
    func applyFilter()
    {
        let queue = DispatchQueue(label: "com.simon.ios.customqueue")
        queue.sync {
            
            let searchText = salesModelViewDelegate?.getSearcText()
            let documents = dbHandler.readDB(type: Document.self)
            guard documents != nil else{
                return
            }
            let allSales = Sales(documents: documents!)
            guard searchText != nil else{
                filteredSales = allSales
                return
            }
            guard searchText! != "" else{
                filteredSales = allSales
                return
            }

            let filteredDocumentList = List<Document>()
            let escapedDocumentList = List<Document>()

            let predicate1 = NSPredicate(format: "SELF BEGINSWITH[c] %@", searchText!)
            for document in allSales.documents
            {
                if (predicate1.evaluate(with:(document.customer.email)))
                {
                    filteredDocumentList.append(document)
                }
                else{
                    escapedDocumentList.append(document)
                }
            }
            let predicate2 = NSPredicate(format: "SELF CONTAINS[c] %@", searchText!)
            for document in escapedDocumentList
            {
                if (predicate2.evaluate(with:(document.customer.email)))
                {
                    filteredDocumentList.append(document)
                }
            }
            self.filteredSales?.documents = filteredDocumentList
            DispatchQueue.main.async {
                self.filteredSales = self.filteredSales
            }

        }
    }
    func logMeOut()
    {
        self.dbHandler.deleteDB(completion: {[weak self] (_) in
            KeychainService.clearUserKeyChainCredentials(service: KeychainService.userEnvironmentservice, account: KeychainService.account)
            self?.loginState = .NOTLOGGEDIN
        })
    }
}
