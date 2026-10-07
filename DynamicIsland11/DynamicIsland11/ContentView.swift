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

                        Text("Ahora usa Live Activities de Apple para llevar los estados al sistema cuando iOS lo permita.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)

                        Divider()

                        Label(
                            liveActivity.isRunning
                                ? "Live Activity activa"
                                : "Lista para activar",
                            systemImage: liveActivity.isRunning ? "checkmark.circle.fill" : "circle"
                        )
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(liveActivity.isRunning ? .green : .secondary)

                        Text("En un iPhone sin Dynamic Island física, iOS decide la presentación disponible; la app no puede sustituir la interfaz de WhatsApp ni crear una isla permanente sobre otros juegos.")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .padding()
                    .background(Color(uiColor: .secondarySystemGroupedBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 16))

                    VStack(alignment: .leading, spacing: 14) {
                        Text("Estados del sistema")
                            .font(.headline)

                        liveButton("Notificación", icon: "message.fill") {
                            island.notificationApp = "WhatsApp"
                            island.notificationText = "Hola, te escribí hace un rato."
                            island.triggerNotificationSimulation()
                            liveActivity.start(
                                kind: "notification",
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
                                title: "Blinding Lights",
                                subtitle: "The Weeknd",
                                symbol: "music.note"
                            )
                        }

                        liveButton("Llamada", icon: "phone.fill") {
                            island.startCallSimulation()
                            liveActivity.start(
                                kind: "call",
                                title: "Ana",
                                subtitle: "Llamada en curso",
                                symbol: "phone.fill"
                            )
                        }

                        liveButton("Estado compacto", icon: "capsule") {
                            island.mode = .reduced
                            liveActivity.start(
                                kind: "status",
                                title: "Activo",
                                subtitle: "Dynamic Island 11",
                                symbol: "capsule"
                            )
                        }

                        liveButton("Cerrar Live Activity", icon: "xmark.circle.fill") {
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
