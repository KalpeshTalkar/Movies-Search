//
// MIT License
//
// Copyright (c) [2022] [Kalpesh Talkar]
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
//

import Foundation

public typealias JSONObject = Dictionary<String, Any>
public typealias JSONArray = Array<JSONObject>

public extension Data {

    /// Create a Foundation object from JSON data.
    ///
    /// - Set the `NSJSONReadingAllowFragments` option if the parser should allow top-level objects that are not an `NSArray` or `NSDictionary`.
    /// - Setting the `NSJSONReadingMutableContainers` option will make the parser generate mutable `NSArrays` and `NSDictionaries`.
    /// - Setting the `NSJSONReadingMutableLeaves` option will make the parser generate mutable `NSString` objects.
    ///
    /// If an error occurs during the parse, then the error parameter will be set and the result will be nil.
    ///
    /// The data must be in one of the 5 supported encodings listed in the JSON specification: `UTF-8, UTF-16LE, UTF-16BE, UTF-32LE, UTF-32BE`.
    /// The data may or may not have a BOM. The most efficient encoding to use for parsing is `UTF-8`, so if you have a choice in encoding the data passed to this method, use `UTF-8`.
    ///
    /// - Parameter readingOptions: Options for reading the JSON data and creating the Foundation objects.
    /// For possible values, see [JSONSerialization.ReadingOptions](https://developer.apple.com/documentation/foundation/jsonserialization/readingoptions).
    /// - Returns: A Foundation object from the given JSON data, or nil if an error occurs.
    func toJSON(readingOptions: JSONSerialization.ReadingOptions = []) throws -> Any {
        return try JSONSerialization.jsonObject(with: self, options: readingOptions)
    }

    /// Decode an instance of the indicated type.
    ///
    /// If the data isn’t valid JSON, this method throws the [DecodingError.dataCorrupted(_:)](https://developer.apple.com/documentation/swift/decodingerror/datacorrupted) error. If a value within the JSON fails to decode, this method throws the corresponding error.
    ///
    /// - Parameters:
    ///   - to: Type of struct or class
    ///   - keyDecodingStrategy: A value that determine how a type's coding keys are decoded from JSON keys.
    ///   - dateDecodingStrategy: The strategy used when decoding dates from part of a JSON object..
    /// - Returns:A value of the specified type, if the decoder can parse the data.
    /// - throws: `DecodingError.dataCorrupted` if values requested from the payload are corrupted, or if the given data is not valid JSON.
    /// - throws: An error if any value throws an error during decoding.
    func decode<T: Decodable>(to type: T.Type, keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy? = nil, dateDecodingStrategy: JSONDecoder.DateDecodingStrategy? = nil) throws -> T? {
        let jsonDecoder = JSONDecoder()
        if let keyDecodingStrategy = keyDecodingStrategy {
            jsonDecoder.keyDecodingStrategy = keyDecodingStrategy
        }
        if let dateDecodingStrategy = dateDecodingStrategy {
            jsonDecoder.dateDecodingStrategy = dateDecodingStrategy
        }
        return try jsonDecoder.decode(type, from: self)
    }
}

public extension String {

    /// Create a Foundation object from JSON string.
    ///
    /// - Set the `NSJSONReadingAllowFragments` option if the parser should allow top-level objects that are not an `NSArray` or `NSDictionary`.
    /// - Setting the `NSJSONReadingMutableContainers` option will make the parser generate mutable `NSArrays` and `NSDictionaries`.
    /// - Setting the `NSJSONReadingMutableLeaves` option will make the parser generate mutable `NSString` objects.
    ///
    /// If an error occurs during the parse, then the error parameter will be set and the result will be nil.
    ///
    /// The string must be in one of the 5 supported encodings listed in the JSON specification: `UTF-8, UTF-16LE, UTF-16BE, UTF-32LE, UTF-32BE`.
    /// The string may or may not have a BOM. The most efficient encoding to use for parsing is `UTF-8`, so if you have a choice in encoding the data passed to this method, use `UTF-8`.
    ///
    /// - Parameters:
    ///   - encoding: A string encoding. For possible values, see [NSStringEncoding](https://developer.apple.com/documentation/foundation/nsstringencoding).
    ///   - allowLossyConversion:If `true`, then allows characters to be removed or altered in conversion.
    ///   - readingOptions: Options for reading the JSON data and creating the Foundation objects.
    /// For possible values, see [JSONSerialization.ReadingOptions](https://developer.apple.com/documentation/foundation/jsonserialization/readingoptions).
    /// - Returns: A Foundation object from the given JSON string, or nil if an error occurs.
    func toJSON(encoding: Encoding = .utf8, allowLossyConversion: Bool = false, readingOptions: JSONSerialization.ReadingOptions = []) throws -> Any? {
        guard let data = data(using: encoding, allowLossyConversion: allowLossyConversion) else {
            return nil
        }
        return try data.toJSON(readingOptions: readingOptions)
    }

