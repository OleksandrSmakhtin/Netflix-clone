//
//  HomeVC.swift
//  Netflix clone
//
//  Created by Oleksandr Smakhtin on 20.11.2022.
//

import UIKit



enum Sections: Int {
    case TrendingMovies = 0
    case TrendingTV = 1
    case Popular = 2
    case Upcoming = 3
    case TopRated = 4
    
}

class HomeVC: UIViewController {
    
    
    
    
    private var randomTrendingMovie: Title?
    private var headerView: HeroHeaderUIView?
    
    
    
    
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
        headerView = HeroHeaderUIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 450))
        
        // set main home header
        homeTable.tableHeaderView = headerView
        
        
//        navigationController?.navigationBar.prefersLargeTitles = true
//        navigationController?.navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.tintColor = .white
        
        // configure headerView
        configureHeroHeaderView()
                
        // customizing the navigation bar
        configureNavigationBar()
        
        
    }
    
 
    
    private func configureHeroHeaderView() {
        APICAller.shared.getTrendingMovies { result in
            switch result {
            case .success(let title):
                
                let randomTitle = title.randomElement()
                
                self.randomTrendingMovie = randomTitle
                
                let name = randomTitle?.original_name ?? randomTitle?.original_title ?? "Unknown"
                let poster = randomTitle?.poster_path ?? "No poster"
                print("-----------\(name)-----------")
                print("-----------\(poster)-----------")
                self.headerView?.configure(with: TitleViewModel(titleName: name, posterURL: poster))
                print("----------headerView.configure called")
            case .failure(let error):
                print(error.localizedDescription)
            }
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
        
        //navigationController?.navigationBar.tintColor = .label
        
        
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
    
    // change the titles for the table view
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
        
        // runs the delegate
        cell.delegate = self
        
//MARK: - API CALL
        switch indexPath.section {
         // trending movies
        case Sections.TrendingMovies.rawValue:
            APICAller.shared.getTrendingMovies { result in
                switch result {
                case .success(let titles):
                    cell.configure(with: titles)
                case .failure(let error):
                    print(error.localizedDescription)
                    
                }
            }
        // trending tvs
        case Sections.TrendingTV.rawValue:
            APICAller.shared.getTrendingTvs { result in
                switch result {
                case .success(let titles):
                    cell.configure(with: titles)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        // popular
        case Sections.Popular.rawValue:
            APICAller.shared.getPopularMovies { result in
                switch result {
                case .success(let titles):
                    cell.configure(with: titles)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        // Upcoming
        case Sections.Upcoming.rawValue:
            APICAller.shared.getUpcomingMovies { result in
                switch result {
                case .success(let titles):
                    cell.configure(with: titles)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        // top rated
        case Sections.TopRated.rawValue:
            APICAller.shared.getTopRatedMovies { result in
                switch result {
                case .success(let titles):
                    cell.configure(with: titles)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            
        default:
            return UITableViewCell()
            
        }
        
        
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

//MARK: - CollectionViewTVCDelegate
extension HomeVC: CollectionViewTVCDelegate {
    func collectionViewTVCDidTapCell(_ cell: CollectionViewTVC, viewModel: TitlePreviewViewModel) {
        
        DispatchQueue.main.async { [weak self] in
            let vc = TitlePreviewVC()
            vc.configure(with: viewModel)
            self?.navigationController?.pushViewController(vc, animated: true)
        }

    }
    
    
}
