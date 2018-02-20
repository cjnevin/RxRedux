import UIKit

class LoadingView: UIView {
    private lazy var indicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
    
    override func willMove(toSuperview newSuperview: UIView?) {
        addSubview(indicator) { make in
            make.center.equalToSuperview()
        }
        indicator.startAnimating()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.width / 2
    }
}
