# DynamicIsland11

Proyecto SwiftUI para **iPhone 11** que recrea visualmente una experiencia tipo Dynamic Island dentro de la propia aplicación.

## Qué está corregido

- Animaciones más suaves y consistentes.
- Eliminado `symbolEffect`, que podía provocar incompatibilidades con el deployment target iOS 16.
- Vista compacta y estados expandidos conservados para iPhone 11.
- Botón **Responder** añadido al estado de notificación como simulación de respuesta rápida.
- Limpieza del ciclo de vida del temporizador de llamadas.
- Proyecto preparado para iOS 16+ y, por tanto, para iOS 26.5.

## Importante sobre WhatsApp y otras apps

Una aplicación normal de iOS **no puede reemplazar las notificaciones de WhatsApp**, modificar el banner del sistema, dibujar una isla permanente encima de otras apps/juegos ni modificar el notch físico del iPhone 11 mediante APIs públicas.

Por eso el botón **Responder** de este proyecto es una simulación dentro de la app. Para responder desde la notificación real de WhatsApp, WhatsApp/iOS debe proporcionar la acción de respuesta.

## Requisitos

- Xcode 15+ / 16+
- iPhone 11
- iOS 16 o posterior
- Apple Developer Team/certificado válido para compilar y firmar en un dispositivo.

## Compilación

Abre `DynamicIsland11.xcodeproj`, selecciona el target `DynamicIsland11`, elige tu iPhone 11 y ejecuta Build/Run.

La firma del `.ipa` debe hacerse con una identidad válida de Apple. Scarlet puede instalar/firmar un IPA ya compilado, pero no sustituye la compilación de Xcode.
