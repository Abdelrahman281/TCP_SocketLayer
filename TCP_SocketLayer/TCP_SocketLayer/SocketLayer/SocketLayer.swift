//
//  SocketLayer.swift
//  TCP_SocketLayer
//
//  Created by Abdelrahman Mahmoud on 12/26/19.
//  Copyright © 2019 Abdelrahman Mahmoud. All rights reserved.
//

import Foundation
import UIKit


//Main Class for Socket Operations.

class SocketLayer: NSObject {
    
    
    //Shared Instance For Universal Use.
    
    static let shared: SocketLayer = SocketLayer(maxLength: 4096)
    
    
    //Input & Output Streams.
    
    private var inputStream: InputStream!
    private var outputStream: OutputStream!
    
    
    //Max Length In Read.
    
    let maxReadLength: Int
    
    
    //Delegate
    
    var delegate: SocketLayerDelegate?
    
    
    //Private Initializer.
    
    private init(maxLength: Int) {
        maxReadLength = maxLength
    }
    
    
    //Setup Connection function.
    
    func setupConnection(host: String, port: UInt32) {
        var readStream: Unmanaged<CFReadStream>?
        var writeStream: Unmanaged<CFWriteStream>?
        
        CFStreamCreatePairWithSocketToHost(kCFAllocatorDefault, host as CFString, port, &readStream, &writeStream)
        
        //Make Streams Managed
        inputStream = readStream?.takeRetainedValue()
        outputStream = writeStream?.takeRetainedValue()
        
        inputStream.delegate = self
        
        inputStream.schedule(in: .current, forMode: .common)
        outputStream.schedule(in: .current, forMode: .common)
        
        inputStream.open()
        outputStream.open()
    }
    
    
    //Send Function.
    
    func send(message: String) {
        if let data = message.data(using: .utf8) {
            data.withUnsafeBytes{ body in
                guard let pointer = body.baseAddress?.assumingMemoryBound(to: UInt8.self) else {
                    print("Error in creating the pointer")
                    return
                }
                outputStream.write(pointer, maxLength: data.count)
            }
        }
    }
}
    
    
    //Stream Delegate & Receive Handling.
    
    extension SocketLayer: StreamDelegate {
        
        
        //Stream Handling Function.
        
        func stream(_ aStream: Stream, handle eventCode: Stream.Event) {
            if eventCode == .hasBytesAvailable {
                
                //New Message Received.
                readAvailableBytes(stream: aStream as! InputStream)
            }
        }
        
        
        //Reading Bytes Function.
        
        private func readAvailableBytes(stream: InputStream) {
            let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: maxReadLength)
            
            while inputStream.hasBytesAvailable {
                let numberOfBytesRead = inputStream.read(buffer, maxLength: maxReadLength)
                
                if numberOfBytesRead < 0, let _ = inputStream.streamError {
                    print("Error in reading the stream")
                    break
                }
                
                constructMessage(buffer: buffer, length: numberOfBytesRead)
            }
        }
        
        
        //Constructing Message Function.
        
        private func constructMessage(buffer: UnsafeMutablePointer<UInt8>, length: Int) {
            guard let message = String(bytesNoCopy: buffer, length: length, encoding: .utf8, freeWhenDone: true) else {
                print("Error in getting the message")
                return
            }
            
            delegate?.receive(message: message)
        }
}
