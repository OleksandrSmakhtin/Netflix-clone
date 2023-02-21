//
//  SearchResultVC.swift
//  Netflix clone
//
//  Created by Oleksandr Smakhtin on 14.01.2023.
//

import UIKit

protocol SearchResultVCDelegate: AnyObject {
    func searchResultVCDidTapItem(viewModel: TitlePreviewViewModel)
}


class SearchResultVC: UIViewController {
    
    
    public var titles = [Title]() {
        didSet {
            DispatchQueue.main.async {
                self.searchResultCollectionView.reloadData()
            }
        }
    }
    
    public weak var delegate: SearchResultVCDelegate?
    
    public let searchResultCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
                                // dynamic with size
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width / 3 - 10, height: 200)
        layout.minimumInteritemSpacing = 0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(TitlesCollectionViewCell.self, forCellWithReuseIdentifier: TitlesCollectionViewCell.identifier)
        
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        view.addSubview(searchResultCollectionView)
        
        delegates()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchResultCollectionView.frame = view.bounds
    }

}


//MARK: - UIColletionViewDelegate & DataSource

extension SearchResultVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitlesCollectionViewCell.identifier, for: indexPath) as? TitlesCollectionViewCell else { return UICollectionViewCell()}
        
        //let titleName = titles[indexPath.row].original_name ?? titles[indexPath.row].original_title ?? "Unknown"
        guard let posterPath = titles[indexPath.row].poster_path else { return UICollectionViewCell()}
        
        cell.configure(with: posterPath)
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let title = titles[indexPath.row]
        guard let titleName = title.original_name ?? title.original_title else { return }
        guard let titleOverview = title.overview else { return }
        
        APICAller.shared.getMovie(with: titleName) { [weak self]  result in
            switch result {
            case .success(let videoElement):
                self?.delegate?.searchResultVCDidTapItem(viewModel: TitlePreviewViewModel(title: titleName, YTVideo: videoElement, titleOverview: titleOverview ))
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        

        
    }
    
    
    
    private func delegates() {
        searchResultCollectionView.delegate = self
        searchResultCollectionView.dataSource = self
    }
    
    
}
