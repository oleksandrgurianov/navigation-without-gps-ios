import SwiftUI
import AVFoundation

class FeedbackManager {
    private let feedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
    private var isInRange = false
    private var audioPlayer: AVAudioPlayer?
    
    func playHaptics(_ heading: Double) {
        if abs(heading) < 26 && isInRange == false {
            isInRange = true
            feedbackGenerator.impactOccurred()
        } else if abs(heading) >= 26 && isInRange == true {
            isInRange = false
            feedbackGenerator.impactOccurred()
        }
    }
    
    func playAudio(_ distance: Double) {
        if distance < 300 {
            let path = Bundle.main.path(forResource: "alert", ofType: "mp3")!
            let url = URL(fileURLWithPath: path)

            do {
                audioPlayer = try AVAudioPlayer(contentsOf: url)
                audioPlayer?.numberOfLoops = -1
                audioPlayer?.play()
            } catch { return }
        }
    }
}
