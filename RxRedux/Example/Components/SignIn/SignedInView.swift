import UIKit
import RxSwift
import SnapKit

enum AccountAccessibility: String {
    case name
}

class SignOutButton: UIButton, LocalizableTitle { }
class AccountNameLabel: UILabel { }

class SignedInView: UIView {
    private lazy var nameLabel = AccountNameLabel(AccountAccessibility.name)
    private lazy var disposable = SingleAssignmentDisposable()
    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        disposable = SingleAssignmentDisposable()
        layout()
    }
    
    var viewModel: SignInViewModel? {
        didSet {
            nameLabel.text = viewModel?.name
        }
    }
    
    func updateAlpha() {
        guard let viewModel = viewModel else { return }
        
        nameLabel.alpha = viewModel.isNameShown ? 1 : 0
    }
    
    func layout() {
        [nameLabel].forEach(addSubview)
        
        nameLabel.snp.makeConstraints { (make) in
            make.leading.trailing.top.equalToSuperview().offset(20)
            make.bottom.equalToSuperview().inset(20)
        }
    }
}
