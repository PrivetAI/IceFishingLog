import SwiftUI

enum TabItem: Int, CaseIterable {
    case today = 0
    case history = 1
    case statistics = 2
    case settings = 3
    
    var title: String {
        switch self {
        case .today: return "Today"
        case .history: return "History"
        case .statistics: return "Stats"
        case .settings: return "Settings"
        }
    }
}

struct TabIcon: View {
    let tab: TabItem
    let isSelected: Bool
    
    var body: some View {
        VStack(spacing: 4) {
            iconShape
                .frame(width: 24, height: 24)
                .foregroundColor(isSelected ? 
                    Color(red: 0.2, green: 0.5, blue: 0.8) : 
                    Color(red: 0.6, green: 0.65, blue: 0.7))
            
            Text(tab.title)
                .font(.system(size: 11, weight: isSelected ? .semibold : .regular))
                .foregroundColor(isSelected ? 
                    Color(red: 0.2, green: 0.5, blue: 0.8) : 
                    Color(red: 0.6, green: 0.65, blue: 0.7))
        }
    }
    
    @ViewBuilder
    private var iconShape: some View {
        switch tab {
        case .today:
            TodayIcon()
        case .history:
            HistoryIcon()
        case .statistics:
            StatsIcon()
        case .settings:
            SettingsIcon()
        }
    }
}

// Custom drawn icons to avoid SF Symbols

struct TodayIcon: View {
    var body: some View {
        GeometryReader { geo in
            let size = min(geo.size.width, geo.size.height)
            ZStack {
                // Calendar base
                RoundedRectangle(cornerRadius: size * 0.15)
                    .stroke(lineWidth: size * 0.08)
                
                // Top bar
                Rectangle()
                    .frame(height: size * 0.2)
                    .offset(y: -size * 0.3)
                
                // Fish silhouette
                Ellipse()
                    .frame(width: size * 0.4, height: size * 0.2)
                    .offset(y: size * 0.1)
            }
        }
    }
}

struct HistoryIcon: View {
    var body: some View {
        GeometryReader { geo in
            let size = min(geo.size.width, geo.size.height)
            ZStack {
                // Clock circle
                Circle()
                    .stroke(lineWidth: size * 0.08)
                
                // Clock hands
                Path { path in
                    let center = CGPoint(x: size/2, y: size/2)
                    path.move(to: center)
                    path.addLine(to: CGPoint(x: size * 0.5, y: size * 0.25))
                    path.move(to: center)
                    path.addLine(to: CGPoint(x: size * 0.7, y: size * 0.5))
                }
                .stroke(lineWidth: size * 0.08)
                
                // Arrow
                Path { path in
                    path.move(to: CGPoint(x: size * 0.15, y: size * 0.3))
                    path.addLine(to: CGPoint(x: size * 0.05, y: size * 0.15))
                    path.addLine(to: CGPoint(x: size * 0.25, y: size * 0.15))
                }
                .stroke(lineWidth: size * 0.06)
            }
        }
    }
}

struct StatsIcon: View {
    var body: some View {
        GeometryReader { geo in
            let size = min(geo.size.width, geo.size.height)
            HStack(alignment: .bottom, spacing: size * 0.1) {
                RoundedRectangle(cornerRadius: size * 0.05)
                    .frame(width: size * 0.2, height: size * 0.4)
                
                RoundedRectangle(cornerRadius: size * 0.05)
                    .frame(width: size * 0.2, height: size * 0.7)
                
                RoundedRectangle(cornerRadius: size * 0.05)
                    .frame(width: size * 0.2, height: size * 0.55)
            }
            .frame(width: size, height: size, alignment: .bottom)
        }
    }
}

struct SettingsIcon: View {
    var body: some View {
        GeometryReader { geo in
            let size = min(geo.size.width, geo.size.height)
            ZStack {
                // Gear outer
                Circle()
                    .stroke(lineWidth: size * 0.12)
                    .frame(width: size * 0.6, height: size * 0.6)
                
                // Gear teeth
                ForEach(0..<6) { i in
                    RoundedRectangle(cornerRadius: size * 0.03)
                        .frame(width: size * 0.12, height: size * 0.2)
                        .offset(y: -size * 0.4)
                        .rotationEffect(.degrees(Double(i) * 60))
                }
                
                // Center circle
                Circle()
                    .frame(width: size * 0.2, height: size * 0.2)
            }
            .frame(width: size, height: size)
        }
    }
}
