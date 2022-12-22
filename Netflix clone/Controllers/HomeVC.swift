//
//  HomeVC.swift
//  Netflix clone
//
//  Created by Oleksandr Smakhtin on 20.11.2022.
//

import UIKit

class HomeVC: UIViewController {
    
    
    let sectionTitles: [String] = ["Trending Movies", "Trending TV", "Popular", "Upcoming Movies","Top Rated"]

    // create table view and register cell
    private let homeTable: UITableView = {
        // set a style of the table view
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(CollectionViewTVC.self, forCellReuseIdentifier: CollectionViewTVC.identifier)
        return table
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        //adding table view
        view.addSubview(homeTable)
        
        // set delegates
        setDelegates()
        
        // initialize heroHeader UIView
        let headerView = HeroHeaderUIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 450))
        // set main home header
        homeTable.tableHeaderView = headerView
        
        // customizing the navigation bar
        configureNavigationBar()
        
        fetchData()
        
    }
    
    
    
    
    private func fetchData() {
        // fetching trending movies
//        APICAller.shared.getTrendingMovies { results in
//
//            switch results {
//            case .success(let movies):
//                print(movies )
//            case .failure(let error):
//                print(error.localizedDescription)
//            }
//        }
        
        
        // fetching trending tvs
//        APICAller.shared.getTrendingTvs { results in
//
//        }
        
        
        // fetching upcoming movies
//        APICAller.shared.getUpcomingMovies { results in
//
//        }
        
        
        // fetching popular movies
//        APICAller.shared.getPopularMovies { results in
//
//        }
        
        // fetching top rated movies
        APICAller.shared.getTopRatedMovies { results in
            //
        }
        
        
        
    }
    

    
    
    
    
    private func configureNavigationBar() {
        var image = UIImage(named: "netflixLogo")
        
        image = image?.withRenderingMode(.alwaysOriginal)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .done, target: self, action: nil)
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "person"), style: .done, target: self, action: nil),
            UIBarButtonItem(image: UIImage(systemName: "play.rectangle"), style: .done, target: self, action: nil)
        ]
        
        navigationController?.navigationBar.tintColor = .label
        
        
    }
    
    
    
    
    // set constraints
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // set home table for all screen
        homeTable.frame = view.bounds
        
    }

}

//MARK: - UITableViewDelegate & DataSource
extension HomeVC: UITableViewDelegate, UITableViewDataSource {
    
    func setDelegates() {
        homeTable.delegate = self
        homeTable.dataSource = self
    }
    
    
    // number of sections
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    
    // title for section
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    // change the header for the table view
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as?  UITableViewHeaderFooterView else { return }
        
        header.textLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        header.textLabel?.frame = CGRect(x: header.bounds.origin.x + 20, y: header.bounds.origin.y, width: 100, height: header.bounds.height)
        header.textLabel?.textColor = .white
        guard let firstLetterCapitalized = header.textLabel?.text?.first?.uppercased() else { return }
        header.textLabel?.text = header.textLabel?.text?.lowercased()
        header.textLabel?.text?.remove(at: header.textLabel!.text!.startIndex)
        header.textLabel?.text?.insert(contentsOf: firstLetterCapitalized, at: header.textLabel!.text!.startIndex)
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CollectionViewTVC.identifier) as? CollectionViewTVC else { return UITableViewCell()}
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    
    
    //MARK: - make the nav bar invisible while scrolling
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let defaultOffset = view.safeAreaInsets.top
        let offset = scrollView.contentOffset.y + defaultOffset
        
        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -offset))
    }
    
    
    
    
}
