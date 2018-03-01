import UIKit
import RxSwift
import SnapKit
import Action

enum AccountAccessibility: String {
    case accountContainer
    case name
    case genderSelection
}

class AccountNameLabel: UILabel { }

class SignedInView: UIView, SignedInComponent {
    private lazy var nameLabel = AccountNameLabel(AccountAccessibility.name)
    lazy var genderSegment = UISegmentedControl()
    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        layout()
    }
    
    var viewModel: SignInViewModel? {
        didSet {
            nameLabel.text = viewModel?.name
        }
    }
    
    func updateAlpha() {
        guard let viewModel = viewModel else { return }
        
        alpha = viewModel.isSignInShown ? 0 : 1
        nameLabel.alpha = viewModel.isNameShown ? 1 : 0
        genderSegment.alpha = viewModel.isGenderSelectionShown ? 1 : 0
    }
    
    func layout() {
        [genderSegment, nameLabel].forEach(addSubview)
        
        genderSegment.snp.makeConstraints { (make) in
            make.leading.trailing.top.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }
        
        nameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(genderSegment.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(20)
        }
    }
}
