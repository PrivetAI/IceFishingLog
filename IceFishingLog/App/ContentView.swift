import SwiftUI

struct ContentView: View {
    @State private var selectedTab: TabItem = .today
    @State private var showAddCatch = false
    
    var body: some View {
        ZStack {
            // Main content
            Group {
                switch selectedTab {
                case .today:
                    TodayView(showAddCatch: $showAddCatch)
                case .history:
                    HistoryView()
                case .statistics:
                    StatisticsView()
                case .settings:
                    SettingsView()
                }
            }
            
            // Custom tab bar
            VStack {
                Spacer()
                customTabBar
            }
            
            // Add catch sheet
            if showAddCatch {
                AddCatchView(isPresented: $showAddCatch)
                    .transition(.move(edge: .bottom))
            }
        }
        .preferredColorScheme(.light)
    }
    
    private var customTabBar: some View {
        HStack(spacing: 0) {
            ForEach(TabItem.allCases, id: \.rawValue) { tab in
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        selectedTab = tab
                    }
                }) {
                    TabIcon(tab: tab, isSelected: selectedTab == tab)
                        .frame(maxWidth: .infinity)
                }
            }
        }
        .padding(.top, 12)
        .padding(.bottom, 24)
        .background(
            Rectangle()
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.08), radius: 12, x: 0, y: -4)
        )
    }
}
