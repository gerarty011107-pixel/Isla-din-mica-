import SwiftUI

struct ContentView: View {
    @StateObject private var island = IslandModel()

    var body: some View {
        ZStack(alignment: .top) {
            ScrollView {
                VStack(spacing: 20) {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Dynamic Island 11")
                            .font(.title2.bold())

                        Text("Versión 3: experiencia Dynamic Island optimizada para iPhone 11.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)

                        Divider()

                        Label("Modo simulación listo", systemImage: "checkmark.circle.fill")
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(.green)

                        Text("Esta versión prioriza la compatibilidad de instalación. iOS no permite sustituir las notificaciones de WhatsApp ni crear una isla permanente sobre otros juegos.")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .padding()
                    .background(Color(uiColor: .secondarySystemGroupedBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 16))

                    VStack(alignment: .leading, spacing: 14) {
                        Text("Estados de Dynamic Island")
                            .font(.headline)

                        liveButton("Notificación", icon: "message.fill") {
                            island.notificationApp = "WhatsApp"
                            island.notificationText = "Hola, te escribí hace un rato."
                            island.triggerNotificationSimulation()
                        }

                        liveButton("Música", icon: "music.note") {
                            island.mode = .music
                            if !island.musicPlayer.isSimulatingPlaying {
                                island.musicPlayer.togglePlayPause()
                            }
                        }

                        liveButton("Llamada", icon: "phone.fill") {
                            island.startCallSimulation()
                        }

                        liveButton("Estado compacto", icon: "capsule") {
                            island.mode = .reduced
                        }

                        liveButton("Cerrar isla", icon: "xmark.circle.fill") {
                            island.mode = .reduced
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
