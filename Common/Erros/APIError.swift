//
//  APIError.swift
//  CupcakeCorner
//
//  Created by Isaque da Silva on 20/04/24.
//

import Foundation

/// An representation of the errors that may be occur on a request for the API.
enum APIError: Error {
    
    /// This error is for time when the URL is not valid.
    case badURL
    
    /// This error is for time when the encoding data is failied.
    case badEncoding
    
    /// This error is for time when the encoding data is failied.
    case badDecoding
    
    /// This error is for time when the response is no valid.
    case badResponse
    
    /// This error is for time when some field required is empty for makes a request.
    case fieldsEmpty
    
    /// This error is for time when response status code is equal to 401 or access denied.
    case accessDenied
}

extension APIError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .badURL:
            NSLocalizedString("We are having a problem with this URL, please try again later or contact us.", comment: "")
        case .badEncoding:
            NSLocalizedString("Unable to encode data, please try again or contact us.", comment: "")
        case .badResponse:
            NSLocalizedString("There was a problem getting a response, please check your connection and try again or contact us.", comment: "")
        case .accessDenied:
            NSLocalizedString("You do not have permission to access this route.", comment: "")
        case .fieldsEmpty:
            NSLocalizedString("There are empty fields in the form, please fill them in before proceeding.", comment: "")
        case .badDecoding:
            NSLocalizedString("Unable to decoding data, please try again or contact us.", comment: "")
        }
    }
}
