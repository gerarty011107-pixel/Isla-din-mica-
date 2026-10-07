import SwiftUI

struct ContentView: View {
    @StateObject private var island = IslandModel()
    @StateObject private var liveActivity = LiveActivityManager()

    var body: some View {
        ZStack(alignment: .top) {
            ScrollView {
                VStack(spacing: 20) {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Dynamic Island 11")
                            .font(.title2.bold())

                        Text("Versión 3: simulación + Live Activity con WidgetKit.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)

                        Divider()

                        Label(
                            liveActivity.isRunning ? "Live Activity activa" : "Modo simulación listo",
                            systemImage: liveActivity.isRunning ? "capsule.fill" : "checkmark.circle.fill"
                        )
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(liveActivity.isRunning ? .green : .green)

                        Text("La app usa las APIs públicas de ActivityKit y WidgetKit. iOS sigue controlando la presentación del sistema; no sustituye las notificaciones de WhatsApp ni crea una isla permanente sobre otras apps.")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .padding()
                    .background(Color(uiColor: .secondarySystemGroupedBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 16))

                    VStack(alignment: .leading, spacing: 14) {
                        Text("Estados de Dynamic Island")
                            .font(.headline)

                        liveButton("WhatsApp (prueba)", icon: "message.fill") {
                            island.notificationApp = "WhatsApp"
                            island.notificationText = "Hola, te escribí hace un rato."
                            island.triggerNotificationSimulation()
                            liveActivity.start(
                                kind: "whatsapp",
                                title: "WhatsApp",
                                subtitle: "Hola, te escribí hace un rato.",
                                symbol: "message.fill"
                            )
                        }

                        liveButton("Música", icon: "music.note") {
                            island.mode = .music
                            if !island.musicPlayer.isSimulatingPlaying {
                                island.musicPlayer.togglePlayPause()
                            }
                            liveActivity.start(
                                kind: "music",
                                title: island.songTitle,
                                subtitle: island.artistName,
                                symbol: "music.note"
                            )
                        }

                        liveButton("Llamada", icon: "phone.fill") {
                            island.startCallSimulation()
                            liveActivity.start(
                                kind: "call",
                                title: island.callContact,
                                subtitle: island.callDuration,
                                symbol: "phone.fill"
                            )
                        }

                        liveButton("Estado compacto", icon: "capsule") {
                            island.mode = .reduced
                            liveActivity.start(
                                kind: "status",
                                title: "Dynamic Island",
                                subtitle: "Estado activo",
                                symbol: "circle.fill"
                            )
                        }

                        liveButton("Cerrar isla", icon: "xmark.circle.fill") {
                            island.mode = .reduced
                            liveActivity.end()
                        }
                    }
                    .padding()
                    .background(Color(uiColor: .secondarySystemGroupedBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                }
                .padding(.horizontal)
                .padding(.top, 60)
            }

            DynamicIslandView(island: island)
                .padding(.top, 8)
        }
        .background(Color(uiColor: .systemGroupedBackground).ignoresSafeArea())
    }

    private func liveButton(_ title: String, icon: String, action: @escaping () -> Void) -> some View {
        Button {
            withAnimation(.spring(response: 0.48, dampingFraction: 0.82)) {
                action()
            }
        } label: {
            HStack {
                Image(systemName: icon)
                Text(title)
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.caption)
            }
            .padding()
            .background(Color.primary.opacity(0.07), in: RoundedRectangle(cornerRadius: 12))
        }
        .buttonStyle(.plain)
    }
}
