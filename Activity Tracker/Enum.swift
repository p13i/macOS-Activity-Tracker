//
//  Enum.swift
//  Activity Tracker
//
//  Created by System Administrator on 7/4/19.
//  Copyright © 2019 Pramod Kotipalli. All rights reserved.
//

import Foundation

/**
 * Extend all enums with a simple method to derive their names.
 */
extension RawRepresentable where RawValue: Any {
    /**
     * The name of the enumeration (as written in case).
     */
    var name: String {
        get { return String(describing: self) }
    }
    
    /**
     * The full name of the enumeration
     * (the name of the enum plus dot plus the name as written in case).
     */
    var description: String {
        get { return String(reflecting: self) }
    }
}
