//
//  JSON.swift
//
//  Created by Pramod Kotipalli on 11/1/17.
//  Copyright © 2017 Pramod Kotipalli. All rights reserved.
//

import Foundation

public class JSON {
    
    /**
     Encodes the given Codable document into a Data object.
     
     - parameter object: The object to encode.
     
     - returns: A JSON-encoded Data representation of the given object.
     
     */
    public class func encode<T: Codable>(_ object: T) -> Data? {
        do {
            let jsonEncoder = JSONEncoder()
            let jsonData = try jsonEncoder.encode(object)
            let jsonString = String(data: jsonData, encoding: .utf8)!
            return jsonString.data(using: .utf8)!
        } catch {
            return nil
        }
    }
    
    
    /**
     
     Decodes the given JSON Data into the specified
     
     - parameter jsonData: The Data to decode.
     
     - parameter into: The type into which the Data should be decoded.
     
     */
    public class func decode<T: Codable>(_ jsonData: Data, into: T.Type) -> T? {
        do {
            let jsonDecoder = JSONDecoder()
            let string = String(data: jsonData, encoding: .utf8)!
            let object = try jsonDecoder.decode(T.self, from: string.data(using: .utf8)!)
            return object
        } catch {
            return nil
        }
    }
}
