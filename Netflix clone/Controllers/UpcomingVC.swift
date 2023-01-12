//
//  UpcomingVC.swift
//  Netflix clone
//
//  Created by Oleksandr Smakhtin on 20.11.2022.
//

import UIKit

class UpcomingVC: UIViewController {

    
    
    private var titles = [Title]()
    
    private let upcomingTable: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        title = "Upcoming"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        
        view.addSubview(upcomingTable)
        delegates()
        fetchUpcomingMovies()
    }
    

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        upcomingTable.frame = view.bounds
    }
    
    
    private func fetchUpcomingMovies() {
        
        APICAller.shared.getUpcomingMovies { [weak self] result in
            switch result {
            case .success(let titles):
                self?.titles = titles
                DispatchQueue.main.async {
                    self?.upcomingTable.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription )
            }
        }
        
    }

}

//MARK: - UITableViewDelegate & DataSource
extension UpcomingVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else { return UITableViewCell()}
        cell.textLabel?.text = titles[indexPath.row].original_name ?? titles[indexPath.row].original_title ?? "Unknown"
        
        return cell
    }
    
    
    
    
    func delegates() {
        upcomingTable.delegate = self
        upcomingTable.dataSource = self
    }
    
}
