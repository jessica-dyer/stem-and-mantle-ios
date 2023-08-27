//
//  PantryErrors.swift
//
//  Created by Rob Busack on 7/22/2020.
//  Copyright © 2020 General UI. All rights reserved.
//

import Foundation
import UIKit

enum NetworkError: Swift.Error {
    
    case invalidUrl(url: String)
    case dataIsNil(url: String)
    case httpStatusCodeError(statusCode: Int, url: String)
    case jsonError(underlyingError: Error, type: String, url: String)
}

enum PantryError: Swift.Error {
    
    case nilResponseAndNoError
    case typeCastFailed(on: Any?)
    case notAValidImage(urlOrPath : String)
    case cannotBeNil(variableNameOrKey: String)
    case awsError(message: String, line: String)
    case invalidDate(from: String)
}

///////////////////////////////////////////////////////////////////////////////////////////////////
func getWhyString(forError error: Swift.Error?) -> String {
    var why: String = "";
    if let error = error {
        do {
            throw error
            
            
            //*** MARK: Network Errors ***
        } catch NetworkError.invalidUrl(let url) {
            why = "An invalid url was used.  This is likely a bug."
            why += "  url = \(url)"
        } catch NetworkError.dataIsNil(let url) {
            why = "A network call returned no data."
            why += "  url = \(url)"
        } catch NetworkError.httpStatusCodeError(let statusCode, let url) {
            why = "HTTP status code \(statusCode)"
            why += "  url = \(url)"
        } catch NetworkError.jsonError(let underlyingError, let type, let url) {
            why = "An error occured decoding JSON data for \(type) from \(url)."
            why += " \n" + ErrorUtil.moreInfoAboutJsonError(underlyingError)
            
            
            //*** MARK: General Errors ***
        } catch PantryError.nilResponseAndNoError {
            why = "The expected object doesn't exist, yet no error was reported. (Both are nil.)  This is almost certainly a bug."
        } catch PantryError.typeCastFailed(let objectOfUnexpectedType) {
            let className = String(describing: type(of: objectOfUnexpectedType))
            why = "Type case failed, unexpected type: \(className)"
        } catch PantryError.notAValidImage(let urlOrPath) {
            why = "The following image could not be loaded: " + urlOrPath
        } catch PantryError.cannotBeNil(let variableNameOrKey) {
            why = "Unexpectedly got nil for " + variableNameOrKey
        } catch PantryError.awsError(let message, let line) {
            why = "The AWS Lambda function had an error: \"\(message)\""
            if (!isNilOrEmptyOrWhitespace(line)) {
                why += " on \(line)"
            }
            
        
            
            //*** MARK: NSError Errors ***
        } catch let error as NSError {
            //*** MARK: NSURLErrorDomain Errors ***
            if (error.domain == NSURLErrorDomain) {
                // useful constants defined in NSURLError.h starting at line 100
                if (error.code == NSURLErrorTimedOut) {
                    why = "The request timed out.  Are you sure your internet access is working?"
                } else if (error.code == NSURLErrorCannotConnectToHost) {
                    why = "Unable to connect to the server"
                    if let failingUrl = error.userInfo["NSErrorFailingURLStringKey"] as? String {
                        why += " at " + failingUrl
                    }
                } else if (error.code == NSURLErrorSecureConnectionFailed) {
                    why = "An SSL error has occurred and a secure connection to the server cannot be made."
                }
                
            }
            
            // if no case in the if-else ladder above handled this yet…
            if (isNilOrEmptyOrWhitespace(why)) {
                why = error.localizedDescription
            }
            
            //*** MARK: NSURLErrorDomain Errors ***
        } catch let error as CustomNSError {

            why = error.localizedDescription
            
            //*** MARK: Unknown Errors ***
        } catch let myError {
            why = "Unknown error: \(myError.localizedDescription)"
        }
    } else {
        why = "(error is nil)"
    }
    return why
}


///////////////////////////////////////////////////////////////////////////////////////////////////
class ErrorUtil {

    static func moreInfoAboutJsonError(_ error: Error) -> String {
        var moreInfo = ""
        do {
            throw error
        } catch DecodingError.keyNotFound(let key, let context) {
            moreInfo = "Required key '\(key.stringValue)' not found in " + getContainerName(from: context)
        } catch DecodingError.valueNotFound(_, let context) {
            moreInfo = "Value for '\(getContainerName(from: context))' is not optional, but is missing or null."
        } catch DecodingError.typeMismatch(_, let context) {
            moreInfo = "Type mismatch at " + getContainerName(from: context)
        } catch {
            moreInfo = "Not a DecodingError: " + String(describing:error)
        }
        return moreInfo
    }
    
    static func getContainerName(from decodingErrorContext: DecodingError.Context) -> String {
        if decodingErrorContext.codingPath.count == 0 {
            return "root element"
        }
        
        if let containerName = decodingErrorContext.codingPath.first?.stringValue {
            return containerName
        } else {
            return "(codingPath not given)"
        }
    }
    
    static func showAlert(in viewController: UIViewController, title: String, error: Error?, onClickOkay: ((UIAlertAction) -> Void)? = nil ) {
        let whyString = getWhyString(forError: error)
        let alert = UIAlertController(title: title, message: whyString, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: onClickOkay))
        viewController.present(alert, animated: true)
    }
}
