import SwiftUI

struct PrimaryButton: View {
    let title: String
    let action: () -> Void
    var isWide: Bool = true
    var backgroundColor: Color = Color(red: 0.2, green: 0.5, blue: 0.8)
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(.white)
                .frame(maxWidth: isWide ? .infinity : nil)
                .padding(.horizontal, 24)
                .padding(.vertical, 14)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(backgroundColor)
                        .shadow(color: backgroundColor.opacity(0.4), radius: 8, x: 0, y: 4)
                )
        }
    }
}

struct SecondaryButton: View {
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(Color(red: 0.2, green: 0.5, blue: 0.8))
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color(red: 0.2, green: 0.5, blue: 0.8), lineWidth: 1.5)
                )
        }
    }
}
