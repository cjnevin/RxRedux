import UIKit

enum LanguageCellAccessibility: String {
    case languageCell
}

enum LanguageCellText {
    static func language(isoCode: String) -> String {
        return "language.\(isoCode)".localized()
    }
}

class LanguageTableViewCell: UITableViewCell, Identifiable {
    func setLanguage(_ viewModel: LanguageCellViewModel) {
        self.accessibilityIdentifier = LanguageCellAccessibility.languageCell.rawValue
        self.accessibilityLabel = viewModel.language
        self.isAccessibilityElement = true
        self.textLabel?.text = LanguageCellText.language(isoCode: viewModel.language)
        self.accessoryType = viewModel.isSelected ? .checkmark : .none
        self.selectionStyle = viewModel.isSelected ? .none : .default
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.textLabel?.text = nil
        self.accessoryType = .none
        self.accessibilityLabel = nil
        self.selectionStyle = .default
    }
}

