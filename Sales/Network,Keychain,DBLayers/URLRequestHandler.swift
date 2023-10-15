//
//  NetworkLayer.swift
//  Sales
//
//  Created by Sunil Simon on 14/10/23.
//

import Foundation

enum APIResponceStatus : Error
{
    case SUCCESS
    case BADRESPONSE
    case BADREQUEST
    case DECODEFAILED
}

class URLRequestHandler
{
    public static var shared = URLRequestHandler()
    
    var task: URLSessionDataTask?
    var session = URLSession.shared
    
    func sendRequest<T:Decodable>(type:T.Type, request: URLRequest, completion: @escaping ( (T?,APIResponceStatus) -> ()))
    {
        self.task = self.session.dataTask(with: request, completionHandler: { (data, response, error)  in
            if data != nil {
                do{
                    let result = try JSONDecoder().decode(type, from: data!)
                    completion(result,.SUCCESS)
                }
                catch{
                    print("API RESP Decode Error info: \(error)")
                    completion(nil,.DECODEFAILED)
                }
            }
            else{
                completion(nil,.BADRESPONSE)
            }
        })
        self.task?.resume()
    }

}
