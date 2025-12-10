import SwiftUI

struct ColoredSection: View {
    
    var title: String
    var color: Color
    var emoji: String
    
    var body: some View {
        VStack(spacing: 12) {
            
            // Title
            Text(title)
                .font(.system(size: 20, weight: .semibold, design: .rounded))
                .foregroundColor(.black)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .minimumScaleFactor(0.8)
            
            // Box with emoji
            ZStack {
                RoundedRectangle(cornerRadius: 22)
                    .fill(color.opacity(0.9))
                    .frame(width: 150, height: 150)     // bigger + nicer
                    .shadow(color: .gray.opacity(0.25),
                            radius: 5, x: 0, y: 3)
                
                Text(emoji)
                    .font(.system(size: 65))            // bigger emoji
            }
        }
    }
}
