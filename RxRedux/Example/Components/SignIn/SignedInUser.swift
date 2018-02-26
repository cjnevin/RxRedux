import Foundation

struct SignedInUser: Equatable, Codable {
    enum Gender: String, Codable {
        case male
        case female
    }
    
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
