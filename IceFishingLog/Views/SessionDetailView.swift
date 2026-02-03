import SwiftUI

struct SessionDetailView: View {
    let date: Date
    let catches: [Catch]
    @Binding var isPresented: Bool
    @ObservedObject var dataManager = DataManager.shared
    
    private var sortedCatches: [Catch] {
        catches.sorted { $0.catchTime > $1.catchTime }
    }
    
    private var totalWeight: Int {
        catches.reduce(0) { $0 + $1.weight }
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMMM d, yyyy"
        return formatter
    }
    
    var body: some View {
        ZStack {
            // Background
            Color(red: 0.95, green: 0.97, blue: 0.99)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                headerView
                
                // Stats
                statsBar
                
                // Catches list
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(sortedCatches) { catchItem in
                            CatchCard(catchItem: catchItem)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                    .padding(.bottom, 40)
                }
            }
        }
    }
    
    private var headerView: some View {
        VStack(spacing: 4) {
            HStack {
                Button(action: {
                    withAnimation {
                        isPresented = false
                    }
                }) {
                    HStack(spacing: 4) {
                        Text("←")
                            .font(.system(size: 20, weight: .medium))
                        Text("Back")
                            .font(.system(size: 16, weight: .medium))
                    }
                    .foregroundColor(Color(red: 0.2, green: 0.5, blue: 0.8))
                }
                
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.top, 12)
            
            Text(dateFormatter.string(from: date))
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(Color(red: 0.1, green: 0.15, blue: 0.25))
                .padding(.top, 8)
                .padding(.bottom, 12)
        }
        .background(Color.white)
    }
    
    private var statsBar: some View {
        HStack(spacing: 0) {
            statItem(value: "\(catches.count)", label: "Fish")
            
            Divider()
                .frame(height: 30)
            
            statItem(value: dataManager.displayWeight(totalWeight), label: "Total Weight")
            
            Divider()
                .frame(height: 30)
            
            let speciesCount = Set(catches.map { $0.species }).count
            statItem(value: "\(speciesCount)", label: "Species")
        }
        .padding(.vertical, 12)
        .background(Color.white)
    }
    
    private func statItem(value: String, label: String) -> some View {
        VStack(spacing: 2) {
            Text(value)
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(Color(red: 0.2, green: 0.5, blue: 0.8))
            
            Text(label)
                .font(.system(size: 12))
                .foregroundColor(Color(red: 0.5, green: 0.55, blue: 0.6))
        }
        .frame(maxWidth: .infinity)
    }
}
