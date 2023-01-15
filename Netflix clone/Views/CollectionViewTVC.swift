//
//  CollectionViewTVC.swift
//  Netflix clone
//
//  Created by Oleksandr Smakhtin on 20.11.2022.
//

import UIKit

class CollectionViewTVC: UITableViewCell {

    // create identifier
    static let identifier = "CollectionViewTVC"
    
    
    
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
        
        APICAller.shared.getMovie(with: titleName + " trailer") { retult  in
            switch retult {
            case .success(let videoElement):
                print(videoElement.id)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
    }
    
    
    
}
