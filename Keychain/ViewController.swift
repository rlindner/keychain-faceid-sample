import UIKit

class ViewController: UIViewController {
    required init?(coder: NSCoder) {
        super.init(coder: coder)

        print(Date())

        if let passsword = Keychain.load() {
            print(passsword)
        }

        print(Date())
    }

    @IBAction func addKeychainItem(_ sender: Any) {
        Keychain.save(password: "mypass")
    }

    @IBAction func deleteKeychainItem(_ sender: Any) {
        Keychain.delete()
    }
}
