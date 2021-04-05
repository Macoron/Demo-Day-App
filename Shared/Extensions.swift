//
//  Extensions.swift
//  Demo List
//
//  Created by labsallday labsallday on 05.04.2021.
//

import Foundation

extension TimeInterval {
    var milliseconds: Int {
        return Int((truncatingRemainder(dividingBy: 1)) * 1000)
    }

    var seconds: Int {
        return Int(self) % 60
    }

    var minutes: Int {
        return (Int(self) / 60 ) % 60
    }

    var hours: Int {
        return Int(self) / 3600
    }

    var stringTime: String {
        var ret = ""
        if hours != 0 {
            ret += "\(hours)h "
        }
        if minutes != 0 {
            ret += "\(minutes)m "
        }
        if seconds != 0 {
            ret += "\(seconds)s "
        }
        if milliseconds != 0 {
            ret += "\(milliseconds)ms"
        }
        
        return ret
    }
}
