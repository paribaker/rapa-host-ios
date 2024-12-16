//
//  APIManager.swift
//  RAPA-Host
//
//  Created by Pari Work Temp on 12/7/24.
//

import Foundation

enum HTTPMethod: String {
    case post = "post"
    case get = "get"
    case patch = "patch"
    case put = "put"
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
        body: [String: Any]?=nil,
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
//            _request.addValue("application/json", forHTTPHeaderField: "content-type")
            
            _request.httpMethod = method.rawValue
            return _request
            
        }()
        
        
        
        
        if let body = body {
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: body)
                request.httpBody = jsonData
                request.addValue("application/json", forHTTPHeaderField: "content-type")
            }
            catch {}
            
            
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
    

    
    // Public instance methods for specific HTTP methods
    func requestPost<T: Encodable, U: Decodable>(
        uri: String,
        body: T?,
        header: [String: Any]?,
        completion: @escaping (_ response: U?, _ error: Error?) -> Void
    ) {
        let data = codableToDict(data: body)
        requestWithBody(method: .post, uri: uri, body: data, header: header, completion: completion)
    }
    
    func requestPatch<T: Encodable, U: Decodable>(
        uri: String,
        body: T?,
        header: [String: Any]?,
        completion: @escaping (_ response: U?, _ error: Error?) -> Void
    ) {
        let data = codableToDict(data: body)
        requestWithBody(method: .post, uri: uri, body: data, header: header, completion: completion)
    }
    
    func requestGet<U: Decodable>(
        uri: String,
        params: [String: Any]?=nil,
        header: [String: Any]?=nil,
        completion: @escaping (_ response: U?, _ error: Error?) -> Void
    ) {
        
        
        requestWithBody(method: .get, uri: uri, header: header, params:params, completion: completion)

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
                // if there are nulls then remove them
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
            let data = try JSONEncoder().encode(data)
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
            return jsonObject as? [String: Any]
        } catch {
            print("Error converting to dictionary: \(error)")
            return [:]
        }
        
    }

}




//{"id":"6be75115-0602-4a67-9894-511bee4a039d","performance_level":0,"description":"Gas because size social organization system yes tax. Whose price Congress different popular personal. Experience right throw.","media_url":"http://thinknimble.ngrok.io/media/drill_content/6be75115-0602-4a67-9894-511bee4a039d/test.gif","video_url":"http://thinknimble.ngrok.io/media/drill_content/6be75115-0602-4a67-9894-511bee4a039d/test.mp4","performance_category":"de9a2f4a-f35a-42b0-a276-b2a8178217da","performance_category_ref":{"id":"de9a2f4a-f35a-42b0-a276-b2a8178217da","created":"2024-12-05T19:24:36.690311Z","last_edited":"2024-12-05T19:24:36.690313Z","tag":1,"range_tag":"Pm indicate rate small. Ground could support without four outside. Specific reason field tax. The idea place sing since the."}}}
