import SwiftUI

struct AppIcon: View {
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.4, green: 0.8, blue: 1.0),
                    Color(red: 0.2, green: 0.6, blue: 0.9)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            
            // Emoji arrangement
            VStack(spacing: 10) {
                HStack(spacing: 20) {
                    Text("🌟")
                        .font(.system(size: 40))
                    Text("💫")
                        .font(.system(size: 40))
                }
                Text("✨")
                    .font(.system(size: 60))
                HStack(spacing: 20) {
                    Text("⭐️")
                        .font(.system(size: 40))
                    Text("✨")
                        .font(.system(size: 40))
                }
            }
        }
        .frame(width: 1024, height: 1024)
    }
}

#Preview {
    AppIcon()
}
