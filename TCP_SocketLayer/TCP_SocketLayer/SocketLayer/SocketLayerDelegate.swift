//
//  SocketLayerDelegate.swift
//  TCP_SocketLayer
//
//  Created by Abdelrahman Mahmoud on 12/27/19.
//  Copyright © 2019 Abdelrahman Mahmoud. All rights reserved.
//

import Foundation
import UIKit


//Protocol For Handling Receive Message Action.

protocol SocketLayerDelegate {
    func receive(message: String)
}
