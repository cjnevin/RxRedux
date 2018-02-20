import UIKit

enum StyleCellAccessibility: String {
    case styleCell
}

enum StyleCellText {
    static func style(name: String) -> String {
        return "style.\(name.lowercased())".localized()
    }
}

class StyleTableViewCell: UITableViewCell, Identifiable {
    func setStyle(_ viewModel: StyleCellViewModel) {
        self.accessibilityIdentifier = StyleCellAccessibility.styleCell.rawValue
        self.accessibilityLabel = viewModel.style.name
        self.isAccessibilityElement = true
        self.textLabel?.text = StyleCellText.style(name: viewModel.style.name)
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


