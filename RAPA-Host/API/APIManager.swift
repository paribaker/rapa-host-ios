//
//  APIManager.swift
//  RAPA-Host
//
//  Created by Pari Work Temp on 12/7/24.
//
import Foundation

enum ContentType: String {
    case json = "application/json"
    case form = "application/x-www-form-urlencoded"
    case multipart = "multipart/form-data"
}

enum HTTPMethod: String {
    case post = "post"
    case get = "get"
    case patch = "patch"
    case put = "put"
}



extension JSONEncoder {
    static var snakeCaseEncoder: JSONEncoder {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        return encoder
    }
}



/// This ApiService manages all server communication through various functions.
class ApiService: NSObject {
    let baseUrl: String
    
    init(baseUrl: String) {
        self.baseUrl = baseUrl
    }
    
    
    // An instance method to handle common request logic
    private func requestWithBody<R: Decodable>(
        method: HTTPMethod,
        uri: String,
        body: Data?=nil,
        header: [String: Any]?=nil,
        params: [String: Any]?=nil,
        completion: @escaping (_ response: R?, _ error: Error?) -> Void
    ) {
        
        guard let url = getUrl(uri: uri, params: params) else {
            completion(nil, NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Code Error"]))
            return
        }
        
        var request: URLRequest = {
            var _request = URLRequest(url: url)
            _request.httpMethod = method.rawValue
            return _request
        }()
        
        if let body = body {
            request.httpBody = body
        }
        
        if let header = header {
            for (h, v) in header {
                request.addValue(v as! String, forHTTPHeaderField: h)
            }
        }
        
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print(error.localizedDescription)
                DispatchQueue.main.async {
                    completion(nil, NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Code Error"]))
                }
                return
            }
            
            guard let response = response as? HTTPURLResponse, let data = data else {
                DispatchQueue.main.async {
                    completion(nil, NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Code Error"]))
                }
                return
            }
            self.handleResponse(response: response, data: data, completion: completion)
            
        }
        
        task.resume()
    }
    
    // Instance method to handle the response from the server
    private func handleResponse<U: Decodable>(
        response: HTTPURLResponse,
        data: Data,
        completion: @escaping (_ response: U?, _ error: Error?) -> Void
    ) {
        
        let statusCode = response.statusCode
        
        switch statusCode {
            
        case 401:
            // this case should always default to logging the user out
            SessionManager.shared.logOut()
            completion(nil, nil)
        case 200...299:
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let decodedResponse = try decoder.decode(U.self, from: data)
                completion(decodedResponse, nil)
            }
            catch {
                if isDebugMode(){
                    if let decodingError = error as? DecodingError{
                        switch decodingError {
                        case .typeMismatch(_, let c), .valueNotFound(_, let c), .keyNotFound(_, let c), .dataCorrupted(let c):
                            print(c.debugDescription)
                            completion(nil, error)
                        @unknown default:
                            print("Unknown Decode Error")
                        }
                        
                    }else{
                        print(error)
                    }
                }
                completion(nil, error)
                
                
            }
        case 400...499:
            
            let json = try? JSONSerialization.jsonObject(with: data, options: [])
            guard let json = json else {
                completion(nil, NSError(domain: "", code: statusCode, userInfo: [NSLocalizedDescriptionKey: "ERROR"]))
                return
            }
            
            if let errorMessage = parseError(response: json as! [String : Any]) {
                completion(nil, NSError(domain: "", code: statusCode, userInfo: [NSLocalizedDescriptionKey: errorMessage]))
            }else {
                completion(nil, NSError(domain: "", code: statusCode, userInfo: [NSLocalizedDescriptionKey: "ERROR"]))
            }
            
            
        default:
            completion(nil, NSError(domain: "", code: statusCode, userInfo: [NSLocalizedDescriptionKey: "Server error"]))
        }
    }
    
    func requestPost<T: Encodable, U: Decodable>(
        uri: String,
        body: T?,
        header: [String: Any]?,
        completion: @escaping (_ response: U?, _ error: Error?) -> Void
    ) {
        let headers = ["Content-Type": "application/json"].merging(header ?? [:]) { (_, new) in new } 
        requestWithBody(method: .post, uri: uri, body: prepareBody(data: body, contentType: checkContentType(headers: headers)), header: headers, completion: completion)
        
        
    }
    
    func requestPatch<T: Encodable, U: Decodable>(
        uri: String,
        body: T?,
        header: [String: Any]?,
        completion: @escaping (_ response: U?, _ error: Error?) -> Void
    ) {
        let headers = ["Content-Type": "application/json"].merging(header ?? [:]) { (_, new) in new }
        requestWithBody(method: .patch, uri: uri, body: prepareBody(data: body, contentType: checkContentType(headers: headers)), header: headers, completion: completion)
    }
    
    func requestGet<U: Decodable>(
        uri: String,
        params: [String: Any]?=nil,
        header: [String: Any]?=nil,
        completion: @escaping (_ response: U?, _ error: Error?) -> Void
    ) {
        let headers = ["Content-Type": "application/json"].merging(header ?? [:]) { (_, new) in new }
        requestWithBody(method: .get, uri: uri, header: headers, params:params, completion: completion)
        
    }
    
}

extension ApiService {
    private func parseError(response: [String: Any]) -> String? {
        return response.values.compactMap { value -> String? in
            if let messageArray = value as? [String], let firstMessage = messageArray.first {
                return firstMessage
            } else if let message = value as? String {
                return message
            }
            return nil
        }.first ?? "Client error"
    }
    
    private  func getUrl(uri: String, params: [String: Any]?)->URL? {
        var components = URLComponents(string: "\(self.baseUrl)\(uri)")
        
        if let params = params {
            for (p,v) in params {
                components?.queryItems?.append(URLQueryItem(name: p,value: v as? String))
            }
            return (components?.url! as? URL)!
            
        }else {
            guard let url = components?.url! else {
                return nil
            }
            return url
        }
    }
    
    private func codableToDict<T: Encodable>(data: T)->[String: Any]?{
        do {
            let data = try JSONEncoder.snakeCaseEncoder.encode(data)
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
            return jsonObject as? [String: Any]
        } catch {
            print("Error converting to dictionary: \(error)")
            return [:]
        }
        
    }
    private func prepareBody<T: Encodable>(data: T, contentType: String)->Data?{
        
        switch contentType {
        case ContentType.multipart.rawValue:
//            guard let data = codableToDict(data: data) else {
//                return nil
//            }
            return nil
            
        case ContentType.json.rawValue:
            guard let jsonObject = codableToDict(data: data) else {
                return nil
            }
            guard let jsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted) else {
                return nil
            }
            print(String(data: jsonData, encoding: .utf8))
            return jsonData
        default:
            return nil
        }
    
        
    }
    private func checkContentType(headers: [String: Any])->String{
        return headers["Content-Type"] as? String ?? ContentType.json.rawValue
    }
    
}
