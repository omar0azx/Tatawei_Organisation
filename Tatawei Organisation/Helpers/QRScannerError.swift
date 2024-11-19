//
//  QRScannerError.swift
//  QRScanner
//
//  Created by Wesam Kadah on 13/11/2024.
//

import Foundation
import AVFoundation


public enum QRScannerError: Error {
    case unauthorized(AVAuthorizationStatus)
    case deviceFailure(DeviceError)
    case readFailure
    case unknown

    public enum DeviceError {
        case videoUnavailable
        case inputInvalid
        case metadataOutputFailure
        case videoDataOutputFailure
    }
}

extension Bundle {
    static var module: Bundle = {
        return Bundle(for: QRScannerView.self)
    }()
}
