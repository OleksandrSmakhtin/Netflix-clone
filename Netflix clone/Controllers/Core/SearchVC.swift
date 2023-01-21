//
//  SearchVC.swift
//  Netflix clone
//
//  Created by Oleksandr Smakhtin on 20.11.2022.
//

import UIKit

class SearchVC: UIViewController {
    
    
    
    private var titles = [Title]()
    
    
    private let searchTable: UITableView = {
        let table = UITableView()
        table.register(TitlesTableViewCell.self, forCellReuseIdentifier: TitlesTableViewCell.identifier)
        return table
    }()
    
    private let searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: SearchResultVC())
        controller.searchBar.placeholder = "Search for a Movie or a TV"
        controller.searchBar.searchBarStyle = .minimal
        return controller
    }()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        
        title = "Search"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        navigationController?.navigationBar.tintColor = .white
        navigationItem.searchController = searchController
        
        view.addSubview(searchTable)
        delegates()
        fetchDiscoverMovie()
        
        searchController.searchResultsUpdater = self
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
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let title = titles[indexPath.row]
        
        guard let titleName = title.original_name ?? title.original_title else { return }
        guard let titleOverview = title.overview else { return }
        
        APICAller.shared.getMovie(with: titleName) { [weak self]  result in
            
            switch result {
            case .success(let videoElement):
                DispatchQueue.main.async {
                    let vc = TitlePreviewVC()
                    vc.configure(with: TitlePreviewViewModel(title: titleName, YTVideo: videoElement, titleOverview: titleOverview ))
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
    }
    
    
    private func delegates() {
        searchTable.delegate = self
        searchTable.dataSource = self
    }
    
}

//MARK: - UISearchResultsUpdating

extension SearchVC: UISearchResultsUpdating, SearchResultVCDelegate {
    func searchResultVCDidTapItem(viewModel: TitlePreviewViewModel) {
        DispatchQueue.main.async { [weak self] in
            let vc = TitlePreviewVC()
            vc.configure(with: viewModel)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    
    func updateSearchResults(for searchController: UISearchController) {
        
        let searchBar = searchController.searchBar
        
        guard let query = searchBar.text,
                !query.trimmingCharacters(in: .whitespaces).isEmpty,
                query.trimmingCharacters(in: .whitespaces).count >= 5,
                let resultController = searchController.searchResultsController as? SearchResultVC
        else { return }
        
        resultController.delegate = self
        
        APICAller.shared.search(with: query) { result in
            DispatchQueue.main.async {
                
                switch result {
                case .success(let titles):
                    resultController.titles = titles
                    resultController.searchResultCollectionView.reloadData()
                case .failure(let error):
                    print(error.localizedDescription)
                }
                
            }
        }

        
        
    }
    
    
}
