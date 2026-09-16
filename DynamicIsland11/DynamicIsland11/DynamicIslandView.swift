import SwiftUI

private struct WaveformView: View {
    let isAnimating: Bool

    var body: some View {
        HStack(alignment: .center, spacing: 2) {
            ForEach(0..<4, id: \.self) { index in
                Capsule()
                    .fill(.white)
                    .frame(width: 2, height: isAnimating ? [6, 12, 8, 10][index] : 6)
                    .animation(
                        .easeInOut(duration: 0.55)
                            .repeatForever(autoreverses: true)
                            .delay(Double(index) * 0.08),
                        value: isAnimating
                    )
            }
        }
    }
}

struct DynamicIslandView: View {
    @ObservedObject var island: IslandModel
    @State private var isPressed = false

    var body: some View {
        ZStack {
            islandContent
                .transition(.opacity.combined(with: .scale(scale: 0.94, anchor: .top)))
        }
        .frame(width: islandWidth, height: islandHeight)
        .background(
            RoundedRectangle(cornerRadius: islandCornerRadius, style: .continuous)
                .fill(Color.black)
                .shadow(color: .black.opacity(0.32), radius: 14, x: 0, y: 7)
        )
        .clipShape(RoundedRectangle(cornerRadius: islandCornerRadius, style: .continuous))
        .contentShape(RoundedRectangle(cornerRadius: islandCornerRadius, style: .continuous))
        .scaleEffect(isPressed ? 0.965 : 1)
        .animation(.interactiveSpring(response: 0.28, dampingFraction: 0.78), value: isPressed)
        .onTapGesture {
            performIslandAnimation { island.handleTap() }
        }
        .onLongPressGesture(minimumDuration: 0.45, maximumDistance: 18, pressing: { pressing in
            withAnimation(.easeOut(duration: 0.12)) { isPressed = pressing }
        }, perform: {
            performIslandAnimation { island.handleLongPress() }
        })
        .animation(.spring(response: 0.48, dampingFraction: 0.82, blendDuration: 0.12), value: island.mode)
    }

    private func performIslandAnimation(_ action: @escaping () -> Void) {
        withAnimation(.spring(response: 0.48, dampingFraction: 0.82, blendDuration: 0.12)) {
            action()
        }
    }

    private var islandWidth: CGFloat {
        switch island.mode {
        case .reduced: return 126
        case .expanded: return 330
        case .music: return 342
        case .call: return 326
        case .notification: return 334
        }
    }

    private var islandHeight: CGFloat {
        switch island.mode {
        case .reduced: return 37
        case .expanded: return 150
        case .music: return 176
        case .call: return 76
        case .notification: return 82
        }
    }

    private var islandCornerRadius: CGFloat {
        switch island.mode {
        case .reduced: return 19
        default: return 38
        }
    }

    @ViewBuilder
    private var islandContent: some View {
        switch island.mode {
        case .reduced: reducedView
        case .expanded: expandedView
        case .music: musicView
        case .call: callView
        case .notification: notificationView
        }
    }

