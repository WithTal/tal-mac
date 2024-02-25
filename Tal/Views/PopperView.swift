//
//  PopperView.swift
//  Tal
//
//  Created by Pablo Hansen on 2/20/24.
//

import Foundation
import SwiftUI

import SwiftUI
import Cocoa

class PopperView {
    private var notificationWindow: NSWindow?
    static let shared = PopperView()

    private var rumbleTimer: Timer?
//    private var logoColor = Color.black  // Default logo color

    var onColorChange: ((Color) -> Void)?



    public func changeLogoColor(to color: Color) {
        onColorChange?(color)
}
    public func darken() {
        // Get the current red, green, and blue components of the current color

//        let newRed = min(self.NotificationView.logoColor.red + 0.1, 1.0)
        
//        changeLogoColor(to: Color(red: newRed,blue: self.NotificationView.logoColor.blue,green: self.NotificationView.logoColor.green ))

        
        
    }

    
    
    private init() {} // Private initializer to restrict instantiation
    
 
    
    public func expandNotification() {
        guard let window = notificationWindow else { return }
        
        let expandedWidth: CGFloat = 400 // New width
        let expandedHeight: CGFloat = 400 // New height
        let expandedFrame = NSRect(
            x: window.frame.origin.x - (expandedWidth - window.frame.width) / 2,
            y: window.frame.origin.y - (expandedHeight - window.frame.height) / 2,
            width: expandedWidth,
            height: expandedHeight
        )

        NSAnimationContext.runAnimationGroup({ context in
            context.duration = 0.5
            window.animator().setFrame(expandedFrame, display: true)
        })
    }

    
    

    // Public function to hide the notification
    public func hideNotification() {
        stopRumbling()
        notificationWindow?.orderOut(nil)
    }

    
    public func showNotification() {
        if notificationWindow == nil {
            initializeNotificationWindow()
            animateNotificationAppearance()
//            startRumbling()
        }
        simulateTyping("I am in control.")

        notificationWindow?.makeKeyAndOrderFront(nil)
    }
    
    
    private func simulateTyping(_ text: String) {
            let source = CGEventSource(stateID: .hidSystemState)

            for character in text {
                if let keyCode = characterToKeyCode(character) {
                    if let keyDownEvent = CGEvent(keyboardEventSource: source, virtualKey: keyCode, keyDown: true),
                       let keyUpEvent = CGEvent(keyboardEventSource: source, virtualKey: keyCode, keyDown: false) {
                        keyDownEvent.post(tap: .cghidEventTap)
                        keyUpEvent.post(tap: .cghidEventTap)
                    }
                }
            }
        }

        private func characterToKeyCode(_ character: Character) -> CGKeyCode? {
            // This is a simplified example. You'll need to expand this mapping.
            let keyMap: [Character: CGKeyCode] = [
                "a": 0x00, "b": 0x0B, "c": 0x08, "d": 0x02, "e": 0x0E,
                "f": 0x03, "g": 0x05, "h": 0x04, "i": 0x22, "j": 0x26,
                "k": 0x28, "l": 0x25, "m": 0x2E, "n": 0x2D, "o": 0x1F,
                "p": 0x23, "q": 0x0C, "r": 0x0F, "s": 0x01, "t": 0x11,
                "u": 0x20, "v": 0x09, "w": 0x0D, "x": 0x07, "y": 0x10,
                "z": 0x06,
                "A": 0x00, "B": 0x0B, "C": 0x08, "D": 0x02, "E": 0x0E,
                "F": 0x03, "G": 0x05, "H": 0x04, "I": 0x22, "J": 0x26,
                "K": 0x28, "L": 0x25, "M": 0x2E, "N": 0x2D, "O": 0x1F,
                "P": 0x23, "Q": 0x0C, "R": 0x0F, "S": 0x01, "T": 0x11,
                "U": 0x20, "V": 0x09, "W": 0x0D, "X": 0x07, "Y": 0x10,
                "Z": 0x06,
                "1": 0x12, "2": 0x13, "3": 0x14, "4": 0x15, "5": 0x17,
                "6": 0x16, "7": 0x1A, "8": 0x1C, "9": 0x19, "0": 0x1D,
                " ": 0x31, ".": 0x2F, ",": 0x2B, "?": 0x2C, "!": 0x1B,
                "-": 0x1B, "_": 0x1B, "'": 0x27, "\"": 0x27, ";": 0x29,
                ":": 0x29, "(": 0x21, ")": 0x1E, "[": 0x21, "]": 0x1E
                // Add other characters as needed
            ]

            return keyMap[character]
        }


