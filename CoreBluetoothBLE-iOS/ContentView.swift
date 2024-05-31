//
//  ContentView.swift
//  CoreBluetoothBLE-iOS
//
//  Created by Tahir Mac aala on 29/05/2024.
//

import SwiftUI

struct ContentView: View {
    var bluetoothManager = BLEPeripheralManager()
    @State private var currentDate = Date.now
    @State private var name: String = ""
    func nameString(name: String) -> String {
        if name.trimmingCharacters(in: .whitespaces).count != 0 {
            return name
        }
        return "Defalut Text"
    }
    let timer = Timer.publish(every: 60, on: .main, in: .common).autoconnect()
    var body: some View {
        NavigationView {
            VStack {
                TextField("Enter your message", text: $name)
                    .padding()
                    .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/)
                Button {
                    bluetoothManager.sendMessage(nameString(name: name))
                    name = ""
                } label: {
                    Text("Send")
                }


            }
            .navigationTitle("Peripheral Device")
            .padding()
            .onReceive(timer) { _ in
                bluetoothManager.sendMessage("Hello!!!@#")
        }
        }
    }
}

#Preview {
    ContentView()
}