    /// Decode an instance of the indicated type.
    ///
    /// If the data isn’t valid JSON, this method throws the [DecodingError.dataCorrupted(_:)](https://developer.apple.com/documentation/swift/decodingerror/datacorrupted) error. If a value within the JSON fails to decode, this method throws the corresponding error.
    ///
    /// - Parameters:
    ///   - to: Type of struct or class
    ///   - keyDecodingStrategy: A value that determine how a type's coding keys are decoded from JSON keys.
    ///   - dateDecodingStrategy: The strategy used when decoding dates from part of a JSON object.
    /// - Returns:A value of the specified type, if the decoder can parse the data.
    /// - throws: `DecodingError.dataCorrupted` if values requested from the payload are corrupted, or if the given data is not valid JSON.
    /// - throws: An error if any value throws an error during decoding.
    func decode<T: Decodable>(to type: T.Type, keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy? = nil, dateDecodingStrategy: JSONDecoder.DateDecodingStrategy? = nil) throws -> T? {
        guard let data = data(using: .utf8) else {
            return nil
        }
        return try data.decode(to: type, keyDecodingStrategy: keyDecodingStrategy, dateDecodingStrategy: dateDecodingStrategy)
    }
}

public extension Encodable {

    /// Encodes an instance of the indicated type.
    ///
    /// If there’s a problem encoding the value you supply, this method throws an error based on the type of problem:
    /// - The value fails to encode, or contains a nested value that fails to encode—this method throws the corresponding error.
    /// - The value isn’t encodable as a JSON array or JSON object—this method throws the [EncodingError.invalidValue(_:_:)](https://developer.apple.com/documentation/swift/encodingerror/invalidvalue) error.
    ///  - The value contains an exceptional floating-point number (such as [infinity](https://developer.apple.com/documentation/swift/floatingpoint/1641304-infinity) or [nan](https://developer.apple.com/documentation/swift/floatingpoint/1641652-nan)) and you’re using the default [JSONEncoder.NonConformingFloatEncodingStrategy](https://developer.apple.com/documentation/foundation/jsonencoder/nonconformingfloatencodingstrategy) — this method throws the EncodingError.invalidValue(_:_:) error.
    ///
    /// - Parameters:
    ///   - keyEncodingStrategy: A value that determine how a type's coding keys are encoded as JSON keys.
    ///   - dateEncodingStrategy: The strategy used when encoding dates as part of a JSON object.
    /// - Returns:The encoded JSON data.
    /// - throws: `EncodingError.invalidValue` if a non-conforming floating-point value is encountered during encoding, and the encoding strategy is `.throw`.
    /// - throws: An error if any value throws an error during encoding.
    func toData(keyEncodingStrategy: JSONEncoder.KeyEncodingStrategy? = nil, dateEncodingStrategy: JSONEncoder.DateEncodingStrategy? = nil) throws -> Data? {
        let jsonEncoder = JSONEncoder()
        if let keyEncodingStrategy = keyEncodingStrategy {
            jsonEncoder.keyEncodingStrategy = keyEncodingStrategy
        }
        if let dateEncodingStrategy = dateEncodingStrategy {
            jsonEncoder.dateEncodingStrategy = dateEncodingStrategy
        }
        return try jsonEncoder.encode(self)
    }

    /// Encodes an instance of the indicated type and covert to JSON String.
    ///
    /// If there’s a problem encoding the value you supply, this method throws an error based on the type of problem:
    /// - The value fails to encode, or contains a nested value that fails to encode—this method throws the corresponding error.
    /// - The value isn’t encodable as a JSON array or JSON object—this method throws the [EncodingError.invalidValue(_:_:)](https://developer.apple.com/documentation/swift/encodingerror/invalidvalue) error.
    ///  - The value contains an exceptional floating-point number (such as [infinity](https://developer.apple.com/documentation/swift/floatingpoint/1641304-infinity) or [nan](https://developer.apple.com/documentation/swift/floatingpoint/1641652-nan)) and you’re using the default [JSONEncoder.NonConformingFloatEncodingStrategy](https://developer.apple.com/documentation/foundation/jsonencoder/nonconformingfloatencodingstrategy) — this method throws the EncodingError.invalidValue(_:_:) error.
    ///
    /// - Parameters:
    ///   - keyEncodingStrategy: A value that determine how a type's coding keys are encoded as JSON keys.
    ///   - dateEncodingStrategy: The strategy used when encoding dates as part of a JSON object.
    /// - Returns:The encoded JSON String.
    /// - throws: `EncodingError.invalidValue` if a non-conforming floating-point value is encountered during encoding, and the encoding strategy is `.throw`.
    /// - throws: An error if any value throws an error during encoding.
    func toString(keyEncodingStrategy: JSONEncoder.KeyEncodingStrategy? = nil, dateEncodingStrategy: JSONEncoder.DateEncodingStrategy? = nil) throws -> String? {
        guard let data = try toData(keyEncodingStrategy: keyEncodingStrategy, dateEncodingStrategy: dateEncodingStrategy) else {
            return nil
        }
        return String(data: data, encoding: .utf8)
    }
}

