import CoreLocation

class LocationHelper {
    static func getHeading(userLocation: CLLocation, destinationLocation: CLLocation, heading: CLHeading) -> Double {
        let bearing = userLocation.direction(destinationLocation)
        let magneticHeading = heading.magneticHeading

        var heading = bearing - magneticHeading
        if heading < 0 { heading += 360 }
        else if heading >= 360 { heading -= 360 }

        return heading
    }

    static func getDistance(_ distance: Double) -> String {
        switch distance {
        case 0..<300: return ""
        case 300..<1000: return String(format: "%.0f", distance)
        default: return String(format: "%.1f", distance/1000)
        }
    }

    static func distanceFormat(_ distance: Double) -> String {
        switch distance {
        case 0..<300: return ""
        case 300..<1000: return "m"
        default: return "km"
        }
    }

    static func distanceDirection(_ distance: Double, _ heading: Double) -> String {
        if abs(heading) < 26 {
            switch distance {
                case 0..<300: return "here"
                case 300..<900: return "nearby"
                default: return "ahead"
            }
        } else {
            switch heading {
                case 26..<116: return "right"
                case 246..<336: return "left"
                default: return "back"
            }
        }
    }

    static func distanceDirectionPrefix(_ heading: Double) -> String {
        return (abs(heading) >= 26) ? "to your" : ""
    }
}
