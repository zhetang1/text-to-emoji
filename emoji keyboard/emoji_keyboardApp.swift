//
//  emoji_keyboardApp.swift
//  emoji keyboard
//
//  Created by zhe on 12/13/24.
//

import SwiftUI

@main
struct emoji_keyboardApp: App {
    init() {
        #if DEBUG
        // Only generate icon in debug builds
        Task {
            await AppIconGenerator.generateIcon()
        }
        #endif
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
