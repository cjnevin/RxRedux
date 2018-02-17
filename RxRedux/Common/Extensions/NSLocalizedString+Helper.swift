import Foundation

func localize(_ string: String) -> String {
    let localized = NSLocalizedString(string, comment: string)
    if localized == string {
        fatalError("Localized string is missing")
    }
    return localized
}

extension String {
    func localized() -> String {
        return localize(self)
    }
    
    func localized(_ arguments: CVarArg...) -> String {
        return String(format: localized(), arguments: arguments)
    }
    
    func localizedWithInt(_ number: Int) -> String {
        return localized(number)
    }
}
