//
//  Extensions.swift
//
//  Created by Rob Busack on 7/22/2020.
//  Copyright © 2020 General UI. All rights reserved.
//

import Foundation
import UIKit

///////////////////////////////////////////////////////////////////////////////////////////////////
extension UIView {
    var isVisible: Bool {
        get { return !self.isHidden }
        set { self.isHidden = !newValue }
    }
    
    func anchor(top: NSLayoutYAxisAnchor?, left: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, right: NSLayoutXAxisAnchor?,  paddingTop: CGFloat = 0, paddingLeft: CGFloat = 0, paddingBottom: CGFloat = 0, paddingRight: CGFloat = 0, width: CGFloat = 0, height: CGFloat = 0) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            self.topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        
        if let left = left {
            self.leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
        }
        
        if let right = right {
            rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }
        
        if width != 0 {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if height != 0 {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
    
    func anchorSame(_ otherView: UIView) {
        self.anchor(top: otherView.topAnchor, left: otherView.leftAnchor, bottom: otherView.bottomAnchor, right: otherView.rightAnchor)
    }
    
    func anchorWithinMargins(_ otherView: UIView) {
        let margins = otherView.layoutMarginsGuide
        self.anchor(top: margins.topAnchor, left: margins.leftAnchor, bottom: margins.bottomAnchor, right: margins.rightAnchor)
    }
    
    func anchorCenteredIn(_ otherView: UIView) {
        self.anchor(centerX: otherView.centerXAnchor, centerY: otherView.centerYAnchor)
    }
    
    func anchorLargerThan(_ otherView: UIView) {
        self.translatesAutoresizingMaskIntoConstraints = false
        otherView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            otherView.topAnchor.constraint(greaterThanOrEqualToSystemSpacingBelow: self.topAnchor, multiplier: 1),
            self.bottomAnchor.constraint(greaterThanOrEqualToSystemSpacingBelow: otherView.bottomAnchor, multiplier: 1),
            otherView.leftAnchor.constraint(greaterThanOrEqualToSystemSpacingAfter: self.leftAnchor, multiplier: 1),
            self.rightAnchor.constraint(greaterThanOrEqualToSystemSpacingAfter: otherView.rightAnchor, multiplier: 1)
            ])
    }
    
    func anchor(left: NSLayoutXAxisAnchor?, right: NSLayoutXAxisAnchor?, paddingLeft: CGFloat = 0, paddingRight: CGFloat = 0) {
        self.anchor(top:nil, left:left, bottom:nil, right:right, paddingTop:0, paddingLeft:paddingLeft, paddingBottom: 0, paddingRight: paddingRight, width: 0, height: 0)
    }
    
    func anchor(top: NSLayoutYAxisAnchor?, bottom: NSLayoutYAxisAnchor?, paddingTop: CGFloat = 0, paddingBottom: CGFloat = 0) {
        self.anchor(top:top, left:nil, bottom:bottom, right:nil, paddingTop: paddingTop, paddingLeft:0, paddingBottom: paddingBottom, paddingRight: 0, width: 0, height: 0)
    }
    
    func anchor(centerX: NSLayoutXAxisAnchor?, centerY: NSLayoutYAxisAnchor?) {
        self.anchor(centerX:centerX, centerY:centerY, width:nil, height:nil)
    }
    
    func anchor(centerX: NSLayoutXAxisAnchor?, centerY: NSLayoutYAxisAnchor?, width: CGFloat? = nil, height: CGFloat? = nil) {
        translatesAutoresizingMaskIntoConstraints = false
        if let centerX = centerX {
            centerXAnchor.constraint(equalTo:centerX).isActive = true
        }
        if let centerY = centerY {
            centerYAnchor.constraint(equalTo:centerY).isActive = true
        }
        if width != nil {
            widthAnchor.constraint(equalToConstant: width!).isActive = true
        }
        
        if height != nil {
            heightAnchor.constraint(equalToConstant: height!).isActive = true
        }
    }
    
