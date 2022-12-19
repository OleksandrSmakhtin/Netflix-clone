//
//  HomeVC.swift
//  Netflix clone
//
//  Created by Oleksandr Smakhtin on 20.11.2022.
//

import UIKit

class HomeVC: UIViewController {

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
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        20
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
