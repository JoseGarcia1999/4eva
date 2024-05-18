//
//  OpenAI.swift
//  DallE
//
//  Created by MacOsX on 5/17/24.
//
import SwiftUI

struct OpenAI: View {
    @State private var inputText: String = ""
    @State private var messages: [Message] = []
    @State private var isLoading: Bool = false
    let apiKey = "No me dejo subirlo a GitHub con la APIKEY, el proyecto con la API esta en onedrive" 

    var body: some View {
        VStack {
            List(messages) { message in
                HStack {
                    if message.isUser {
                        Spacer()
                        Text(message.text)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                            .frame(maxWidth: UIScreen.main.bounds.width * 0.7, alignment: .trailing)
                    } else {
                        Text(message.text)
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(8)
                            .frame(maxWidth: UIScreen.main.bounds.width * 0.7, alignment: .leading)
                        Spacer()
                    }
                }
            }
            .listStyle(PlainListStyle())

            if isLoading {
                ProgressView()
                    .padding()
            }

            HStack {
                TextField("Escribe tu mensaje...", text: $inputText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                Button(action: sendMessage) {
                    Text("Enviar")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding()
            }
        }
        .padding()
    }

    func sendMessage() {
        guard !inputText.isEmpty else { return }

        let userMessage = Message(text: inputText, isUser: true)
        messages.append(userMessage)

        isLoading = true
        let input = inputText
        inputText = ""

        fetchResponse(for: input) { responseText in
            let responseMessage = Message(text: responseText, isUser: false)
            DispatchQueue.main.async {
                self.messages.append(responseMessage)
                self.isLoading = false
            }
        }
    }

    func fetchResponse(for input: String, completion: @escaping (String) -> Void) {
        guard let url = URL(string: "https://api.openai.com/v1/completions") else { return }
        guard !apiKey.isEmpty else {
            completion("No se proporcionó una clave de API válida.")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")

        let parameters: [String: Any] = [
            "model": "text-davinci-003",
            "prompt": input,
            "max_tokens": 100,
            "n": 1,
            "stop": "",
            "temperature": 0.7
        ]

        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters) else {
            completion("Error al serializar los parámetros.")
            return
        }
        request.httpBody = httpBody

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                DispatchQueue.main.async {
                    completion("Error en la solicitud: \(error?.localizedDescription ?? "Unknown error")")
                }
                return
            }

            if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
               let choices = json["choices"] as? [[String: Any]],
               let text = choices.first?["text"] as? String {
                completion(text.trimmingCharacters(in: .whitespacesAndNewlines))
            } else {
                DispatchQueue.main.async {
                    completion("Aqui se mostrara la respuesta proximamente.")
                }
            }
        }.resume()
    }
}

struct Message: Identifiable {
    let id = UUID()
    let text: String
    let isUser: Bool
}

struct OpenAI_Previews: PreviewProvider {
    static var previews: some View {
        OpenAI()
    }
}