    private var reducedView: some View {
        HStack(spacing: 8) {
            Circle().fill(.white).frame(width: 7, height: 7).opacity(0.95)
            Text("Dynamic Island")
                .font(.system(size: 11, weight: .semibold, design: .rounded))
                .foregroundStyle(.white)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
            Spacer(minLength: 0)
            WaveformView(isAnimating: true).frame(width: 18, height: 14)
        }
        .padding(.horizontal, 12)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var expandedView: some View {
        VStack(alignment: .leading, spacing: 13) {
            HStack(spacing: 10) {
                Image(systemName: "circle.grid.cross.fill").foregroundStyle(.blue).font(.system(size: 17, weight: .semibold))
                Text("Simulación Activa").font(.system(size: 15, weight: .bold)).foregroundStyle(.white)
                Spacer()
                Button(action: { island.handleTap() }) {
                    Image(systemName: "xmark").font(.system(size: 12, weight: .bold)).foregroundStyle(.white.opacity(0.75))
                        .frame(width: 28, height: 28).background(.white.opacity(0.1), in: Circle())
                }.buttonStyle(.plain)
            }
            Text("Esta simulación se ejecuta dentro de la app en iOS.")
                .font(.system(size: 12)).foregroundStyle(.white.opacity(0.58))
                .fixedSize(horizontal: false, vertical: true)
            Capsule().fill(.white.opacity(0.08)).frame(height: 1)
            HStack {
                Image(systemName: "hand.tap.fill").font(.system(size: 12))
                Text("Toca para cerrar · mantén pulsado para música").font(.system(size: 11, weight: .medium))
            }.foregroundStyle(.white.opacity(0.55))
        }.padding(.horizontal, 20).padding(.vertical, 16)
    }

    private var musicView: some View {
        VStack(spacing: 11) {
            HStack(spacing: 11) {
                RoundedRectangle(cornerRadius: 9, style: .continuous)
                    .fill(LinearGradient(colors: [.purple, .blue], startPoint: .topLeading, endPoint: .bottomTrailing))
                    .frame(width: 46, height: 46)
                    .overlay(Image(systemName: "music.note").foregroundStyle(.white))
                VStack(alignment: .leading, spacing: 2) {
                    Text(island.songTitle).font(.system(size: 14, weight: .semibold)).foregroundStyle(.white).lineLimit(1)
                    Text(island.artistName).font(.system(size: 12)).foregroundStyle(.white.opacity(0.55)).lineLimit(1)
                }
                Spacer()
                HStack(alignment: .center, spacing: 2) {
                    ForEach(0..<4) { i in
                        RoundedRectangle(cornerRadius: 2).fill(.white)
                            .frame(width: 2.5, height: island.musicPlayer.isSimulatingPlaying ? CGFloat([12, 21, 8, 16][i]) : 6)
                            .animation(.easeInOut(duration: 0.45).repeatForever().delay(Double(i) * 0.08), value: island.musicPlayer.isSimulatingPlaying)
                    }
                }.frame(height: 24)
            }
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule().fill(.white.opacity(0.18)).frame(height: 3)
                    Capsule().fill(.white).frame(width: geo.size.width * CGFloat(island.musicPlayer.progress), height: 3)
                }
            }.frame(height: 3)
            HStack(spacing: 40) {
                Button(action: {}) { Image(systemName: "backward.fill") }
                Button(action: { island.musicPlayer.togglePlayPause() }) { Image(systemName: island.musicPlayer.isSimulatingPlaying ? "pause.fill" : "play.fill").font(.system(size: 18, weight: .bold)) }
                Button(action: {}) { Image(systemName: "forward.fill") }
            }.font(.system(size: 15, weight: .semibold)).foregroundStyle(.white).buttonStyle(.plain)
        }.padding(.horizontal, 18).padding(.vertical, 14)
    }

    private var callView: some View {
        HStack(spacing: 11) {
            Circle().fill(.green).frame(width: 38, height: 38).overlay(Image(systemName: "phone.fill").foregroundStyle(.white).font(.system(size: 15)))
            VStack(alignment: .leading, spacing: 2) {
                Text(island.callContact).font(.system(size: 14, weight: .bold)).foregroundStyle(.white)
                Text("Llamada en curso • \(island.callDuration)").font(.system(size: 11)).foregroundStyle(.green)
            }
            Spacer()
            Button(action: { island.endCall() }) {
                Circle().fill(.red).frame(width: 35, height: 35).overlay(Image(systemName: "phone.down.fill").foregroundStyle(.white).font(.system(size: 13)))
            }.buttonStyle(.plain)
        }.padding(.horizontal, 17)
    }

    private var notificationView: some View {
        HStack(spacing: 11) {
            RoundedRectangle(cornerRadius: 10, style: .continuous).fill(.green).frame(width: 38, height: 38)
                .overlay(Image(systemName: "message.fill").foregroundStyle(.white).font(.system(size: 17)))
            VStack(alignment: .leading, spacing: 2) {
                Text(island.notificationApp).font(.system(size: 11, weight: .bold)).foregroundStyle(.white.opacity(0.55))
                Text(island.notificationText).font(.system(size: 13, weight: .medium)).foregroundStyle(.white).lineLimit(2)
            }
            Spacer(minLength: 0)
            VStack(spacing: 6) {
                Button(action: { island.replyToNotification() }) {
                    Text("Responder").font(.system(size: 11, weight: .semibold)).foregroundStyle(.white)
                        .padding(.horizontal, 9).padding(.vertical, 6).background(.white.opacity(0.12), in: Capsule())
                }.buttonStyle(.plain)
                Button(action: { island.closeNotification() }) {
                    Image(systemName: "xmark").font(.system(size: 10, weight: .bold)).foregroundStyle(.white.opacity(0.65))
                }.buttonStyle(.plain)
            }
        }.padding(.horizontal, 17)
    }
}
