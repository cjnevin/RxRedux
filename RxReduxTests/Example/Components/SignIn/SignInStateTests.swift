import Foundation
import XCTest
import Nimble
@testable import RxRedux

enum FakeError: Error {
    case fake
}

extension SignedInUser {
    static func fake(id: Int = 1,
                     firstName: String = "First",
                     lastName: String = "Last",
                     gender: Gender = .male) -> SignedInUser {
        return SignedInUser(id: id,
                            firstName: firstName,
                            lastName: lastName,
                            gender: gender)
    }
}

extension SignInState {
    static func fake(signedInUser: SignedInUser? = nil,
                     isSignedIn: Bool = false,
                     isSigningIn: Bool = false,
                     isSigningOut: Bool = false,
                     serverError: String? = nil,
                     email: String? = nil,
                     emailEditedOnce: Bool = false,
                     password: String? = nil,
                     passwordEditedOnce: Bool = false) -> SignInState {
        return SignInState(
            signedInUser: signedInUser,
            isSignedIn: isSignedIn,
            isSigningIn: isSigningIn,
            isSigningOut: isSigningOut,
            serverError: serverError,
            email: email,
            emailEditedOnce: emailEditedOnce,
            password: password,
            passwordEditedOnce: passwordEditedOnce)
    }
}

class SignInStateTests: XCTestCase {
    func test_whenSetFemaleIsReduced_thenExpectFemaleSignedInUser() {
        var signInState = SignInState.fake(signedInUser: SignedInUser.fake(gender: Gender.male))
        signInState.reduce(AccountGenderAction.setGender(.female))
        expect(signInState.signedInUser!.gender).to(equal(SignedInUser.Gender.female))
    }
    
    func test_whenSetMaleIsReduced_thenExpectMaleSignedInUser() {
        var signInState = SignInState.fake(signedInUser: SignedInUser.fake(gender: Gender.female))
        signInState.reduce(AccountGenderAction.setGender(.male))
        expect(signInState.signedInUser!.gender).to(equal(SignedInUser.Gender.male))
    }
    
    func test_whenRequestIsReduced_thenExpectIsSigningIn() {
        var signInState = SignInState.fake(serverError: "error")
        signInState.reduce(SignInFormAction.request)
        expect(signInState.isSigningIn).to(beTrue())
        expect(signInState.serverError).to(beNil())
    }

    func test_whenHandleSuccessIsReduced_thenExpectSignedInUser() {
        var signInState = SignInState()
        signInState.reduce(SignInFormAction.handleSuccess(SignedInUser.fake()))
        expect(signInState.signedInUser).toNot(beNil())
        expect(signInState.isSigningIn).to(beFalse())
        expect(signInState.isSignedIn).to(beTrue())
    }

    func test_whenHandleErrorIsReduced_thenExpectServerError() {
        var signInState = SignInState()
        signInState.reduce(SignInFormAction.handleError(FakeError.fake))
        expect(signInState.serverError).toNot(beNil())
    }

    func test_whenTouchEmailIsReduced_thenExpectEmailEditedOnceToBeTrue() {
        var signInState = SignInState()
        signInState.reduce(SignInFormAction.touchEmail)
        expect(signInState.emailEditedOnce).to(beTrue())
    }

    func test_whenTouchPasswordIsReduced_thenExpectPasswordEditedOnceToBeTrue() {
        var signInState = SignInState()
        signInState.reduce(SignInFormAction.touchPassword)
        expect(signInState.passwordEditedOnce).to(beTrue())
    }

    func test_whenUpdateEmailIsReduced_thenExpectNewEmail() {
        var signInState = SignInState()
        signInState.reduce(SignInFormAction.updateEmail("test@test.com"))
        expect(signInState.email).toNot(beNil())
    }

    func test_whenUpdatePasswordIsReduced_thenExpectNewPassword() {
        var signInState = SignInState()
        signInState.reduce(SignInFormAction.updatePassword("password123"))
        expect(signInState.password).toNot(beNil())
    }
}

/*
mutating func reduce(_ action: ActionType) {
    switch action {
    case AppLifecycleAction.ready:
        isSigningIn = false
        isSigningOut = false
    case let genderAction as AccountGenderAction:
        reduce(genderAction)
    case let signInAction as SignInFormAction:
        reduce(signInAction)
    case let signOutAction as SignOutFormAction:
        reduce(signOutAction)
    default:
        break
    }
}
*/
