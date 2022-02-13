//
//  Extension.swift
//  AccountTransaction
//
//  Created by Maria Angelina on 18/01/22.
//

import SwiftyJSON

// MARK: - JSON Extension(s)
extension JSON {
    func decode<C>(mapper: C.Type = C.self, keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .convertFromSnakeCase) -> C? where C : Codable {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = keyDecodingStrategy
        
        do {
            guard let data = description.data(using: .utf8) else {
                return nil
            }
            
            let successResponse = try jsonDecoder.decode(mapper, from: data)
            return successResponse
        } catch let error {
            debugPrint("JSON Decode Error: --\(error)")
            return nil
        }
    }
}

// MARK: - Formatter Extension(s)
extension Formatter {
    static let number = NumberFormatter()
}

extension Locale {
    static let singaporeSG: Locale = .init(identifier: "sg_SG")
}

extension Numeric {
    func formatted(with groupingSeparator: String? = nil, style: NumberFormatter.Style, locale: Locale = .current) -> String {
        Formatter.number.locale = locale
        Formatter.number.numberStyle = style
        
        if let groupingSeparator = groupingSeparator {
            Formatter.number.groupingSeparator = groupingSeparator
        }
        return Formatter.number.string(for: self) ?? ""
    }
    
    var currency: String { String(formatted(style: .currency, locale: .singaporeSG).dropFirst()) }
    var currencySG: String {
        let formattedCurrency = formatted(style: .currency, locale: .singaporeSG)
        return "SGD \(formattedCurrency.dropFirst())"
    }
}

// MARK: - String Extension(s)
extension String {
    func convertDateFormat() -> String {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        if let date = formatter.date(from: self) {
            formatter.dateFormat = "dd MMM yyyy"
            
            let stringDate = formatter.string(from: date)
            return stringDate
        }
        
        return ""
    }
}
