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
    
    case runFailed
    
    /// This error is for time when the encoding data is failied.
    case badDecoding
    
    /// This error is for time when the response is no valid.
    case badResponse
    
    /// This error is for time when some field required is empty for makes a request.
    case fieldsEmpty
    
    /// This error is for time when response status code is equal to 401 or access denied.
    case accessDenied
    
    case noChanges
    
    var errorDescription: String? {
        switch self {
        case .badURL:
            NSLocalizedString("We are having a problem with this specific endpoint, please try again later or contact us.", comment: "")
        case .badEncoding:
            NSLocalizedString("Unable to encode data, please try again or contact us.", comment: "")
        case .badResponse:
            NSLocalizedString("There was a problem getting a response, please check your connection and try again or contact us.", comment: "")
        case .accessDenied:
            NSLocalizedString("You do not have permission to access to access the user's specific features in the App. Please make the login.", comment: "")
        case .fieldsEmpty:
            NSLocalizedString("There are empty fields in the form, please fill them in before proceeding.", comment: "")
        case .badDecoding:
            NSLocalizedString("Unable to decoding data, please try again or contact us.", comment: "")
        case .noChanges:
            NSLocalizedString("You need to make some change for execute this action.", comment: "")
        case .runFailed:
            NSLocalizedString("Failed to get data.", comment: "")
        }
    }
}
