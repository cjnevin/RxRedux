import Foundation

enum Gender: String, Codable {
    case male
    case female
    
    static var all: [Gender] = [.male, .female]
}

struct SignedInUser: Equatable, Codable {
    static func ==(lhs: SignedInUser, rhs: SignedInUser) -> Bool {
        return lhs.id == rhs.id &&
            lhs.firstName == rhs.firstName &&
            lhs.lastName == rhs.lastName &&
            lhs.gender == rhs.gender
    }
    
    let id: Int
    let firstName: String
    let lastName: String
    var gender: Gender?    
}
