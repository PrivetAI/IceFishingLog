import SwiftUI

struct TodayView: View {
    @ObservedObject var dataManager = DataManager.shared
    @Binding var showAddCatch: Bool
    
    private var todayCatches: [Catch] {
        dataManager.todayCatches()
    }
    
    private var totalWeight: Int {
        todayCatches.reduce(0) { $0 + $1.weight }
    }
    
    private var speciesCount: Int {
        Set(todayCatches.map { $0.species }).count
    }
    
    var body: some View {
        ZStack {
            // Background
            Color(red: 0.95, green: 0.97, blue: 0.99)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                headerView
                
                if todayCatches.isEmpty {
                    emptyStateView
                } else {
                    // Stats bar
                    statsBar
                    
                    // Catches list
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(todayCatches) { catchItem in
                                CatchCard(catchItem: catchItem)
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 16)
                        .padding(.bottom, 100)
                    }
                }
            }
            
            // Floating add button
            VStack {
                Spacer()
                addButton
            }
        }
    }
    
    private var headerView: some View {
        VStack(spacing: 4) {
            Text("Today")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(Color(red: 0.1, green: 0.15, blue: 0.25))
            
            Text(formattedDate)
                .font(.system(size: 15))
                .foregroundColor(Color(red: 0.5, green: 0.55, blue: 0.6))
        }
        .padding(.top, 16)
        .padding(.bottom, 12)
    }
    
    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMMM d"
        return formatter.string(from: Date())
    }
    
    private var statsBar: some View {
        HStack(spacing: 0) {
            statItem(value: "\(todayCatches.count)", label: "Fish")
            
            Divider()
                .frame(height: 30)
            
            statItem(value: dataManager.displayWeight(totalWeight), label: "Weight")
            
            Divider()
                .frame(height: 30)
            
            statItem(value: "\(speciesCount)", label: "Species")
        }
        .padding(.vertical, 12)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.04), radius: 6, x: 0, y: 2)
        .padding(.horizontal, 16)
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
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Circle()
                .fill(
                    LinearGradient(
                        colors: [
                            Color(red: 0.85, green: 0.9, blue: 0.95),
                            Color(red: 0.75, green: 0.85, blue: 0.92)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 100, height: 100)
                .overlay(
                    Text("🎣")
                        .font(.system(size: 44))
                )
            
            VStack(spacing: 8) {
                Text("No catches yet")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(Color(red: 0.2, green: 0.25, blue: 0.35))
                
                Text("Start logging your catch\nto track your progress")
                    .font(.system(size: 15))
                    .foregroundColor(Color(red: 0.5, green: 0.55, blue: 0.6))
                    .multilineTextAlignment(.center)
            }
            
            // Add button here in empty state
            Button(action: {
                showAddCatch = true
            }) {
                Text("+ Log Your First Catch")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 14)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(red: 0.95, green: 0.5, blue: 0.2))
                    )
            }
            .padding(.top, 20)
            
            Spacer()
        }
        .padding(.bottom, 80)
    }
    
    private var addButton: some View {
        Button(action: {
            showAddCatch = true
        }) {
            HStack(spacing: 8) {
                Text("+")
                    .font(.system(size: 24, weight: .bold))
                Text("Log Catch")
                    .font(.system(size: 17, weight: .semibold))
            }
            .foregroundColor(.white)
            .padding(.horizontal, 28)
            .padding(.vertical, 16)
            .background(
                Capsule()
                    .fill(
                        LinearGradient(
                            colors: [
                                Color(red: 0.95, green: 0.5, blue: 0.2),
                                Color(red: 0.9, green: 0.35, blue: 0.15)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .shadow(color: Color(red: 0.9, green: 0.35, blue: 0.15).opacity(0.5), radius: 12, x: 0, y: 6)
            )
        }
        .padding(.bottom, 90)
    }
}
