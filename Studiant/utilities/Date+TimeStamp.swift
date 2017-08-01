//
//  Date+TimeStamp.swift
//  Studiant
//
//  Created by Lucas REYRE on 25/07/2017.
//  Copyright © 2017 Studiant. All rights reserved.
//

import Foundation


extension Date {
    var ticks: UInt64 {
        return UInt64((self.timeIntervalSince1970 + 62_135_596_800) * 10_000_000)
    }
}
