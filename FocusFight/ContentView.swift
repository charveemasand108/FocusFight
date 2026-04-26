import SwiftUI

struct ContentView: View {
    @StateObject private var vm = GameViewModel()

    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()

            switch vm.screen {
            case .lobby:
                LobbyView()
                    .transition(.asymmetric(
                        insertion: .move(edge: .leading),
                        removal: .move(edge: .leading)
                    ))
            case .battle:
                BattleView()
                    .transition(.asymmetric(
                        insertion: .move(edge: .trailing),
                        removal: .move(edge: .trailing)
                    ))
            case .results:
                ResultsView()
                    .transition(.asymmetric(
                        insertion: .opacity,
                        removal: .opacity
                    ))
            }

            // Global toast overlay
            if vm.showToast {
                ToastView(message: vm.toastMessage)
                    .transition(.move(edge: .top).combined(with: .opacity))
                    .zIndex(999)
            }
        }
        .animation(.spring(response: 0.45, dampingFraction: 0.82), value: vm.screen)
        .animation(.spring(response: 0.4, dampingFraction: 0.7), value: vm.showToast)
        .environmentObject(vm)
    }
}

