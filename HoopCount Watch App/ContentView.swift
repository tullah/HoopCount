import SwiftUI
import WatchKit

#if DEBUG
private struct PreviewEnvironment: EnvironmentKey {
    static let defaultValue = false
}

extension EnvironmentValues {
    var isPreview: Bool {
        get { self[PreviewEnvironment.self] }
        set { self[PreviewEnvironment.self] = newValue }
    }
}
#endif

struct ContentView: View {
    @State private var crownValue = 0.0
    @State private var team1ScoreDouble = 0.0
    @State private var team2ScoreDouble = 0.0
    @State private var accumulatedRotation = 0.0
    @State private var showingResetConfirmation = false
    @Environment(\.isPreview) private var isPreview
    @Environment(\.displayScale) private var displayScale
    
    private let fullRotation = 2 * Double.pi
    
    private var team1Score: Int {
        Int(team1ScoreDouble)
    }
    
    private var team2Score: Int {
        Int(team2ScoreDouble)
    }
    
    private var team1IsWinning: Bool {
        team1Score > team2Score
    }
    
    private var team2IsWinning: Bool {
        team2Score > team1Score
    }
    
    private var isGameTied: Bool {
        team1Score == team2Score
    }
    
    private func decrementTeam1Score() {
        withAnimation(.easeInOut(duration: 0.2)) {
            team1ScoreDouble = max(team1ScoreDouble - 1, 0)
            WKInterfaceDevice.current().play(.directionDown)
        }
    }
    
    private func decrementTeam2Score() {
        withAnimation(.easeInOut(duration: 0.2)) {
            team2ScoreDouble = max(team2ScoreDouble - 1, 0)
            WKInterfaceDevice.current().play(.directionDown)
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: geometry.size.height * 0.03) {
                ScoreView(
                    teamName: "TEAM 1",
                    score: team1Score,
                    color: .blue,
                    size: geometry.size,
                    isWinning: team1IsWinning,
                    isTied: isGameTied
                )
                .gesture(
                    DragGesture(minimumDistance: 20)
                        .onEnded { gesture in
                            if gesture.translation.width < 0 {  // Left swipe
                                decrementTeam1Score()
                            }
                        }
                )
                
                ScoreView(
                    teamName: "TEAM 2",
                    score: team2Score,
                    color: .red,
                    size: geometry.size,
                    isWinning: team2IsWinning,
                    isTied: isGameTied
                )
                .gesture(
                    DragGesture(minimumDistance: 20)
                        .onEnded { gesture in
                            if gesture.translation.width < 0 {  // Left swipe
                                decrementTeam2Score()
                            }
                        }
                )
                
                Button(action: {
                    showingResetConfirmation = true
                }) {
                    Image(systemName: "arrow.counterclockwise.circle.fill")
                        .font(.system(size: geometry.size.width * 0.1))
                        .foregroundStyle(.gray)
                        .symbolRenderingMode(.hierarchical)
                }
                .buttonStyle(.plain)
                .padding(.top, geometry.size.height * 0.02)
            }
            .padding(.horizontal, geometry.size.width * 0.03)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .focusable(true)
        .scrollIndicators(.hidden)
        .modifier(DigitalCrownModifier(
            crownValue: $crownValue,
            team1Score: $team1ScoreDouble,
            team2Score: $team2ScoreDouble,
            accumulatedRotation: $accumulatedRotation,
            fullRotation: fullRotation,
            isPreview: isPreview
        ))
        .alert("Reset Scores?", isPresented: $showingResetConfirmation) {
            Button("Reset", role: .destructive) {
                withAnimation(.easeInOut) {
                    team1ScoreDouble = 0
                    team2ScoreDouble = 0
                }
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This will set both scores to zero.")
        }
    }
}

private struct ScoreView: View {
    let teamName: String
    let score: Int
    let color: Color
    let size: CGSize
    let isWinning: Bool
    let isTied: Bool
    
    @State private var hintOffset = 0.0
    
    private var scoreColor: Color {
        if isTied {
            return .blue
        }
        return isWinning ? .green : .red
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Text(teamName)
                .font(.system(size: size.width * 0.06, weight: .bold))
                .foregroundStyle(color.opacity(0.8))
            Text("\(score)")
                .font(.system(size: size.width * 0.25, weight: .heavy))
                .foregroundStyle(scoreColor)
                .frame(height: size.height * 0.25)
                .contentTransition(.numericText())
        }
        .padding(.vertical, size.height * 0.02)
        .frame(maxWidth: .infinity)
        .background {
            RoundedRectangle(cornerRadius: size.width * 0.04)
                .fill(color.opacity(0.1))
        }
        .overlay(alignment: .trailing) {
            HStack(spacing: 4) {
                Image(systemName: "chevron.left.2")
                    .font(.system(size: size.width * 0.08, weight: .bold))
                Text("-1")
                    .font(.system(size: size.width * 0.06, weight: .semibold))
            }
            .foregroundStyle(.secondary)
            .padding(.trailing, 12)
            .offset(x: hintOffset)
            .onAppear {
                withAnimation(
                    .easeInOut(duration: 1.0)
                    .repeatForever(autoreverses: true)
                ) {
                    hintOffset = -5
                }
            }
        }
    }
}

private struct DigitalCrownModifier: ViewModifier {
    @Binding var crownValue: Double
    @Binding var team1Score: Double
    @Binding var team2Score: Double
    @Binding var accumulatedRotation: Double
    let fullRotation: Double
    let isPreview: Bool
    
    func body(content: Content) -> some View {
        if !isPreview {
            content.digitalCrownRotation($crownValue) { event in
                accumulatedRotation += abs(event.velocity)
                
                if accumulatedRotation >= fullRotation {
                    if event.velocity > 0 {
                        team1Score = min(team1Score + 1, 999)
                        WKInterfaceDevice.current().play(.click)
                    } else if event.velocity < 0 {
                        team2Score = min(team2Score + 1, 999)
                        WKInterfaceDevice.current().play(.click)
                    }
                    accumulatedRotation = 0
                }
            }
        } else {
            content
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
                .environment(\.isPreview, true)
                .previewDisplayName("41mm")
                .previewDevice("Apple Watch Series 7 - 41mm")
            
            ContentView()
                .environment(\.isPreview, true)
                .previewDisplayName("45mm")
                .previewDevice("Apple Watch Series 7 - 45mm")
            
            ContentView()
                .environment(\.isPreview, true)
                .previewDisplayName("49mm")
                .previewDevice("Apple Watch Ultra - 49mm")
        }
    }
} 
