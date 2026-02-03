import SwiftUI

struct HistoryView: View {
    @ObservedObject var dataManager = DataManager.shared
    @State private var selectedSession: (date: Date, catches: [Catch])?
    
    private var sessions: [(date: Date, catches: [Catch])] {
        dataManager.allSessions()
    }
    
    var body: some View {
        ZStack {
            // Background
            Color(red: 0.95, green: 0.97, blue: 0.99)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                Text("History")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(Color(red: 0.1, green: 0.15, blue: 0.25))
                    .padding(.top, 16)
                    .padding(.bottom, 12)
                
                if sessions.isEmpty {
                    emptyStateView
                } else {
                    ScrollView {
                        LazyVStack(spacing: 14) {
                            ForEach(sessions, id: \.date) { session in
                                Button(action: {
                                    selectedSession = session
                                }) {
                                    SessionCard(date: session.date, catches: session.catches)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 8)
                        .padding(.bottom, 100)
                    }
                }
            }
            
            // Session detail overlay
            if let session = selectedSession {
                SessionDetailView(
                    date: session.date,
                    catches: session.catches,
                    isPresented: Binding(
                        get: { selectedSession != nil },
                        set: { if !$0 { selectedSession = nil } }
                    )
                )
                .transition(.move(edge: .trailing))
            }
        }
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
                    Text("📋")
                        .font(.system(size: 44))
                )
            
            VStack(spacing: 8) {
                Text("No sessions yet")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(Color(red: 0.2, green: 0.25, blue: 0.35))
                
                Text("Your fishing sessions will\nappear here")
                    .font(.system(size: 15))
                    .foregroundColor(Color(red: 0.5, green: 0.55, blue: 0.6))
                    .multilineTextAlignment(.center)
            }
            
            Spacer()
            Spacer()
        }
    }
}
