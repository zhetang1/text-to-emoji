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
            Text("✨ Text to Emoji Keyboard ✨")
                .font(.title)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
            
            Text("Turn your words into emoji magic! 🪄")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .padding(.bottom)
            
            VStack(alignment: .leading, spacing: 15) {
                Text("🚀 Quick Setup Guide")
                    .font(.headline)
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("1. 📱 Open Settings")
                    Text("2. ⚙️ Go to General → Keyboard")
                    Text("3. ⌨️ Tap Keyboards → Add New Keyboard")
                    Text("4. 🎯 Select \"Text to Emoji\"")
                    Text("5. 🔓 Enable \"Allow Full Access\"")
                    Text("6. ✨ Watch your text transform into emojis")
                    Text("7. 👆 Tap the emoji to use it!")
                }
                .padding(.leading)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color(.systemGray6))
            )
            .padding(.horizontal)
            
            Spacer()
            
            VStack(spacing: 10) {
                Text("Ready to have some fun? 🎉")
                    .font(.headline)
                Text("Type 'happy' to see magic happen! ✨")
                    .italic()
                    .foregroundColor(.secondary)
            }
            .padding()
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
