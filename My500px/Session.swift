//
//  Session.swift
//  My500px
//
//  Created by MailE on 7/16/17.
//  Copyright © 2017 MailE. All rights reserved.
//

import UIKit

let customerKey = "consumer_key=AoDiHaZdNCT3ofwolPBsu2JMkIhSti2oNzBGcFp4"

class Session {
    
    class func requestCategory(_ category: String, page: String, _ closure: @escaping ([Photo500px]) -> Void) {
        let path = "https://api.500px.com/v1/photos/search?term=\(category)&image_size=30,2048&page=\(page)&\(customerKey)"
        get(path: path, param: nil) { (success: Bool, dict: Dictionary<String, Any>?, error: Error?) in
            if let dict = dict {
                closure(Photo500px.map(dict: dict))
            }
        }
    }
    
    private class func get(path: String, param: Dictionary<String, Any>?, _ closure: @escaping (Bool, Dictionary<String, Any>?, Error?) -> Void) {
        dataTask(path: path, httpMethod: "GET", param: param, closure)
    }
    
    private class func dataTask(path: String, httpMethod: String, param: Dictionary<String, Any>?, _ closure: @escaping (Bool, Dictionary<String, Any>?, Error?) -> Void) {
        var request = URLRequest(url: URL(string: path)!)
        request.httpMethod = httpMethod
        if let param = param {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: param, options: JSONSerialization.WritingOptions(rawValue: 0))
            } catch {
                closure(false, nil, error)
            }
        }
        
        URLSession.shared.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            do {
                if let data = data {
                    if let dict = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? Dictionary<String, Any> {
                        closure(true, dict, error)
                    }else {
                        closure(false, nil, error)
                    }
                }else {
                    closure(false, nil, error)
                }
            } catch {
                closure(false, nil, error)
            }
        }.resume()
    }
}
