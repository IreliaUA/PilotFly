import UIKit

protocol ILevelsViewController: AnyObject {
    func setup(with: LevelsViewModel)
}

final class LevelsViewController: UIViewController {
    @IBOutlet private weak var levelstTableView: UITableView!
    
    private let presenter: ILevelsPresenter
    private var isCameraAccessGranted: Bool = false
    
    init(presenter: ILevelsPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter.viewDidLoad()
        levelstTableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter.viewDidLoad()
    }
    
    private func setupUI() {
        levelstTableView.delegate = self
        levelstTableView.dataSource = self
        levelstTableView.separatorStyle = .none
        levelstTableView.showsVerticalScrollIndicator = false
        levelstTableView.showsHorizontalScrollIndicator = false
        levelstTableView.rowHeight = 76
        levelstTableView.estimatedRowHeight = 76
        let nib = UINib(nibName: String(describing: LevelTableViewCell.self), bundle: nil)
        levelstTableView.register(nib, forCellReuseIdentifier: String(describing: LevelTableViewCell.self))
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        DispatchQueue.main.async {
            SoundsManagerSanctuary.shared.playSoundSanctuary(nameSound: .popSound)
        }
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - Extensions

extension LevelsViewController: ILevelsViewController {
    func setup(with viewModel: LevelsViewModel) {}
}

extension LevelsViewController: UITableViewDelegate {}

extension LevelsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.viewModel?.cellModels.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: LevelTableViewCell.identifier,
            for: indexPath
        ) as? LevelTableViewCell,
              let cellViewModel = presenter.viewModel?.cellModels[indexPath.row] else {
            return UITableViewCell()
        }
        cell.backgroundColor = .clear
        cell.setup(with: cellViewModel)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cellModel = presenter.viewModel?.cellModels[indexPath.row] {
            if !cellModel.isLocked {
                DispatchQueue.main.async {
                    SoundsManagerSanctuary.shared.playSoundSanctuary(nameSound: .popSound)
                }
                presenter.openGameLevel(with: cellModel.number)
            }
        }
    }
}
