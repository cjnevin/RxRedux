import Foundation
import Localize_Swift

extension String {
    func localizedWithParameter<T: CVarArg>(_ parameter: T) -> String {
        return localizedFormat(parameter)
    }
}
