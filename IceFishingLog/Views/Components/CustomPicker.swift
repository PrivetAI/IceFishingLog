import SwiftUI

struct CustomPicker<T: Hashable>: View {
    let title: String
    let options: [T]
    @Binding var selection: T
    let displayName: (T) -> String
    
    @State private var isExpanded = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(Color(red: 0.4, green: 0.45, blue: 0.55))
            
            VStack(spacing: 0) {
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        isExpanded.toggle()
                    }
                }) {
                    HStack {
                        Text(displayName(selection))
                            .font(.system(size: 16))
                            .foregroundColor(Color(red: 0.1, green: 0.15, blue: 0.25))
                        
                        Spacer()
                        
                        Image(systemName: "chevron.down")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(Color(red: 0.5, green: 0.55, blue: 0.6))
                            .rotationEffect(.degrees(isExpanded ? 180 : 0))
                    }
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
                
                if isExpanded {
                    ScrollView {
                        VStack(spacing: 0) {
                            ForEach(options, id: \.self) { option in
                                Button(action: {
                                    selection = option
                                    withAnimation(.easeInOut(duration: 0.2)) {
                                        isExpanded = false
                                    }
                                }) {
                                    HStack {
                                        Text(displayName(option))
                                            .font(.system(size: 15))
                                            .foregroundColor(option == selection ?
                                                Color(red: 0.2, green: 0.5, blue: 0.8) :
                                                Color(red: 0.2, green: 0.25, blue: 0.3))
                                        
                                        Spacer()
                                        
                                        if option == selection {
                                            Circle()
                                                .fill(Color(red: 0.2, green: 0.5, blue: 0.8))
                                                .frame(width: 8, height: 8)
                                        }
                                    }
                                    .padding(.horizontal, 14)
                                    .padding(.vertical, 10)
                                    .background(Color.white)
                                }
                                
                                if option != options.last {
                                    Divider()
                                        .padding(.horizontal, 10)
                                }
                            }
                        }
                    }
                    .frame(maxHeight: 200)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.white)
                            .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
                    )
                    .padding(.top, 4)
                }
            }
        }
    }
}
