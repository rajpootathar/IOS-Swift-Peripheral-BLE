//
//  BLEManager.swift
//  CoreBluetoothBLE-iOS
//com.aala.CoreBluetoothBLE-iOS
//  Created by Tahir Mac aala on 29/05/2024.
//

import Foundation
import CoreBluetooth

class BLEPeripheralManager: NSObject, CBPeripheralManagerDelegate {
    var peripheralManager: CBPeripheralManager?
    var characteristic: CBMutableCharacteristic?
    
    override init() {
        super.init()
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
    }
    
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        if peripheral.state == .poweredOn {
            startAdvertising()
        } else {
            print("Bluetooth is not available.")
        }
    }
    
    func startAdvertising() {
        let serviceUUID = CBUUID(string: "C8D89CD2-E1A8-4434-B41C-3159E8CA0981")
        let characteristicUUID = CBUUID(string: "D5235629-A78C-4F7C-A514-8044E378A9D4")
        
        characteristic = CBMutableCharacteristic(type: characteristicUUID,
                                                 properties: [.read, .notify],
                                                 value: nil,
                                                 permissions: [.readable])
        
        let service = CBMutableService(type: serviceUUID, primary: true)
        service.characteristics = [characteristic!]
        
        peripheralManager?.add(service)
        peripheralManager?.startAdvertising([CBAdvertisementDataServiceUUIDsKey: [serviceUUID]])
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, didAdd service: CBService, error: Error?) {
        if let error = error {
            print("Error adding service: \(error.localizedDescription)")
            return
        }
        print("Service added: \(service.uuid)")
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, central: CBCentral, didSubscribeTo characteristic: CBCharacteristic) {
        print("Central subscribed to characteristic")
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, central: CBCentral, didUnsubscribeFrom characteristic: CBCharacteristic) {
        print("Central unsubscribed from characteristic")
    }
    

    // Method to send a message
        func sendMessage(_ message: String) {
            guard let characteristic = characteristic else { return }
            
            // Convert the message to Data
            if let data = message.data(using: .utf8) {
                let success = peripheralManager?.updateValue(data, for: characteristic, onSubscribedCentrals: nil) ?? false
                if success {
                    print("Message sent: \(message)")
                } else {
                    print("Failed to send message")
                }
            } else {
                print("Failed to convert message to data")
            }
        }
}
