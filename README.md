<p align="center">
  <img src="Icon.png" width="65%"/>
</p>

`QRDispenser` is a lightweight library to generate a QR code as image (`UIImage`) in your app. It uses only native components, with no dependency from other libraries. This allows you to also fork the project and write your own implementation in case you need it, without worrying about external frameworks.

## Structure

The structure of the library is simple: there's only one class that you use and it's the `QRDispenser`. It has these methods:

- `generate(from: String, tint: UIColor)`
- `generate(url: URL)`
- `generate(email: String)`
- `generate(phoneNumber: String)`
- `generate(wiFiSSID: String, password: String, encryption: WiFiEncryption)`
- `generate(latitude: Double, longitude: Double, altitude: Double)`
- `generate(location: CLLocation)`

Every method returns a `UIImage` object or throws an error. The error enumeration is `QRDispenserError`. The code is well documented about every method, if you need more details check directly on Xcode.

There's also a nice thing that I plan to expand in the future that is an extension for `URL`. The extension has a computed property that returns a QR code containing the url, if the url is a network url (no local ones for now). It works like this: 

```swift
let url = "https://andrealufino.com"

let qrImage = url.qrRepresentation
```

I'd like to expand this kind of structure also to other types, like strings, contacts and events.

## iOS version

This library needs at least iOS 14.

## Installation

The library is available via Swift Package Manager. Just add the url of this repository.

## Author

[Andrea Mario Lufino](andrealufino.com), iOS developer since 2010.
