//
//  PantryLog.swift
//
//  Created by Rob Busack on 7/22/2020.
//  Copyright © 2020 General UI. All rights reserved.
//

import Foundation
import MessageUI

///////////////////////////////////////////////////////////////////////////////////////////////////
class PantryLog: NSObject, MFMailComposeViewControllerDelegate {
    
    static let APP_NAME = "YOU_APP_NAME_HERE"
    static let LOG_FILENAME_PREFIX = "pantryLog"
    static let LOGS_FOLDER_NAME = LOG_FILENAME_PREFIX+"s"
    
    static let shared = PantryLog()
    
    private var logFileHandle: FileHandle
    private lazy var buildNumber = { Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "(null)" }()
    
    static func log(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        
        // "file" comes in as a complete path, and we only want the filename at the end
        let fileShortened = justFilenameFromFullFilePath(file)
        
        PantryLog.shared.log(message, file: String(fileShortened), function: function, line: line)
    }
    
    override init() {
        
        let now = Date()
        let timestamp = DateUtil.getStringFor(format: "yyyyMMdd-HHmmss", date: now)
        let buildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "(null)"
        //let version: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? "(null)"
        
        let filename = "\(PantryLog.LOG_FILENAME_PREFIX)_\(timestamp)_build-\(buildNumber).txt"
        
        var initialLogContent = "** Starting new log upon launch of the app **\n\n"
        initialLogContent += " ~ Build Details ~\n"
        initialLogContent += "Build number: \(buildNumber)\n"
        initialLogContent += getBuildDetails() + "\n"
        initialLogContent += " ~ Host Device Details ~\n"
        initialLogContent += "Device model: \(UIDevice.modelName)\n"
        initialLogContent += "Device OS version: " + UIDevice.current.systemName + " " + UIDevice.current.systemVersion + "\n"
        let timezoneAbbreviation = TimeZone.current.abbreviation() ?? ""
        initialLogContent += "Selected timezone: \(timezoneAbbreviation), \(TimeZone.current.identifier), seconds from GMT: \(TimeZone.current.secondsFromGMT())\n"
        initialLogContent += "Daylight Saving Time: \(TimeZone.current.isDaylightSavingTime(for: Date()))\n"
        
        initialLogContent += "\n"
        initialLogContent += "Log format is:\ntimestamp - log-message ~~ line-number\n\n"
        
        
        guard let pathForLogFile = PantryLog.pathForLogsDirectory()?.appendingPathComponent(filename) else {
            print("Cannot start logging, cannot create a valid path & filename for a new log file.  path = \(String(describing: PantryLog.pathForLogsDirectory())), filename = \(filename)")
            self.logFileHandle = FileHandle()   // dummy to make compiler happy
            super.init()
            return
        }
        do {
            let initialFileContentAsData = initialLogContent.data(using: .utf8) ?? Data()
            let path = PantryLog.stringPathFromUrl(pathForLogFile)
            FileManager().createFile(atPath: path, contents: initialFileContentAsData)
            self.logFileHandle = try FileHandle(forWritingTo: pathForLogFile)
            self.logFileHandle.seekToEndOfFile()
        } catch (let error) {
            print("Cannot start logging, an error occured trying to open the log file for writing: \(error) \(error.localizedDescription)")
            self.logFileHandle = FileHandle()   // dummy to make compiler happy
        }
        
        super.init()
        
        self.deleteOlderLogFiles()
    }
    
    func log(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        let timestamp = DateUtil.timestampForLogFile()
        
        // "file" comes in as a complete path, and we only want the filename at the end
        let fileShortened = file.split(separator: "/").last ?? Substring(file)
        let callLocation = "\(fileShortened):\(line) in \(function)"
        
        
        // Don't include our own timestampe when calling print(), since it adds it's own timestamp, so ours would be redundant/cluttered
        let lineWithoutTimestamp = "\(message) ~~ \(callLocation)"
        print(lineWithoutTimestamp)
        
        let lineWithTimestamp = timestamp + " - " + lineWithoutTimestamp + "\n"
        let lineAsData = lineWithTimestamp.data(using: .utf8) ?? "(encoding a line failed)".data(using: .utf8)!
        self.logFileHandle.write(lineAsData)
        self.logFileHandle.synchronizeFile()    // this might be unnecessary
    }
    
