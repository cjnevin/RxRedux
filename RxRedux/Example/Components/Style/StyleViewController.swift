import UIKit
import RxSwift

class StyleViewController: UITableViewController {
    private let dataSource = StyleTableViewDataSource()
    
    var selectedStyle = PublishSubject<StyleCellViewModel>()
    var presenter: StylePresenter<StyleViewController>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource.tableView = tableView
        tableView.dataSource = dataSource
        presenter?.attachView(self)
    }
    
    deinit {
        presenter?.detachView()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedStyle.onNext(dataSource.styles[indexPath.row])
    }
}

extension StyleViewController: StyleView {
    func setStyles(_ styles: [StyleCellViewModel]) {
        dataSource.styles = styles
    }
}

class StyleTableViewDataSource: NSObject, UITableViewDataSource {
    weak var tableView: UITableView? {
        didSet {
            tableView?.register(StyleTableViewCell.self)
        }
    }
    var styles: [StyleCellViewModel] = [] {
        didSet {
            tableView?.reloadData()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return styles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: StyleTableViewCell = tableView.dequeueReusableCell(at: indexPath)
        cell.setStyle(styles[indexPath.row])
        return cell
    }
}

