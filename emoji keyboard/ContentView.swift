//
//  ContentView.swift
//  emoji keyboard
//
//  Created by zhe on 12/13/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("Text to Emoji Keyboard")
                .font(.title)
                .fontWeight(.bold)
            
            VStack(alignment: .leading, spacing: 15) {
                Text("How to enable the keyboard:")
                    .font(.headline)
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("1. Open Settings on your device")
                    Text("2. Go to General → Keyboard")
                    Text("3. Tap Keyboards → Add New Keyboard")
                    Text("4. Under Third-Party Keyboards, select \"Text to Emoji\"")
                    Text("5. Enable \"Allow Full Access\"")
                    Text("6. Once switched on, you will see generated emojis")
                    Text("7. Tap on the emoji to insert it into the text field")
                }
                .padding(.leading)
            }
            .padding()
            
            Spacer()
            
            Text("Type text and it will be converted to emojis!")
                .italic()
                .foregroundColor(.secondary)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
