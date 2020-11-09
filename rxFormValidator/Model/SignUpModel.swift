import Foundation

class SignUpModel {
    
    var username: String = ""
    var email: String = ""
    var phone: String = ""
    var password: String = ""
    
    convenience init(username: String, email: String, password: String) {
        self.init()
        self.username = username
        self.email = email
        self.password = password
    }
}


