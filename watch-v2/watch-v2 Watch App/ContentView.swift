//
//  ContentView.swift
//  watch-v2 Watch App
//
//  Created by Juliana Pereira de Magalhães on 18/09/24.
//

import SwiftUI
import WatchConnectivity

// Classe responsável pelo gerenciamento da sessão WCSession no Watch
class WatchSessionManager: NSObject, WCSessionDelegate, ObservableObject {
    static let shared = WatchSessionManager()
    
    private override init() {
        super.init()
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
    }
    
    // Método obrigatório: Chamado quando a sessão é ativada no Watch
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if let error = error {
            print("Erro na ativação da sessão no Watch: \(error.localizedDescription)")
        } else {
            print("Sessão ativada no Watch com sucesso. Estado: \(activationState.rawValue)")
        }
    }

    // Método obrigatório: Chamado quando o dispositivo remoto está ou não alcançável
    func sessionReachabilityDidChange(_ session: WCSession) {
        print("Mudança de alcance da sessão no Watch. Alcançável: \(session.isReachable)")
    }

    // Função para enviar o tema selecionado do Watch para o iPhone
    func sendThemeToiOS(themeNumber: Int) {
        let session = WCSession.default
        print("Estado da sessão: \(session.activationState.rawValue)")  // Verifica o estado da sessão
        if session.activationState == .activated {
            do {
                try session.updateApplicationContext(["selectedTheme": themeNumber])
                print("Contexto de aplicativo enviado com sucesso.")
            } catch {
                print("Erro ao enviar contexto de aplicativo: \(error.localizedDescription)")
            }
        } else {
            print("Sessão não ativada ou dispositivo não alcançável.")
        }
    }
}

struct ContentView: View {
    var body: some View {
        ScrollView {
            VStack {
                ForEach([1, 2, 3], id: \.self) { themeNumber in
                    Button(action: {
                        WatchSessionManager.shared.sendThemeToiOS(themeNumber: themeNumber)
                    }) {
                        VStack {
                            Image(systemName: "\(themeNumber).circle")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 100)
                            Text("Escolher Tema \(themeNumber)")
                                .foregroundColor(.blue)
                        }
                    }
                    .padding()
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
