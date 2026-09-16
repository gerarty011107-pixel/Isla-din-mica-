import SwiftUI

struct ContentView: View {
    @StateObject private var island = IslandModel()

    var body: some View {
        ZStack(alignment: .top) {
            ScrollView {
                VStack(spacing: 20) {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Dynamic Island 11").font(.title2.bold())
                        Text("Simulador visual para iPhone 11 con iOS 26.5 / iOS 16+.")
                            .font(.subheadline).foregroundStyle(.secondary)
                        Divider()
                        Text("Importante").font(.caption.bold()).foregroundStyle(.orange)
                        Text("Esta aplicación recrea la interfaz dentro de su propia ventana. iOS no permite que una app normal sustituya las notificaciones de WhatsApp ni permanezca superpuesta sobre otras apps o juegos.")
                            .font(.caption).foregroundStyle(.secondary)
                    }
                    .padding().background(Color(uiColor: .secondarySystemGroupedBackground)).clipShape(RoundedRectangle(cornerRadius: 16))

                    VStack(alignment: .leading, spacing: 14) {
                        Text("Panel de pruebas").font(.headline)
                        testButton("Estado compacto", icon: "capsule") { island.mode = .reduced }
                        testButton("Estado expandido", icon: "arrow.up.left.and.arrow.down.right") { island.mode = .expanded }
                        testButton("Simular música", icon: "music.note") {
                            island.mode = .music
                            if !island.musicPlayer.isSimulatingPlaying { island.musicPlayer.togglePlayPause() }
                        }
                        testButton("Simular llamada", icon: "phone.fill") { island.startCallSimulation() }
                        testButton("Simular notificación + Responder", icon: "message.fill") {
                            island.notificationApp = "WhatsApp (prueba)"
                            island.notificationText = "Hola, te escribí hace un rato."
                            island.triggerNotificationSimulation()
                        }
                    }
                    .padding().background(Color(uiColor: .secondarySystemGroupedBackground)).clipShape(RoundedRectangle(cornerRadius: 16))
                }.padding(.horizontal).padding(.top, 60)
            }

            DynamicIslandView(island: island)
                .padding(.top, 8)
        }
        .background(Color(uiColor: .systemGroupedBackground).ignoresSafeArea())
    }

    private func testButton(_ title: String, icon: String, action: @escaping () -> Void) -> some View {
        Button(action: {
            withAnimation(.spring(response: 0.48, dampingFraction: 0.82)) { action() }
        }) {
            HStack {
                Image(systemName: icon)
                Text(title)
                Spacer()
                Image(systemName: "chevron.right").font(.caption)
            }
            .padding().background(Color.primary.opacity(0.07), in: RoundedRectangle(cornerRadius: 12))
        }
        .buttonStyle(.plain)
    }
}