public extension Dictionary {

    /// Generate JSON data from a Foundation object.
    ///
    /// If the object will not produce valid JSON then an exception will be thrown. Setting the `NSJSONWritingPrettyPrinted` option will generate JSON with whitespace designed to make the output more readable. If that option is not set, the most compact possible JSON will be generated. If an error occurs, the error parameter will be set and the return value will be nil. The resulting data is a encoded in `UTF-8`.
    ///
    /// - Parameter writingOptions: Options for creating the JSON data.
    /// See [JSONSerialization.WritingOptions](https://developer.apple.com/documentation/foundation/jsonserialization/writingoptions) for possible values.
    /// - Returns: JSON data for obj, or nil if an internal error occurs. The resulting data is encoded in `UTF-8`.
    func toData(writingOptions: JSONSerialization.WritingOptions = []) throws -> Data {
        return try JSONSerialization.data(withJSONObject: self, options: writingOptions)
    }

    /// Generate JSON string from a Foundation object.
    ///
    /// If the object will not produce valid JSON then an exception will be thrown. Setting the `NSJSONWritingPrettyPrinted` option will generate JSON with whitespace designed to make the output more readable. If that option is not set, the most compact possible JSON will be generated. If an error occurs, the error parameter will be set and the return value will be nil. The resulting data is a encoded in `UTF-8`.
    ///
    /// - Parameter writingOptions: Options for creating the JSON data.
    /// See [JSONSerialization.WritingOptions](https://developer.apple.com/documentation/foundation/jsonserialization/writingoptions) for possible values.
    /// - Returns: JSON string for obj, or nil if an internal error occurs. The resulting data is encoded in `UTF-8`.
    func toString(writingOptions: JSONSerialization.WritingOptions = []) throws -> String? {
        let data =  try toData(writingOptions: writingOptions)
        return String(data: data, encoding: .utf8)
    }
}

public extension Array {

    /// Generate JSON data from a Foundation object.
    ///
    /// If the object will not produce valid JSON then an exception will be thrown. Setting the `NSJSONWritingPrettyPrinted` option will generate JSON with whitespace designed to make the output more readable. If that option is not set, the most compact possible JSON will be generated. If an error occurs, the error parameter will be set and the return value will be nil. The resulting data is a encoded in `UTF-8`.
    ///
    /// - Parameter writingOptions: Options for creating the JSON data.
    /// See [JSONSerialization.WritingOptions](https://developer.apple.com/documentation/foundation/jsonserialization/writingoptions) for possible values.
    /// - Returns: JSON data for obj, or nil if an internal error occurs. The resulting data is encoded in UTF-8.
    func toData(writingOptions: JSONSerialization.WritingOptions = []) throws -> Data {
        return try JSONSerialization.data(withJSONObject: self, options: writingOptions)
    }

    /// Generate JSON string from a Foundation object.
    ///
    /// If the object will not produce valid JSON then an exception will be thrown. Setting the `NSJSONWritingPrettyPrinted` option will generate JSON with whitespace designed to make the output more readable. If that option is not set, the most compact possible JSON will be generated. If an error occurs, the error parameter will be set and the return value will be nil. The resulting data is a encoded in `UTF-8`.
    ///
    /// - Parameter writingOptions: Options for creating the JSON data.
    /// See [JSONSerialization.WritingOptions](https://developer.apple.com/documentation/foundation/jsonserialization/writingoptions) for possible values.
    /// - Returns: JSON string for obj, or nil if an internal error occurs. The resulting data is encoded in `UTF-8`.
    func toString(writingOptions: JSONSerialization.WritingOptions = []) throws -> String? {
        let data =  try toData(writingOptions: writingOptions)
        return String(data: data, encoding: .utf8)
    }
}
