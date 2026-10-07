import ActivityKit
import SwiftUI
import WidgetKit

struct DynamicIslandLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: DynamicIslandActivityAttributes.self) { context in
            LiveActivityLockScreenView(context: context)
                .activityBackgroundTint(.black)
                .activitySystemActionForegroundColor(.white)
                .widgetURL(URL(string: context.attributes.deepLink))
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    Image(systemName: context.state.symbol)
                        .font(.title2)
                        .foregroundStyle(.white)
                }

                DynamicIslandExpandedRegion(.center) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(context.state.title)
                            .font(.headline)
                            .lineLimit(1)
                        Text(context.state.subtitle)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .lineLimit(1)
                    }
                }

                DynamicIslandExpandedRegion(.trailing) {
                    if context.state.progress > 0 {
                        Text("\(Int(context.state.progress * 100))%")
                            .font(.caption2.monospacedDigit())
                    } else {
                        Image(systemName: "circle.fill")
                            .font(.caption2)
                    }
                }

                DynamicIslandExpandedRegion(.bottom) {
                    if context.state.kind == "music" {
                        HStack(spacing: 10) {
                            Image(systemName: "backward.fill")
                            Image(systemName: "play.fill")
                            Image(systemName: "forward.fill")
                        }
                        .font(.caption)
                        .frame(maxWidth: .infinity)
                    } else if context.state.kind == "call" {
                        HStack {
                            Image(systemName: "phone.fill")
                            Text("En curso")
                            Spacer()
                            Text(context.state.subtitle)
                        }
                        .font(.caption)
                    }
                }
            } compactLeading: {
                Image(systemName: context.state.symbol)
                    .foregroundStyle(.white)
            } compactTrailing: {
                Text(context.state.kind == "call" ? "●" : context.state.title)
                    .font(.caption2.weight(.semibold))
                    .lineLimit(1)
            } minimal: {
                Image(systemName: context.state.symbol)
                    .foregroundStyle(.white)
            }
            .keylineTint(.white.opacity(0.12))
            .widgetURL(URL(string: context.attributes.deepLink))
        }
    }
}

private struct LiveActivityLockScreenView: View {
    let context: ActivityViewContext<DynamicIslandActivityAttributes>

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: context.state.symbol)
                .font(.title3)
                .frame(width: 36, height: 36)
                .background(.white.opacity(0.12), in: Circle())

            VStack(alignment: .leading, spacing: 3) {
                Text(context.state.title)
                    .font(.headline)
                    .lineLimit(1)
                Text(context.state.subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }

            Spacer()

            if context.state.progress > 0 {
                Text("\(Int(context.state.progress * 100))%")
                    .font(.caption.monospacedDigit())
            }
        }
        .foregroundStyle(.white)
        .padding()
    }
}

@main
struct DynamicIslandWidgetBundle: WidgetBundle {
    var body: some Widget {
        DynamicIslandLiveActivity()
    }
}
