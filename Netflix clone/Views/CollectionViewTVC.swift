//
//  CollectionViewTVC.swift
//  Netflix clone
//
//  Created by Oleksandr Smakhtin on 20.11.2022.
//

import UIKit
import CoreData


protocol CollectionViewTVCDelegate: AnyObject {
    
    func collectionViewTVCDidTapCell(_ cell: CollectionViewTVC, viewModel: TitlePreviewViewModel)
}

class CollectionViewTVC: UITableViewCell {

    // create identifier
    static let identifier = "CollectionViewTVC"
    
    
    // delegate
    weak var delegate: CollectionViewTVCDelegate?
    
    // array of titles
    private var titles = [Title]()
    
    
    // create collection view
    
    private let collectionView: UICollectionView = {
        // create a layout to define a scroll direction
        let layout = UICollectionViewFlowLayout()
        // set item size
        layout.itemSize = CGSize(width: 140, height: 200)
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(TitlesCollectionViewCell.self, forCellWithReuseIdentifier: TitlesCollectionViewCell.identifier)
        return collectionView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = .systemGreen
        // add collection view to the subview
        contentView.addSubview(collectionView)
        // set delegates
        setDelegates()
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // set constraints
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = contentView.bounds
    }
    
    
    
    
    public func configure(with titles: [Title]) {
        self.titles = titles
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
        }
    }
    
    private func downloadTitleAt(indexPath: IndexPath) {
        
        DataPersistenceManager.shared.downloadTitle(with: titles[indexPath.row]) { result in
            switch result {
            case .success():
                print("Successful download")
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
    }
    
    

}
//MARK: - UICollectionView Delegate & DataSource
extension CollectionViewTVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func setDelegates() {
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitlesCollectionViewCell.identifier, for: indexPath) as? TitlesCollectionViewCell else { return UICollectionViewCell()}
        
        
        // method in titlesCVcell
        guard let model = titles[indexPath.row].poster_path else { return UICollectionViewCell() }
        cell.configure(with: model)
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        guard let titleName = titles[indexPath.row].original_title ?? titles[indexPath.row].original_name else { return }
        print(titleName + " trailer")
        
        APICAller.shared.getMovie(with: titleName + " trailer") { [weak self] retult  in
            switch retult {
            case .success(let videoElement):
                
                let title = self?.titles[indexPath.row]
                
                guard let titleOverview = title?.overview else { return }
                guard let strongSelf = self else { return }
                
                let viewModel = TitlePreviewViewModel(title: titleName, YTVideo: videoElement, titleOverview: titleOverview)
                
                self?.delegate?.collectionViewTVCDidTapCell(strongSelf, viewModel: viewModel)
                
                print(videoElement.id)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
     
    
    
    // let us download a moview
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        
        let config = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            let downloadAction = UIAction(title: "Download", subtitle: nil, image: nil, identifier: nil, discoverabilityTitle: nil, state: .off) { [weak self] _ in
                self?.downloadTitleAt(indexPath: indexPath)
            }
            return UIMenu(title: "", image: nil, identifier: nil, options: .displayInline , children: [downloadAction ])
        }
        
        return config
    }
    
    
    
}
