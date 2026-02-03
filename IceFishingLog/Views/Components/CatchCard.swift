import SwiftUI

struct CatchCard: View {
    let catchItem: Catch
    @ObservedObject var dataManager = DataManager.shared
    
    private var timeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }
    
    var body: some View {
        HStack(spacing: 14) {
            // Fish icon circle
            Circle()
                .fill(
                    LinearGradient(
                        colors: [
                            Color(red: 0.3, green: 0.6, blue: 0.85),
                            Color(red: 0.2, green: 0.45, blue: 0.7)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 48, height: 48)
                .overlay(
                    Text("🐟")
                        .font(.system(size: 22))
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(catchItem.species)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(Color(red: 0.1, green: 0.15, blue: 0.25))
                
                HStack(spacing: 12) {
                    Text(dataManager.displayWeight(catchItem.weight))
                        .font(.system(size: 14))
                        .foregroundColor(Color(red: 0.4, green: 0.45, blue: 0.55))
                    
                    Text(dataManager.displayLength(catchItem.size))
                        .font(.system(size: 14))
                        .foregroundColor(Color(red: 0.4, green: 0.45, blue: 0.55))
                }
                
                if let notes = catchItem.notes, !notes.isEmpty {
                    Text(notes)
                        .font(.system(size: 13))
                        .foregroundColor(Color(red: 0.5, green: 0.55, blue: 0.6))
                        .lineLimit(1)
                }
            }
            
            Spacer()
            
            Text(timeFormatter.string(from: catchItem.catchTime))
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(Color(red: 0.5, green: 0.55, blue: 0.6))
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.06), radius: 8, x: 0, y: 3)
        )
    }
}
