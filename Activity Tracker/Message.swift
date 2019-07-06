//
//  Message.swift
//  Activity Tracker
//
//  Created by System Administrator on 7/5/19.
//  Copyright © 2019 Pramod Kotipalli. All rights reserved.
//

import Foundation

class Message {
    let now: Date
    let text: String
    init(_ text: String) {
        self.now = Date()
        self.text = text
    }
    
}
