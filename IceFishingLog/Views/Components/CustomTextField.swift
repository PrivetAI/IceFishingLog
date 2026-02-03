import SwiftUI

struct CustomTextField: View {
    let title: String
    @Binding var text: String
    var keyboardType: UIKeyboardType = .default
    var placeholder: String = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(Color(red: 0.4, green: 0.45, blue: 0.55))
            
            TextField(placeholder, text: $text)
                .keyboardType(keyboardType)
                .font(.system(size: 16))
                .foregroundColor(Color(red: 0.1, green: 0.15, blue: 0.25))
                .padding(.horizontal, 14)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(red: 0.95, green: 0.96, blue: 0.98))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color(red: 0.85, green: 0.88, blue: 0.92), lineWidth: 1)
                )
        }
    }
}

struct CustomTextEditor: View {
    let title: String
    @Binding var text: String
    var placeholder: String = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(Color(red: 0.4, green: 0.45, blue: 0.55))
            
            ZStack(alignment: .topLeading) {
                if text.isEmpty {
                    Text(placeholder)
                        .font(.system(size: 16))
                        .foregroundColor(Color(red: 0.6, green: 0.65, blue: 0.7))
                        .padding(.horizontal, 14)
                        .padding(.vertical, 12)
                }
                
                TextEditor(text: $text)
                    .font(.system(size: 16))
                    .foregroundColor(Color(red: 0.1, green: 0.15, blue: 0.25))
                    .frame(minHeight: 80)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 8)
            }
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(red: 0.95, green: 0.96, blue: 0.98))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color(red: 0.85, green: 0.88, blue: 0.92), lineWidth: 1)
            )
        }
    }
}