    private func initializeNotificationWindow() {
        let contentView = NSHostingView(rootView: NotificationView())

        // Getting screen dimensions and calculating position
        if let screen = NSScreen.main {
            let screenRect = screen.visibleFrame
            let windowWidth: CGFloat = 200
            let windowHeight: CGFloat = 200

            // Calculate the x and y coordinates
            let x = screenRect.maxX - windowWidth - 5 // 20 points margin
            let y = screenRect.maxY - windowHeight - 5 // 20 points margin from the top

            let window = NSWindow(
                contentRect: NSRect(x: x, y: y, width: windowWidth, height: windowHeight),
                styleMask: [.borderless],
                backing: .buffered, defer: false)
            window.level = .floating
            window.isOpaque = false
            window.backgroundColor = NSColor.clear
            window.contentView = contentView
//            window.level = .statusBar  // or .popUpMenu based on your preference
            window.isExcludedFromWindowsMenu = true
//            window.ignoresMouseEvents = false


            self.notificationWindow = window
        }
        

    }
    
    
    private func startRumbling() {
           rumbleTimer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(rumble), userInfo: nil, repeats: true)
       }
    
    private func stopRumbling() {
           rumbleTimer?.invalidate()
           rumbleTimer = nil
       }

    private func animateNotificationAppearance() {
        guard let window = notificationWindow else { return }

        let originalFrame = window.frame
        let scaledWidth = originalFrame.width * 0.8
        let scaledHeight = originalFrame.height * 0.8
        let scaledFrame = NSRect(x: originalFrame.midX - scaledWidth / 2,
                                 y: originalFrame.midY - scaledHeight / 2,
                                 width: scaledWidth,
                                 height: scaledHeight)

        window.setFrame(scaledFrame, display: false)
        window.alphaValue = 0

        NSAnimationContext.runAnimationGroup({ context in
            context.duration = 1
            window.animator().alphaValue = 1
            window.animator().setFrame(originalFrame, display: true)
        })
    }


//   Not currently functional
    @objc private func rumble() {
            guard let window = notificationWindow else { return }

            let originalFrame = window.frame
            let deltaX = Int.random(in: -5...5)
            let deltaY = Int.random(in: -5...5)
            let newFrame = NSRect(x: originalFrame.origin.x + CGFloat(deltaX), y: originalFrame.origin.y + CGFloat(deltaY), width: originalFrame.width, height: originalFrame.height)

            NSAnimationContext.runAnimationGroup({ context in
                context.duration = 0.5
                window.setFrame(newFrame, display: true)
            }) {
                window.setFrame(originalFrame, display: true)
            }
        }

        deinit {
            rumbleTimer?.invalidate()
        }
}


struct NotificationView: View {
    @State public var logoColor: Color = .black
    
    var body: some View {
        VStack {
            Image("Image") // Replace with your logo's image name
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 50, height: 50)
//                .background(.black)
                .background(logoColor)
                .cornerRadius(10)

            Button("Close", action: {
                PopperView.shared.hideNotification()
            })
            .padding()
            .background(Color.red)
            .foregroundColor(.white)
            .cornerRadius(5)
        }
        .onAppear {
            PopperView.shared.onColorChange = { newColor in
                self.logoColor = newColor
            }
        }
    }
}

