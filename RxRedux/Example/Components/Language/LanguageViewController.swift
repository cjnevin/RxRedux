import UIKit
import RxSwift

class LanguageViewController: UITableViewController {
    private let dataSource = LanguageTableViewDataSource()
    
    var selectedLanguage = PublishSubject<LanguageCellViewModel>()
    var presenter: LanguagePresenter<LanguageViewController>?
    
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
        selectedLanguage.onNext(dataSource.languages[indexPath.row])
    }
}

extension LanguageViewController: LanguageView {
    func setLanguages(_ languages: [LanguageCellViewModel]) {
        dataSource.languages = languages
    }
}

class LanguageTableViewDataSource: NSObject, UITableViewDataSource {
    weak var tableView: UITableView? {
        didSet {
            tableView?.register(LanguageTableViewCell.self)
        }
    }
    var languages: [LanguageCellViewModel] = [] {
        didSet {
            tableView?.reloadData()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return languages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: LanguageTableViewCell = tableView[indexPath]
        cell.setLanguage(languages[indexPath.row])
        return cell
    }
}
