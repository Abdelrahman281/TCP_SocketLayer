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
    
    
}
