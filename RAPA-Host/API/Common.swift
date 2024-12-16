//
//  Common.swift
//  RAPA-Host
//
//  Created by Pari Work Temp on 11/30/24.
//

import Foundation

struct PaginatedRes<T: Hashable & Codable>: Hashable, Codable {
    let count: Int?
    let next: String?
    let previous: String?
    let results: [T]?
}



func isDebugMode() -> Bool {
    #if DEBUG
    return true
    #else
    return false
    #endif
}



enum AssetExtension: String {
    case jpg
    case png
    case jpeg
    case mp4
    case wav
    case pdf
    case unknown
}

enum AssetType: String {
    case image
    case video
    case audio
    case pdf
}




func assetType(for extension: AssetExtension?) -> AssetType? {
    switch `extension` {
    case .jpg, .png, .jpeg:
        return .image
    case .mp4:
        return .video
    case .wav:
        return .audio
    case .pdf:
        return .pdf
    case nil, .unknown:
        return nil
    }
}

func extractAssetExtension(from urlString: String) -> AssetExtension? {
    let pattern = "\\.(\\w+)(?=\\?|$)"
    let regex = try? NSRegularExpression(pattern: pattern, options: [])
    let nsString = urlString as NSString
    let results = regex?.matches(in: urlString, options: [], range: NSRange(location: 0, length: nsString.length))
    
    if let match = results?.first {
        let range = match.range(at: 1)
        let extensionString = nsString.substring(with: range)
        return AssetExtension(rawValue: extensionString)
    }
    return .unknown
}

struct CurrencyFormatter {
    static func format(amount: Double, currencyCode: String) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = currencyCode
        formatter.locale = Locale.current
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        
        return formatter.string(from: NSNumber(value: amount)) ?? ""
    }
    static func formatter(for currencyCode: String) -> NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = currencyCode
        formatter.locale = Locale.current
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
    }
}

