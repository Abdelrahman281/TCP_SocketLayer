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
}
