import ActivityKit
import Foundation

struct DynamicIslandActivityAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        var kind: String
        var title: String
        var subtitle: String
        var symbol: String
        var progress: Double

        init(kind: String, title: String, subtitle: String, symbol: String, progress: Double = 0) {
            self.kind = kind
            self.title = title
            self.subtitle = subtitle
            self.symbol = symbol
            self.progress = progress
        }
    }

    var appName: String
    var deepLink: String
}
