import SwiftUI

struct StatCard: View {
    let title: String
    let value: String
    let subtitle: String?
    var color: Color = Color(red: 0.2, green: 0.5, blue: 0.8)
    
    init(title: String, value: String, subtitle: String? = nil, color: Color = Color(red: 0.2, green: 0.5, blue: 0.8)) {
        self.title = title
        self.value = value
        self.subtitle = subtitle
        self.color = color
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(Color(red: 0.5, green: 0.55, blue: 0.6))
            
            Text(value)
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(color)
            
            if let subtitle = subtitle {
                Text(subtitle)
                    .font(.system(size: 13))
                    .foregroundColor(Color(red: 0.6, green: 0.65, blue: 0.7))
                    .lineLimit(2)
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.06), radius: 8, x: 0, y: 3)
        )
    }
}

struct LargeStatCard: View {
    let title: String
    let mainValue: String
    let secondaryValue: String?
    let details: [(label: String, value: String)]
    var iconEmoji: String = "🏆"
    
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(Color(red: 0.2, green: 0.25, blue: 0.35))
                
                Spacer()
                
                Text(iconEmoji)
                    .font(.system(size: 24))
            }
            
            Text(mainValue)
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(Color(red: 0.2, green: 0.5, blue: 0.8))
            
            if let secondary = secondaryValue {
                Text(secondary)
                    .font(.system(size: 15))
                    .foregroundColor(Color(red: 0.5, green: 0.55, blue: 0.6))
            }
            
            if !details.isEmpty {
                Divider()
                    .padding(.vertical, 4)
                
                ForEach(details.indices, id: \.self) { index in
                    HStack {
                        Text(details[index].label)
                            .font(.system(size: 14))
                            .foregroundColor(Color(red: 0.5, green: 0.55, blue: 0.6))
                        
                        Spacer()
                        
                        Text(details[index].value)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(Color(red: 0.2, green: 0.25, blue: 0.35))
                    }
                }
            }
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.08), radius: 12, x: 0, y: 5)
        )
    }
}
