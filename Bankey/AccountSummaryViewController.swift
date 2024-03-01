//
//  AccountSummaryViewController.swift
//  Bankey
//
//  Created by Abdusamad Mamasoliyev on 29/02/24.
//

import UIKit

class AccountSummaryViewController: UIViewController {
    
    struct Profile {
        let firstName: String
        let lasrName: String
    }
    
    var profile: Profile?
    var accounts: [AcountSummaryCell.ViewModel] = []
    
    let headerView = AccountSummaryHeaderView(frame: .zero)
    let tableView = UITableView()
    
    override func viewDidLoad() {
       super.viewDidLoad()
        setup()
    }
}

extension AccountSummaryViewController {
    
   private func setup() {
       setupTableView()
       setupTableHeaderView()
       fetchData()
    }
    
    func setupTableView() {
       
        tableView.backgroundColor = appColor
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(AcountSummaryCell.self, forCellReuseIdentifier: AcountSummaryCell.reuseID)
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
        let header = AccountSummaryHeaderView(frame: .zero)
        
        var size = header.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        size.width = UIScreen.main.bounds.width
        header.frame.size = size
        
        tableView.tableHeaderView = header
    }
}

extension AccountSummaryViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard !accounts.isEmpty else { return UITableViewCell() }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: AcountSummaryCell.reuseID, for: indexPath) as! AcountSummaryCell
      
        let account = accounts[indexPath.row]
        cell.configure(with: account)
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

extension AccountSummaryViewController {
    private func fetchData() {
        fetchAccount()
        fetchProfile()
    }
    
    private func fetchAccount() {
        let savings = AcountSummaryCell.ViewModel(accountType: .Banking,
                                                  accountName: "iDevFan", balance: 92432.1)
        let chequing = AcountSummaryCell.ViewModel(accountType: .Banking,
                                                   accountName: "No-Free All-in", balance: 92332.1)
        let visa = AcountSummaryCell.ViewModel(accountType: .CreditCard,
                                                  accountName: "Visa classic card", balance: 922.32)
        let masterCard = AcountSummaryCell.ViewModel(accountType: .CreditCard,
                                                     accountName: "Student master card", balance: 17562.42)
        let investment1 = AcountSummaryCell.ViewModel(accountType: .Investment,
                                                  accountName: "Tax-Free Server", balance: 200.32)
        let investment2 = AcountSummaryCell.ViewModel(accountType: .Investment,
                                                  accountName: "Growth Fund", balance: 100.32)
        
        accounts.append(savings)
        accounts.append(chequing)
        accounts.append(visa)
        accounts.append(masterCard)
        accounts.append(investment1)
        accounts.append(investment2)
        
    }
    
    private func fetchProfile() {
        
    }
}
