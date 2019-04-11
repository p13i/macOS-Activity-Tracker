//
//  main.swift
//  Activity Tracker
//
//  Created by Pramod Kotipalli on 4/9/19.
//  Copyright © 2019 Pramod Kotipalli. All rights reserved.
//

import Foundation
import AppKit

let LOG_FILE = "/var/log/active_window.log"

let activeApplication = NSWorkspace.shared.frontmostApplication
let name = activeApplication?.localizedName ?? "nil"

let time = NSDate().timeIntervalSince1970

let logString = "time=\(time), name=\(name)\n"

let data = logString.data(using: .utf8)!

let fileHandle = FileHandle(forWritingAtPath: LOG_FILE)!
fileHandle.seekToEndOfFile()
fileHandle.write(data)
fileHandle.closeFile()