    static func pathForLogsDirectory() -> URL? {
        if let cachesDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first {
            let logsDirectory = cachesDirectory.appendingPathComponent(PantryLog.LOGS_FOLDER_NAME)
            
            // make sure our directory exists, if it does not already
            try? FileManager.default.createDirectory(at: logsDirectory, withIntermediateDirectories: true, attributes: nil)
            
            return logsDirectory
        } else {
            print("For some reason we can't access the caches directory")
            return nil
        }
    }
    
    static func stringPathFromUrl(_ url: URL) -> String {
        return url.absoluteString.replacingOccurrences(of: "file:///", with:"/")
    }
    
    static func justFilenameFromFullFilePath(_ fullPath: String) -> String {
        return String( fullPath.split(separator: "/").last ?? Substring(fullPath) )
    }
    
    func deleteOlderLogFiles() {
        if let pathForLogsDirectory = PantryLog.pathForLogsDirectory() {
            let now = Date()
            let aWeekAgo = Date.init(timeInterval: -7 * DateUtil.ONE_DAY , since: now)
            
            PantryLog.deleteFilesIn(directory: pathForLogsDirectory, olderThan: aWeekAgo)
        }
    }
    
    static func deleteFilesIn(directory: URL, olderThan cuttoffDate: Date) {
        guard let enumerator = FileManager.default.enumerator(at: directory, includingPropertiesForKeys: nil) else {
            print("Cannot enumerate directory: \(directory.absoluteString)")
            return
        }
        
        for fileUrl in enumerator.allObjects {
            if let fileUrl = fileUrl as? URL {
                if let attributes = try? FileManager.default.attributesOfItem(atPath: PantryLog.stringPathFromUrl(fileUrl)) {
                    if let modDate = attributes[FileAttributeKey.modificationDate] as? Date {
                        if (modDate.isBefore(cuttoffDate)) {
                            try? FileManager.default.removeItem(at: fileUrl)
                        }
                    }
                }
            }
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult, error: Error?) {
        
        // Dismiss the mail compose view controller.
        controller.dismiss(animated: true, completion: nil)
    }
    
    static func emailLogs(rootViewController: UIViewController) {
        if !MFMailComposeViewController.canSendMail() {
            let alert = UIAlertController(title: "Email cannot be sent", message: "In order to send an email, you must go to the Settings or Mail app on this iPhone and add a mail account.", preferredStyle: .alert)
            rootViewController.present(alert, animated: true)
            return
        }
        
        let composeVC = MFMailComposeViewController()
        composeVC.mailComposeDelegate = PantryLog.shared
        
        composeVC.setSubject("\(APP_NAME) logs")
        composeVC.setToRecipients(["robusa@genui.co"])
        
        var emailBody = "This email was generated by the \(APP_NAME).\n\n"
        emailBody += "-----\nAre there any details you want to add to describe why you are sending these logs?\n\n\n\n\n\n\n\n\n"
        emailBody += "\n\n-----\n\n"
        emailBody += getBuildDetails() + "\n"
        
        
        
        composeVC.setMessageBody(emailBody, isHTML: false)
        
        let logFiles = PantryLog.getRecentLogFiles()
        let logFileNames = logFiles.keys
        for filename in logFileNames {
            if let fileContents = logFiles[filename] {
                composeVC.addAttachmentData(fileContents, mimeType:"application/octet-stream", fileName: filename)
            }
        }
        
        rootViewController.present(composeVC, animated: true, completion: nil)
    }
    
    
    
    /* Returns a dictionary where keys are filename strings and values are contents of files as data */
    static func getRecentLogFiles() -> [ String : Data ] {
        var logs = [ String : Data ]()
        
        if let directoryPath = PantryLog.pathForLogsDirectory() {
            let fileManager = FileManager.default
            let enumeratedLogFiles = fileManager.enumerator(at: directoryPath, includingPropertiesForKeys: nil)
            
            for fileUrl in enumeratedLogFiles!.allObjects {
                if let fileUrl = fileUrl as? URL {
                    let filePath = PantryLog.stringPathFromUrl(fileUrl)
                    let fileContents = fileManager.contents(atPath: filePath)
                    let filename = PantryLog.justFilenameFromFullFilePath(filePath)
                    logs[filename] = fileContents
                }
            }
        }
        
        return logs
    }
}
