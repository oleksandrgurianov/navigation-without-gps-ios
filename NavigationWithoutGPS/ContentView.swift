import SwiftUI
import CoreLocation
import AVFoundation

struct ContentView: View {
    @StateObject var locationManager = LocationManager()
    @State private var isInRange = false
    @State private var audioPlayer: AVAudioPlayer?
    
    private let destinationLocation = CLLocation(latitude: 51.448614, longitude: 5.457256)
    private let feedbackManager = FeedbackManager()

    var body: some View {
        VStack {
            if let userLocation = locationManager.location, let heading = locationManager.heading {
                let distanceInMeters = userLocation.distance(from: destinationLocation)
                let arrowRotation = LocationHelper.getHeading(userLocation: userLocation, destinationLocation: destinationLocation, heading: heading)

                VStack(alignment: .leading) {
                    Text("FINDING")
                        .font(.system(size: 14, design: .rounded))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .opacity(0.5)

                    Text("Klokgebouw")
                        .font(.system(size: 36))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                Spacer()

                VStack {
                    Image(systemName: "circle.fill")
                        .font(.system(size: UIScreen.main.bounds.width - 345))
                        .foregroundColor(.white)
                        .opacity(abs(arrowRotation) < 26 ? 1.0 : 0.5)
                        .padding(.bottom, 36)

                    Image(systemName: "arrow.up")
                        .font(.system(size: UIScreen.main.bounds.width - 165))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .rotationEffect(Angle(degrees: arrowRotation))
                        .onChange(of: arrowRotation) { newHeading in
                            feedbackManager.playHaptics(newHeading)
                        }
                }

                Spacer()

                VStack(alignment: .leading) {
                    HStack {
                        Text(LocationHelper.getDistance(distanceInMeters))
                            .font(.system(size: 52, design: .rounded))
                            .foregroundColor(.white)
                            .onAppear { feedbackManager.playAudio(distanceInMeters) }
                            .onChange(of: distanceInMeters) { newDistance in
                                feedbackManager.playAudio(newDistance)
                            }

                        Text(LocationHelper.distanceFormat(distanceInMeters))
                            .font(.system(size: 52, design: .rounded))
                            .foregroundColor(.white)
                            .opacity(0.5)
                    }

                    HStack {
                        Text(LocationHelper.distanceDirectionPrefix(arrowRotation))
                            .font(.system(size: 52, design: .rounded))
                            .foregroundColor(.white)
                            .opacity(0.5)
                        
                        Text(LocationHelper.distanceDirection(distanceInMeters, arrowRotation))
                            .font(.system(size: 52, design: .rounded))
                            .foregroundColor(.white)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 60)
            } else {
                let text = locationManager.location == nil ? "Waiting for location..." : "Waiting for heading..."
                
                Text(text)
                    .foregroundColor(.white)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
        .background(Color.green)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
