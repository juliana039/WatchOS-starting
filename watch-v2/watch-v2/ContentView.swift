//
//  ContentView.swift
//  watch-v2
//
//  Created by Juliana Pereira de Magalhães on 18/09/24.
//
import SwiftUI
import WatchConnectivity

// Classe responsável pelo gerenciamento da sessão WCSession no iOS
class WatchSessionManager: NSObject, ObservableObject, WCSessionDelegate {
    static let shared = WatchSessionManager()
    
    @Published var selectedTheme: Int = 0
    
    private override init() {
        super.init()
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
    }
    
    // Método obrigatório: Chamado quando a sessão é ativada
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if let error = error {
            print("Erro na ativação da sessão no iOS: \(error.localizedDescription)")
        } else {
            print("Sessão ativada no iOS com sucesso. Estado: \(activationState.rawValue)")
        }
    }

    // Método obrigatório: Chamado quando o dispositivo remoto está ou não alcançável
    func sessionReachabilityDidChange(_ session: WCSession) {
        print("Mudança de alcance da sessão. Alcançável: \(session.isReachable)")
    }

    // Método obrigatório: Chamado quando o Watch é desconectado
    func sessionDidDeactivate(_ session: WCSession) {
        print("Sessão desativada.")
    }
    
    // Método obrigatório: Chamado quando a sessão se torna inativa
    func sessionDidBecomeInactive(_ session: WCSession) {
        print("Sessão inativa.")
    }
    
    // Método obrigatório: Chamado quando uma nova sessão é ativada após uma inatividade
    func sessionDidActivate(_ session: WCSession) {
        print("Sessão ativada novamente.")
    }
    
    // Método obrigatório: Chamado quando um contexto de aplicativo é recebido do Watch
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        if let themeNumber = applicationContext["selectedTheme"] as? Int {
            print("Contexto de aplicativo recebido no iOS: \(themeNumber)")
            DispatchQueue.main.async {
                self.selectedTheme = themeNumber
            }
        }
    }
}

struct ContentView: View {
    @ObservedObject var watchSession = WatchSessionManager.shared
    
    var body: some View {
        VStack {
            Text("Tema Selecionado: \(watchSession.selectedTheme)")
                .font(.largeTitle)
                .padding()
        }
    }
}

#Preview {
    ContentView()
}
