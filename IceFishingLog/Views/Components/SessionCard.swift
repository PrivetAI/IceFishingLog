import SwiftUI

struct SessionCard: View {
    let date: Date
    let catches: [Catch]
    @ObservedObject var dataManager = DataManager.shared
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d"
        return formatter
    }
    
    private var totalWeight: Int {
        catches.reduce(0) { $0 + $1.weight }
    }
    
    private var biggestCatch: Catch? {
        catches.max { $0.weight < $1.weight }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Date header
            Text(dateFormatter.string(from: date))
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(Color(red: 0.1, green: 0.15, blue: 0.25))
            
            // Stats row
            HStack(spacing: 20) {
                StatItem(value: "\(catches.count)", label: "Fish")
                StatItem(value: dataManager.displayWeight(totalWeight), label: "Total")
                
                if let biggest = biggestCatch {
                    StatItem(
                        value: dataManager.displayWeight(biggest.weight),
                        label: "Biggest"
                    )
                }
            }
            
            // Species summary
            let speciesSet = Set(catches.map { $0.species })
            Text(speciesSet.joined(separator: ", "))
                .font(.system(size: 14))
                .foregroundColor(Color(red: 0.5, green: 0.55, blue: 0.6))
                .lineLimit(1)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.06), radius: 10, x: 0, y: 4)
        )
    }
}

private struct StatItem: View {
    let value: String
    let label: String
    
    var body: some View {
        VStack(spacing: 2) {
            Text(value)
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(Color(red: 0.2, green: 0.5, blue: 0.8))
            
            Text(label)
                .font(.system(size: 12))
                .foregroundColor(Color(red: 0.5, green: 0.55, blue: 0.6))
        }
    }
}
