import Foundation

class Keychain: NSObject {
    private static let service = "example.org"

    class func save(password: String) {
        let access = SecAccessControlCreateWithFlags(nil,
                                                     kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly,
                                                     .userPresence,
                                                     nil)

        guard let valueData = password.data(using: .utf8) else { return }

        let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                    kSecAttrAccount as String: "user@example.org",
                                    kSecValueData as String: valueData,
                                    kSecAttrService as String: service,
                                    kSecAttrAccessControl as String: access as Any]

        let status = SecItemAdd(query as CFDictionary, nil)

        print("added keychain item: \(status)")
    }

    class func load() -> String? {
        let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                    kSecAttrService as String: service,
                                    kSecMatchLimit as String: kSecMatchLimitOne,
                                    kSecReturnAttributes as String: true,
                                    kSecReturnData as String: true]

        var result: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &result)

        guard status != errSecItemNotFound else {
            print("No password stored yet")
            return nil
        }

        guard status == errSecSuccess else {
            print("Error reading keychain: \(status)")
            return nil
        }

        guard let item = result as? [String: Any], let data = item[kSecValueData as String] as? Data else {
            print("Unexpected password data")
            return nil
        }

        print("loaded keychain item: \(status)")

        return String(data: data, encoding: .utf8)
    }

    class func delete() {
        let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                    kSecAttrService as String: service]

        let status = SecItemDelete(query as CFDictionary)

        guard status == errSecSuccess || status == errSecItemNotFound else {
            print("Error deleting items for service \(service): \(status)")
            return
        }

        print("deleted keychain item: \(status)")
    }
}
