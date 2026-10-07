import ActivityKit
import Combine
import Foundation

@MainActor
final class LiveActivityManager: ObservableObject {
    @Published private(set) var isRunning = false
    private var activity: Activity<DynamicIslandActivityAttributes>?

    func start(kind: String, title: String, subtitle: String, symbol: String, progress: Double = 0) {
        guard ActivityAuthorizationInfo().areActivitiesEnabled else {
            isRunning = false
            return
        }

        let attributes = DynamicIslandActivityAttributes(
            appName: "Dynamic Island 11",
            deepLink: "dynamicisland11://activity"
        )
        let state = DynamicIslandActivityAttributes.ContentState(
            kind: kind,
            title: title,
            subtitle: subtitle,
            symbol: symbol,
            progress: max(0, min(1, progress))
        )

        Task { @MainActor in
            do {
                for existing in Activity<DynamicIslandActivityAttributes>.activities {
                    await existing.end(nil, dismissalPolicy: .immediate)
                }

                let content = ActivityContent(
                    state: state,
                    staleDate: Date().addingTimeInterval(60 * 60)
                )

                activity = try Activity.request(
                    attributes: attributes,
                    content: content,
                    pushType: nil
                )
                isRunning = true
            } catch {
                isRunning = false
            }
        }
    }

    func update(kind: String, title: String, subtitle: String, symbol: String, progress: Double = 0) {
        guard let activity else { return }
        let state = DynamicIslandActivityAttributes.ContentState(
            kind: kind,
            title: title,
            subtitle: subtitle,
            symbol: symbol,
            progress: max(0, min(1, progress))
        )
        Task { @MainActor in
            let content = ActivityContent(
                state: state,
                staleDate: Date().addingTimeInterval(60 * 60)
            )
            await activity.update(content)
        }
    }

    func end() {
        guard let activity else { return }
        Task { @MainActor in
            await activity.end(nil, dismissalPolicy: .after(Date().addingTimeInterval(2)))
            self.activity = nil
            self.isRunning = false
        }
    }
}
