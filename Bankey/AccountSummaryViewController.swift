//
//  AccountSummaryViewController.swift
//  Bankey
//
//  Created by Abdusamad Mamasoliyev on 29/02/24.
//

import UIKit

class AccountSummaryViewController: UIViewController {
    
    // Request Models
    var profile: Profile?
    var accounts: [Account] = []
    // View models
    var hearderViewModel = AccountSummaryHeaderView.ViewModel(welcomeMessage: "Welcome", name: "", date: Date())
    var accountCellViewModels: [AcountSummaryCell.ViewModel] = []
    // Components
    let headerView = AccountSummaryHeaderView(frame: .zero)
    let tableView = UITableView()
    let refreshController = UIRefreshControl()
    
    // Networking
    var profileManager: ProfileManageable = ProfileManager()
    var isLoaded = false
    
    lazy var errorAlert: UIAlertController = {
        let alert = UIAlertController(title: "", message: "", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .cancel)
        alert.addAction(ok)
        return alert
    }()
    
    lazy var logOutBarButtonItem: UIBarButtonItem = {
        
        let barButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logoutTapped))
        barButtonItem.tintColor = .label
        return barButtonItem
    }()
    
    override func viewDidLoad() {
       super.viewDidLoad()
        setup()
    }
}

extension AccountSummaryViewController {
    
   private func setup() {
       setupNavigationBar()
       setupTableView()
       setupTableHeaderView()
       setupRefreshControl()
       setupSkeletons()
       fetchData()
    }
    
    func setupTableView() {
       
        tableView.backgroundColor = appColor
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(AcountSummaryCell.self, forCellReuseIdentifier: AcountSummaryCell.reuseID)
        tableView.register(SkeletonCell.self, forCellReuseIdentifier: SkeletonCell.reuseID)
        tableView.rowHeight = CGFloat(AcountSummaryCell.rowHeight)
        tableView.tableFooterView = UIView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
        
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setupTableHeaderView() {
        
        var size = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        size.width = UIScreen.main.bounds.width
        headerView.frame.size = size
        
        tableView.tableHeaderView = headerView
    }
    func setupNavigationBar() {
        navigationItem.rightBarButtonItem = logOutBarButtonItem
    }
    private func setupRefreshControl() {
        
        refreshController.tintColor = appColor
        refreshController.addTarget(self, action: #selector(refreshContent), for: .valueChanged)
        tableView.refreshControl = refreshController
    }
    
    private func setupSkeletons() {
        let row = Account.makeSkeleton()
        accounts = Array(repeating: row, count: 10)
        
        configureTableCells(with: accounts)
    }
}

extension AccountSummaryViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard !accounts.isEmpty else { return UITableViewCell() }
        let account = accountCellViewModels[indexPath.row]
        
        if isLoaded {
            let cell = tableView.dequeueReusableCell(withIdentifier: AcountSummaryCell.reuseID, for: indexPath) as! AcountSummaryCell
            cell.configure(with: account)
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: SkeletonCell.reuseID, for: indexPath) as! SkeletonCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accounts.count
    }
}

extension AccountSummaryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
// MARK: Actions
extension AccountSummaryViewController {
    @objc func logoutTapped(sender: UIButton) {
        NotificationCenter.default.post(name: .logout, object: nil)
    }
    
    @objc func refreshContent() {
        reset()
        setupSkeletons()
        tableView.reloadData()
        fetchData()
    }
    
    @objc func reset() {
       
        profile = nil
        accounts = []
        isLoaded = false
        
    }
    
}
// MARK: - Networking
extension AccountSummaryViewController {
    private func fetchData() {
        let group = DispatchGroup()
        
        // Testing - random number selection
        let userId = String(Int.random(in: 1..<4))
        
        group.enter()
            profileManager.fetchProfile(forUserId: userId) { result in
            switch result {
            case .success(let profile):
                self.profile = profile
            case .failure(let error):
                self.displayError(error)
            }
            group.leave()
        }

        group.enter()
        fetchAccounts(forUserId: userId) { result in
            
            switch result {
            case .success(let accounts):
                self.accounts = accounts
            case .failure(let error):
                self.displayError(error)
            }
            group.leave()
        }
        
        group.notify(queue: .main) {
            self.tableView.refreshControl?.endRefreshing()
            guard let profile = self.profile else { return }
            self.isLoaded = true
            self.configureTableHeaderView(with: profile)
            self.configureTableCells(with: self.accounts)
            self.tableView.reloadData()
                
        }
    }
    
    private func configureTableHeaderView(with profile: Profile) {
        let vm = AccountSummaryHeaderView.ViewModel(welcomeMessage: "Good morning,",
                                                    name: profile.firstName,
                                                    date: Date())
        headerView.configure(viewModel: vm)
    }
    
    private func configureTableCells(with accounts: [Account]) {
        accountCellViewModels = accounts.map {
            AcountSummaryCell.ViewModel(accountType: $0.type, accountName: $0.name, balance: $0.amount)
        }
    }

    private func displayError(_ error: NetworkError) {
        let titleAndMessage = titleAndMessage(for: error)
        self.showErrorAlert(title: titleAndMessage.0, message: titleAndMessage.1)
    }
    
    private func titleAndMessage(for error: NetworkError) -> (String, String) {
        let title: String
        let message: String
        switch error {
        case .serverError:
            title = "Server error"
            message = "Ensure you are connected to the internet. Please try again"
        case .decodingError:
            title = "Decoding error"
            message = "We could not process your request. Please try again"
        }
       return (title, message)
    }
    
    private func showErrorAlert(title: String, message: String) {

        errorAlert.title = title
        errorAlert.message = message
        
        self.present(errorAlert, animated: true)
    }
}
