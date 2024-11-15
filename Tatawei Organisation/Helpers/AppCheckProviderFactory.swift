//
//  YourAppCheckProviderFactory.swift
//  Tatawei Student
//
//  Created by omar alzhrani on 26/03/1446 AH.
////
import Firebase
import FirebaseAppCheck

class TataweiAppCheckProviderFactory: NSObject, AppCheckProviderFactory {
  func createProvider(with app: FirebaseApp) -> AppCheckProvider? {
    if #available(iOS 14.0, *) {
      return AppAttestProvider(app: app)
    } else {
      return DeviceCheckProvider(app: app)
    }
  }
}
