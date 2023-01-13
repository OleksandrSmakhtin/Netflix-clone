//
//  SearchVC.swift
//  Netflix clone
//
//  Created by Oleksandr Smakhtin on 20.11.2022.
//

import UIKit

class SearchVC: UIViewController {
    
    
    
    private var titles = [Title]()
    
    
    let searchTable: UITableView = {
        let table = UITableView()
        table.register(TitlesTableViewCell.self, forCellReuseIdentifier: TitlesTableViewCell.identifier)
        return table
    }()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        
        title = "Search"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        view.addSubview(searchTable)
        delegates()
        fetchDiscoverMovie()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchTable.frame = view.bounds
    }
    
    private func fetchDiscoverMovie() {
        APICAller.shared.getDiscoverMovie { [weak self] result in
            switch result {
            case .success(let titles):
                self?.titles = titles
                DispatchQueue.main.async {
                    self?.searchTable.reloadData()
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    


}

//MARK: - UITableViewDelegate & DataSource

extension SearchVC: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitlesTableViewCell.identifier) as? TitlesTableViewCell else { return UITableViewCell()}
        
        let titleName = titles[indexPath.row].original_title ?? titles[indexPath.row].original_name ?? "Unknown"
        let posterURL = titles[indexPath.row].poster_path
        
        cell.configure(with: TitleViewModel(titleName: titleName, posterURL: posterURL!))
        
        return cell
    }
    
    
    private func delegates() {
        searchTable.delegate = self
        searchTable.dataSource = self
    }
    
}
