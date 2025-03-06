# HoopCount - Apple Watch Basketball Score Counter

HoopCount is a simple yet powerful Apple Watch app designed to help basketball players, coaches, and referees keep track of game scores. The app features an intuitive interface optimized for quick score updates during fast-paced basketball games.

## Features

### Score Management
- **Digital Crown Control**: 
  - Rotate up to increment Team 1's score
  - Rotate down to increment Team 2's score
  - Haptic feedback confirms each score update

### Visual Feedback
- **Score Colors**:
  - Winning team's score appears in green
  - Losing team's score appears in red
  - Both scores appear in blue when tied
  - Large, easy-to-read numbers

### Quick Actions
- **Score Correction**:
  - Swipe left on any team's score to decrease it by 1
  - Visual indicator shows the swipe gesture
  - Haptic feedback confirms score reduction
  
- **Reset Function**:
  - Reset button to start a new game
  - Confirmation dialog prevents accidental resets
  - Animated transitions for smooth updates

## Device Support
- Apple Watch Series 4 and newer
- Optimized for all screen sizes:
  - 41mm
  - 45mm
  - 49mm (Ultra)

## Technical Details
- Built with SwiftUI
- Supports watchOS 11.2+
- Uses WatchKit for haptic feedback
- Responsive design using GeometryReader
- Implements accessibility features

## Usage Instructions

1. **Adding Points**:
   - Rotate Digital Crown up for Team 1
   - Rotate Digital Crown down for Team 2

2. **Correcting Scores**:
   - Swipe left on a team's score to subtract one point
   - Follow the animated hint indicator

3. **Resetting Game**:
   - Tap the reset button (circular arrow) at the bottom
   - Confirm reset in the dialog

## Development

### Requirements
- Xcode 16.2 or later
- watchOS 11.2 SDK
- Apple Developer account for deployment

### Key Components
- `ContentView.swift`: Main interface and logic
- `ScoreView.swift`: Score display component
- `DigitalCrownModifier`: Crown rotation handler

### Architecture
- MVVM architecture
- State management using SwiftUI
- Custom environment values for preview handling
- Gesture recognition for score decrements
- Digital Crown integration for score increments

## Installation

1. Clone the repository
2. Open HoopCount.xcodeproj in Xcode
3. Select your target Apple Watch
4. Build and run the project

## License
This project is available under the MIT license. See the LICENSE file for more info.

## Author
Created by Tariq Shafiq

## Version History
- 1.0: Initial release
  - Basic scoring functionality
  - Team score management
  - Digital Crown integration
  - Score correction gestures 