    func removeAllConstraints() {
        self.removeConstraints(self.constraints)
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
extension UIButton {
    
    func setTitleForAllStates(_ title: String) {
        self.setTitle(title, for: .normal)
        self.setTitle(title, for: .selected)
        self.setTitle(title, for: .highlighted)
        self.setTitle(title, for: .disabled)
    }
    
    func setTitleColor(normal: UIColor, highlighted: UIColor, disabled: UIColor = .lightGray ) {
        self.setTitleColor(normal, for: .normal)
        self.setTitleColor(highlighted, for: .highlighted)
        self.setTitleColor(disabled, for: .disabled)
    }
    
    func setTitleColorForAllStates(_ color: UIColor) {
        self.setTitleColor(normal: color, highlighted: color, disabled: color)
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
extension UIColor {
    
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat = 1) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: alpha)
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
extension String {
    
    func appendPeriodIfNecessary() -> String {
        if (self.hasSuffix(".") || self.hasSuffix("?") || self.hasSuffix("!")) {
            return self
        } else {
            return self + "."
        }
    }
    
    // thanks to https://medium.com/@Bitomule/getting-text-size-on-ios-bdae7521822f
    func sizeToDraw(withFont font:UIFont, inWidth width:CGFloat) -> CGSize {
        let attributes = [NSAttributedString.Key.font: font,]
        let attString = NSAttributedString(string:self, attributes:attributes)
        let framesetter = CTFramesetterCreateWithAttributedString(attString)
        return CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRange(location: 0,length: 0), nil, CGSize(width: width, height: CGFloat.greatestFiniteMagnitude), nil)
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
extension Date {
    static func timestamp() -> String {
        return Date().timestamp()
    }
    func timestamp() -> String {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        return df.string(from: self)
    }
    
    static func timestampFlipped() -> String {
        let df = DateFormatter()
        df.dateFormat = "HH:mm:ss.SSS yyyy-MM-dd"
        return df.string(from: Date())
    }
    
    func isMidnightLocally() -> Bool {
        return self == DateUtil.dateMidnightFloorLocalTimezone(self)
    }
    
    func isOnSameDayAs(_ otherDate: Date) -> Bool {
        //return DateUtil.dateMidnightFloorLocalTimezone(self) == DateUtil.dateMidnightFloorLocalTimezone(otherDate)
        return Calendar.current.isDate(self, inSameDayAs:otherDate)
    }
    
    func isBefore(_ otherDate: Date) -> Bool {
        return self.compare(otherDate) == .orderedAscending
    }
    
    func isAfter(_ otherDate: Date) -> Bool {
        return self.compare(otherDate) == .orderedDescending
    }
    
    func isWithinLast(_ seconds: TimeInterval) -> Bool {
        return self.isAfter( Date().addingTimeInterval(-1 * seconds) )
    }
    
    func secondsBetween(_ otherDate: Date) -> TimeInterval {
        return abs( self.timeIntervalSince(otherDate) )
    }
    
    init(y: Int, m: Int, d: Int, hr: Int = 0, min: Int = 0, sec: Int = 0, timeZone: TimeZone? = nil) {
        var calendar = Calendar(identifier: .gregorian)
        if let timeZone = timeZone {
            calendar.timeZone = timeZone
        }
        let components = DateComponents(year: y, month: m, day: d, hour: hr, minute: min, second: sec)
        let myDate = calendar.date(from: components)!
        self.init(timeInterval: 0, since: myDate)
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// thanks to https://medium.com/if-let-swift-programming/swift-array-removing-duplicate-elements-128a9d0ab8be
extension Array where Element: Equatable {
    mutating func removeDuplicates() {
        var result = [Element]()
        for value in self {
            if !result.contains(value) {
                result.append(value)
            }
        }
        self = result
    }
}
