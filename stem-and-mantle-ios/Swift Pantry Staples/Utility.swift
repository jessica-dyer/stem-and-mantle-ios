//
//  Utility.swift
//
//  Created by Rob Busack on 7/22/2020.
//  Copyright © 2020 General UI. All rights reserved.
//

import Foundation
import UIKit

typealias Guid = String

func isNilOrEmpty(_ str: String?) -> Bool {
    return str == nil || str?.count == 0
}

func isNilOrEmptyOrWhitespace(_ str: String?) -> Bool {
    return isNilOrEmpty(str) || str?.trimmingCharacters(in: .whitespacesAndNewlines).count == 0
}

func generateNewGuid() -> Guid {
    return UUID().uuidString
}

func inWrapperView(_ innerView: UIView) -> UIView {
    let wrapperView = UIView()
    wrapperView.addSubview(innerView)
    wrapperView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
        wrapperView.topAnchor.constraint(lessThanOrEqualTo: innerView.topAnchor),
        wrapperView.bottomAnchor.constraint(greaterThanOrEqualTo: innerView.bottomAnchor),
        wrapperView.leftAnchor.constraint(lessThanOrEqualTo: innerView.leftAnchor),
        wrapperView.rightAnchor.constraint(greaterThanOrEqualTo: innerView.rightAnchor)
    ])
    return wrapperView
}

func createDividerLine(color: UIColor = UIColor.gray) -> UIView {
    // 1-pixel divider line
    let dividerLine = UIView()
    dividerLine.backgroundColor = color
    dividerLine.frame = CGRect(x:0,y:0,width:1000, height:1.0)
    dividerLine.heightAnchor.constraint(equalToConstant: 1.0).isActive = true
    return dividerLine
}

@discardableResult func addDividerLineTo(_ stackView: UIStackView, color: UIColor = UIColor.gray) -> UIView {
    
    let margins = stackView.layoutMarginsGuide
    
    // 1-pixel divider line
    let dividerLine = createDividerLine(color: color)
    stackView.addArrangedSubview(dividerLine)
    stackView.addArrangedSubview(UIView())  // adding an empty view so there's something that can expand for whitespace
    dividerLine.anchor(left: margins.leftAnchor, right: margins.rightAnchor)
    
    return dividerLine
}

func getBuildDetails() -> String {
    var buildDetails = ""
    
//    let version: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? "(null)"
//    buildDetails += "build #\(version)"
    
    if let moreDetailsPath = Bundle.main.path(forResource: "buildInfo", ofType: "txt") {
        let moreDetailsText = try? String(contentsOfFile: moreDetailsPath)
        if (!isNilOrEmptyOrWhitespace(moreDetailsText)) {
            buildDetails += "\(moreDetailsText!)"
        } else {
            buildDetails += "(build details not found)"
        }
    }
    
    return buildDetails.trimmingCharacters(in: .whitespacesAndNewlines)
}
