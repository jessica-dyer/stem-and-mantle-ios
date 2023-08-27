//
//  Network.swift
//
//  Created by Rob Busack on 7/22/2020.
//  Copyright © 2020 General UI. All rights reserved.
//

import Foundation

///////////////////////////////////////////////////////////////////////////////////////////////////
// this class exists just to create the "Network" namespace, it only contains static functions and should not be instantiated
class Network {
    
    static let WEB_CALL_STARTED = Notification.Name("WEB_CALL_STARTED")
    
    enum HTTPMethod: String {
        case GET = "GET"
        case PUT = "PUT"
        case POST = "POST"
    }
    
    static func call(httpMethod: HTTPMethod, fullUrlString urlString: String, headers customHeaders: [String:String]? = nil, httpBody: Data? = nil, completion: @escaping( _ data : Data?, _ : HTTPURLResponse?, _ : Error? ) -> Void  )
    {
        guard let url = URL(string:urlString) else {
            completion( nil, nil, NetworkError.invalidUrl(url: urlString))
            return
        }
        
        let session = URLSession.shared
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = httpMethod.rawValue
        if let customHeaders = customHeaders {
            urlRequest.allHTTPHeaderFields = customHeaders
        }
        if let httpBody = httpBody {
            urlRequest.httpBody = httpBody
        }
        
        let dataTask = session.dataTask(with:urlRequest) { ( data, response, error ) in
            
            if (response == nil && error != nil) {
                completion( nil, nil, error )
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                // this error is super-unlikely, I'm pretty sure Apple will always give us an instance of an HTTPURLResponse object here.  But for thoroughness, this handles anything unexpected.
                completion( nil, nil, PantryError.typeCastFailed(on: response) )
                return
            }
            
            if (httpResponse.statusCode > 400) {
                completion(nil, httpResponse, NetworkError.httpStatusCodeError(statusCode: httpResponse.statusCode, url: urlString))
                return
            }
            
            guard let d = data else {
//          print("No data from url \(urlString)")
//          print("error: " + error.debugDescription)
                if (error != nil) {
                    completion(nil, httpResponse, error)
                    return
                } else {
                    completion(nil, httpResponse, NetworkError.dataIsNil(url: urlString))
                }
                return
            }
            
            completion( d, httpResponse, nil )
        }
        dataTask.resume()
    }
    
    static func get(_ urlString: String, _ customHeaders: [String:String]? = nil, completion: @escaping( _ data : Data?, _ : HTTPURLResponse?, _ : Error? ) -> Void  )
    {
        Network.call(httpMethod:.GET, fullUrlString:urlString, headers: customHeaders, completion: completion)
    }
    
    struct DummyEncodable: Encodable { }    // intentionally has absolute nothing in it
    
    static func getJsonObject<T:Decodable>(_ ofType: T.Type, _ urlString: String, _ customHeaders: [String:String]? = nil, completion: @escaping( _ responseAsObject : T?, _ : HTTPURLResponse?, _ : Error? ) -> Void  ) {
        let nothing: DummyEncodable? = nil    // ugh, we just need some concrete type that implements Encodeable, even though we want a nil value
        Network.callJsonEndpoint(httpMethod: .GET, urlString, customHeaders, sendingObject:nothing, expectingResponseType: ofType.self) { ( responseAsObject, responseAsRawData, urlResponse, error ) in
            completion( responseAsObject, urlResponse, error )
        }
    }
    
    /// Note on the completion:  For 99% of people out there, responseAsRawData is redundant and useless, since what you want is responseAsObject.  But there are some rare cases were we want the raw, unparsed data for debugging, so it's a parameter available in the completion handler for those uses.
    static func callJsonEndpoint<SendType:Encodable,ReceiveType:Decodable>(httpMethod: HTTPMethod, _ urlString: String, _ customHeaders: [String:String]? = nil, sendingObject: SendType? = nil, expectingResponseType:ReceiveType.Type, completion: @escaping( _ responseAsObject : ReceiveType?, _ responseAsRawData: Data?, _ : HTTPURLResponse?, _ : Error? ) -> Void  )
    {
        var dataToSend: Data? = nil
        if let sendingObject = sendingObject {
            do {
                dataToSend = try JSONEncoder().encode(sendingObject)
            } catch {
                // I was tempted to just use fatalError() here, but I'll be slightly gentler, and hopefully still get the developer's attention in console-out.
                PantryLog.log("sendingObject: \(sendingObject)")
                PantryLog.log("!!!!!!!!!!!!!!!!!")
                PantryLog.log("ERROR!!  Failing the \(httpMethod.rawValue) to \(urlString) because a \(type(of:sendingObject)) could not be encoded to JSON.  Error: \(error.localizedDescription)")
                PantryLog.log("!!!!!!!!!!!!!!!!!")
                return
            }
        }
        
        Network.call(httpMethod: httpMethod, fullUrlString: urlString, headers: customHeaders, httpBody: dataToSend) { ( responseJsonAsData, httpResponse, error ) in
            if let responseJsonAsData = responseJsonAsData {
                do {
                    let responseAsObject = try JSONDecoder().decode(ReceiveType.self, from: responseJsonAsData)
                    completion( responseAsObject, responseJsonAsData, httpResponse, error )
                } catch {
                    PantryLog.log("Couldn't decode JSON for \(String(describing: ReceiveType.self)): \(error) from \(urlString).")
                    // TODO: maybe include  String(data:responseJsonAsData, encoding: .utf8) in the json error?
                    let newError = NetworkError.jsonError(underlyingError: error, type: String(describing:ReceiveType.self), url: urlString)
                    completion( nil, responseJsonAsData, httpResponse, newError )
                }
            } else {
                if (error != nil) {
                    completion( nil, nil, httpResponse, error )
                } else {
                    completion( nil, nil, httpResponse, NetworkError.dataIsNil(url: urlString))
                }
            }
        }
    }
    
    static func post(_ urlString: String, _ customHeaders: [String:String]? = nil, httpBody: Data, completion: @escaping( _ data : Data?, _ : HTTPURLResponse?, _ : Error? ) -> Void  ) {
        Network.call(httpMethod:.POST, fullUrlString:urlString, headers:customHeaders, httpBody:httpBody, completion:completion)
    }
    
    // this really just exists so to decide whether "?" or "&" should be used when appending
    static func appendQueryStringVariable(to urlSoFar: String, addingKey variableName: String, value variableValue: String) -> String {
        var separator = "?"
        if (urlSoFar.contains("?")) {
            separator = "&"
        }
        return urlSoFar + separator + variableName + "=" + variableValue
    }
}
