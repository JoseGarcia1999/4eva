//
//  ContentView.swift
//  DallE
//
//  Created by MacOsX on 5/16/24.

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination: Ingresar()) {
                    HStack {
                        Image(systemName: "person.fill")
                        Text("Ingresar")
                            .font(.headline)
                            .foregroundColor(.blue)
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                }
                .padding()

                NavigationLink(destination: Registro()) {
                    HStack {
                        Image(systemName: "person.badge.plus.fill")
                        Text("Registrarse")
                            .font(.headline)
                            .foregroundColor(.blue)
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                }
                .padding()
            }
            .navigationTitle("Bienvenido a PREGUNTAME")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
