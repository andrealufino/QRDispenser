[logo](qrcode_small.png)

# QRDispenser

`QRDispenser` is a lightweight library to generate a QR code as image (`UIImage`) in your app. It uses only native components, with no dependency from other libraries. This allows you to also fork the project and write your own implementation in case you need it, without worrying about external frameworks.

## Structure

The structure of the library is simple: there's only one class that you use and it's the `QRDispenser`. It has these methods:

- `generate(from: String)`
- `generate(url: URL)`
- `generate(email: String)`
- `generate(phoneNumber: String)`
- `generate(wiFiSSID: String, password: String, encryption: WiFiEncryption)`
- `generate(latitude: Double, longitude: Double, altitude: Double)`
- `generate(location: CLLocation)`

Every method returns a `UIImage` object or throws an error. The error enumeration is `QRDispenserError`. The code is well documented about every method, if you need more details check directly on Xcode.

## Author

[Andrea Mario Lufino](andrealufino.com), iOS developer since 2010.
