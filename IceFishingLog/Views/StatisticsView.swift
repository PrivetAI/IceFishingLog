import SwiftUI

struct StatisticsView: View {
    @ObservedObject var dataManager = DataManager.shared
    @State private var selectedTab = 0
    
    var body: some View {
        ZStack {
            // Background
            Color(red: 0.95, green: 0.97, blue: 0.99)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                Text("Statistics")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(Color(red: 0.1, green: 0.15, blue: 0.25))
                    .padding(.top, 16)
                    .padding(.bottom, 12)
                
                // Tab selector
                tabSelector
                
                // Tab content
                TabView(selection: $selectedTab) {
                    seasonTab.tag(0)
                    speciesTab.tag(1)
                    recordsTab.tag(2)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            }
        }
    }
    
    private var tabSelector: some View {
        HStack(spacing: 0) {
            tabButton(title: "Season", index: 0)
            tabButton(title: "Species", index: 1)
            tabButton(title: "Records", index: 2)
        }
        .padding(4)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
        )
        .padding(.horizontal, 16)
        .padding(.bottom, 8)
    }
    
    private func tabButton(title: String, index: Int) -> some View {
        Button(action: {
            withAnimation(.easeInOut(duration: 0.2)) {
                selectedTab = index
            }
        }) {
            Text(title)
                .font(.system(size: 14, weight: selectedTab == index ? .semibold : .medium))
                .foregroundColor(selectedTab == index ? .white : Color(red: 0.4, green: 0.45, blue: 0.55))
                .padding(.vertical, 10)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(selectedTab == index ?
                            Color(red: 0.2, green: 0.5, blue: 0.8) :
                            Color.clear)
                )
        }
    }
    
    // MARK: - Season Tab
    
    private var seasonCatches: [Catch] {
        dataManager.currentSeasonCatches()
    }
    
    private var seasonTotalWeight: Int {
        seasonCatches.reduce(0) { $0 + $1.weight }
    }
    
    private var seasonTab: some View {
        ScrollView {
            VStack(spacing: 14) {
                // Season summary
                LargeStatCard(
                    title: "Current Season",
                    mainValue: "\(seasonCatches.count)",
                    secondaryValue: "Fish caught this season",
                    details: [
                        (label: "Total Weight", value: dataManager.displayWeight(seasonTotalWeight)),
                        (label: "Days on Ice", value: "\(dataManager.daysOnIce())")
                    ],
                    iconEmoji: "❄️"
                )
                
                // Best day
                bestDayCard
                
                Spacer(minLength: 100)
            }
            .padding(.horizontal, 16)
            .padding(.top, 12)
        }
    }
    
    @ViewBuilder
    private var bestDayCard: some View {
        if let best = dataManager.bestDay() {
            LargeStatCard(
                title: "Best Day This Season",
                mainValue: dataManager.displayWeight(best.weight),
                secondaryValue: formatDate(best.date),
                details: [
                    (label: "Fish Count", value: "\(best.count)")
                ],
                iconEmoji: "🌟"
            )
        }
    }
    
    // MARK: - Species Tab
    
    private var speciesStats: [(species: String, count: Int, totalWeight: Int, biggest: Catch?)] {
        dataManager.speciesStats()
    }
    
    private var speciesTab: some View {
        ScrollView {
            VStack(spacing: 12) {
                if speciesStats.isEmpty {
                    emptySpeciesView
                } else {
                    ForEach(speciesStats.indices, id: \.self) { index in
                        speciesCard(stat: speciesStats[index], rank: index + 1)
                    }
                }
                
                Spacer(minLength: 100)
            }
            .padding(.horizontal, 16)
            .padding(.top, 12)
        }
    }
    
    private func speciesCard(stat: (species: String, count: Int, totalWeight: Int, biggest: Catch?), rank: Int) -> some View {
        HStack(spacing: 14) {
            // Rank
            Text("#\(rank)")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(rank <= 3 ? Color(red: 0.9, green: 0.65, blue: 0.2) : Color(red: 0.5, green: 0.55, blue: 0.6))
                .frame(width: 36)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(stat.species)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(Color(red: 0.1, green: 0.15, blue: 0.25))
                
                HStack(spacing: 12) {
                    Text("\(stat.count) fish")
                        .font(.system(size: 14))
                        .foregroundColor(Color(red: 0.4, green: 0.45, blue: 0.55))
                    
                    Text(dataManager.displayWeight(stat.totalWeight))
                        .font(.system(size: 14))
                        .foregroundColor(Color(red: 0.4, green: 0.45, blue: 0.55))
                }
            }
            
            Spacer()
            
            if let biggest = stat.biggest {
                VStack(alignment: .trailing, spacing: 2) {
                    Text("Biggest")
                        .font(.system(size: 11))
                        .foregroundColor(Color(red: 0.6, green: 0.65, blue: 0.7))
                    
                    Text(dataManager.displayWeight(biggest.weight))
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(Color(red: 0.2, green: 0.5, blue: 0.8))
                }
            }
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.06), radius: 8, x: 0, y: 3)
        )
    }
    
    private var emptySpeciesView: some View {
        VStack(spacing: 16) {
            Text("🐟")
                .font(.system(size: 48))
            
            Text("No species data yet")
                .font(.system(size: 16))
                .foregroundColor(Color(red: 0.5, green: 0.55, blue: 0.6))
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 60)
    }
    
    // MARK: - Records Tab
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        return formatter.string(from: date)
    }
    
    private var recordsTab: some View {
        ScrollView {
            VStack(spacing: 14) {
                biggestCatchCard
                bestDayEverCard
                mostFishCard
                
                if dataManager.catches.isEmpty {
                    emptyRecordsView
                }
                
                Spacer(minLength: 100)
            }
            .padding(.horizontal, 16)
            .padding(.top, 12)
        }
    }
    
    @ViewBuilder
    private var biggestCatchCard: some View {
        if let biggest = dataManager.biggestCatchEver() {
            LargeStatCard(
                title: "Biggest Catch Ever",
                mainValue: dataManager.displayWeight(biggest.weight),
                secondaryValue: biggest.species,
                details: [
                    (label: "Size", value: dataManager.displayLength(biggest.size)),
                    (label: "Date", value: formatDate(biggest.catchTime))
                ],
                iconEmoji: "🏆"
            )
        }
    }
    
    @ViewBuilder
    private var bestDayEverCard: some View {
        if let bestDay = dataManager.bestDay() {
            LargeStatCard(
                title: "Best Day Ever (by weight)",
                mainValue: dataManager.displayWeight(bestDay.weight),
                secondaryValue: formatDate(bestDay.date),
                details: [
                    (label: "Fish Count", value: "\(bestDay.count)")
                ],
                iconEmoji: "⭐"
            )
        }
    }
    
    @ViewBuilder
    private var mostFishCard: some View {
        if let mostFish = dataManager.mostFishInOneDay() {
            LargeStatCard(
                title: "Most Fish in One Day",
                mainValue: "\(mostFish.count)",
                secondaryValue: formatDate(mostFish.date),
                details: [],
                iconEmoji: "🎯"
            )
        }
    }
    
    private var emptyRecordsView: some View {
        VStack(spacing: 16) {
            Text("🏆")
                .font(.system(size: 48))
            
            Text("No records yet")
                .font(.system(size: 16))
                .foregroundColor(Color(red: 0.5, green: 0.55, blue: 0.6))
            
            Text("Start logging catches to track your records!")
                .font(.system(size: 14))
                .foregroundColor(Color(red: 0.6, green: 0.65, blue: 0.7))
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 40)
    }
}
