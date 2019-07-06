//
//  main.swift
//  Activity Tracker
//
//  Created by Pramod Kotipalli on 7/4/19.
//  Copyright © 2019 Pramod Kotipalli. All rights reserved.
//

import Foundation
import CoreGraphics
import CoreFoundation

let console = ConsoleIO()

let arguments = CommandLine.arguments
guard arguments.count - 1 == 2 else {
    console.writeMessage("Expected 2 arguments, received \(arguments.count - 1).", to: .error)
    exit(1)
}

let activity_tracker_log = arguments[1]
let activity_tracker_stderr = arguments[2]

let documents_dir = FileIO.getDocumentsDirectory()
let log_file = FileIO(documents_dir.appendingPathComponent(activity_tracker_log))
let stderr_file = FileIO(documents_dir.appendingPathComponent(activity_tracker_stderr))

let keyboardEventTypes = [
    CGEventType.keyDown,
    CGEventType.flagsChanged,
    CGEventType.keyUp,
]
let mouseEventTypes = [
    CGEventType.leftMouseDown,
    CGEventType.leftMouseUp,
    CGEventType.rightMouseDown,
    CGEventType.rightMouseUp,
    CGEventType.mouseMoved,
    CGEventType.leftMouseDragged,
    CGEventType.rightMouseDragged,
]

// The following callback method is invoked on every keypress.
func callback(proxy: CGEventTapProxy, eventType: CGEventType, event: CGEvent, ref: UnsafeMutableRawPointer?) -> Unmanaged<CGEvent>? {
    
    let now = Date()
    
    if keyboardEventTypes.contains(eventType) {
        // Retrieve the incoming keycode.
        let keyboardEventKeycode = event.getIntegerValueField(CGEventField.keyboardEventKeycode)
        
        log_file.write("time=\(now.timeIntervalSince1970), CGEventField.keyboardEventKeycode=\(keyboardEventKeycode)")
    } else if mouseEventTypes.contains(eventType) {
        let mouseEventPressure = event.getDoubleValueField(.mouseEventPressure)
        let mouseEventDeltaX = event.getDoubleValueField(.mouseEventDeltaX)
        let mouseEventDeltaY = event.getDoubleValueField(.mouseEventDeltaY)
        
        log_file.write("time=\(now.timeIntervalSince1970), CGEventField.mouseEventPressure=\(mouseEventPressure), CGEventField.mouseEventDeltaX=\(mouseEventDeltaX), CGEventField.mouseEventDeltaYe=\(mouseEventDeltaY), ")
    }
    
    return Unmanaged.passRetained(event)
}

// Create an event tap to retrieve keypresses.
var eventMask: CGEventMask = 0
for eventType in keyboardEventTypes + mouseEventTypes {
    eventMask = eventMask | (1 << eventType.rawValue)
}

// Create the event with the OS
guard let eventTap: CFMachPort = CGEvent.tapCreate(
    tap: .cgSessionEventTap,
    place: .headInsertEventTap,
    options: CGEventTapOptions(rawValue: 0)!,
    eventsOfInterest: eventMask,
    callback: callback, userInfo: nil) else {
        
    let message = "time=\(Date().timeIntervalSince1970), stderr=Failed to create event tap"
    
    console.writeMessage(message, to: .error)
    stderr_file.write(message)
    
    exit(1)
}

// Create a run loop source and add enable the event tap.
let runLoopSource: CFRunLoopSource = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, eventTap, 0)
CFRunLoopAddSource(CFRunLoopGetCurrent(), runLoopSource, CFRunLoopMode.commonModes)
CGEvent.tapEnable(tap: eventTap, enable: true)

// Display the location of the logfile and start the loop.
console.writeMessage("time=\(Date().timeIntervalSince1970), message=Logging...")

// Hold the run loop
CFRunLoopRun()
