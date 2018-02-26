import UIKit
import RxSwift
import SnapKit
import Action

enum AccountAccessibility: String {
    case name
}

class AccountNameLabel: UILabel { }

class SignedInView: UIView {
    
    private lazy var nameLabel = AccountNameLabel(AccountAccessibility.name)
    private lazy var genderSegmentedControl = UISegmentedControl()
    
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
        
        nameLabel.alpha = viewModel.isNameShown ? 1 : 0
        genderSegmentedControl.alpha = viewModel.isGenderSelectionShown ? 1 : 0
    }
    
    func layout() {
        [genderSegmentedControl, nameLabel].forEach(addSubview)
        
        genderSegmentedControl.snp.makeConstraints { (make) in
            make.leading.trailing.top.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }
        
        nameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(genderSegmentedControl.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(20)
        }
    }
}

extension SignedInView: SignedInViewType {
    func selectedGender() -> Observable<Int> {
        return genderSegmentedControl.rx.controlEvent(.valueChanged)
            .map { [unowned self] in
                self.genderSegmentedControl.selectedSegmentIndex
            }
    }
    
    func setGenders(_ genders: [String]) {
        genderSegmentedControl.removeAllSegments()
        genders.enumerated().forEach { index, gender in
            genderSegmentedControl.insertSegment(withTitle: gender, at: index, animated: false)
        }
    }
    
    func setSelectedGender(_ selected: Int) {
        genderSegmentedControl.selectedSegmentIndex = selected
    }
}
