# DynamicIsland11

Proyecto SwiftUI adaptado para iPhone 11 y orientado a iOS 26.5.

## Qué incluye
- Simulación visual tipo Dynamic Island dentro de la app.
- Estados compacto, expandido, música, llamada y notificación.
- Animaciones suaves y pulsación prolongada.
- Botón **Responder** para la notificación de prueba dentro de la app.
- Código sin `symbolEffect`, para mantener compatibilidad con el deployment target iOS 16.

## Importante sobre WhatsApp y otras apps
Una aplicación iOS normal no puede sustituir el banner nativo de WhatsApp, capturar sus notificaciones privadas ni dibujar una ventana permanente por encima de otras aplicaciones o juegos. Por eso el botón **Responder** de este proyecto es una simulación dentro de la propia app; no convierte las notificaciones reales de WhatsApp en una Dynamic Island del sistema.

## Compilación
El proyecto Xcode está en `DynamicIsland11/DynamicIsland11.xcodeproj`.
El bundle identifier es `com.dynamicisland11.app` y el deployment target es iOS 16.0.

Para obtener una IPA real se necesita compilar y firmar el proyecto con Xcode/macOS y una identidad de firma válida. Scarlet puede instalar/firmar una IPA existente, pero no compila este proyecto Swift desde el iPhone por sí solo.

## Dispositivo objetivo
- iPhone 11
- iOS 26.5
