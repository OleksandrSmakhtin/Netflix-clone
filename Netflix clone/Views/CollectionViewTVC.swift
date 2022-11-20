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
    
    // create collection view
    
    private let collectionView: UICollectionView = {
        // create a layout to define a scroll direction
        let layout = UICollectionViewFlowLayout()
        // set item size
        layout.itemSize = CGSize(width: 140, height: 200)
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        return collectionView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = .systemPink
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
    
    

}
//MARK: - UICollectionView Delegate & DataSource
extension CollectionViewTVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func setDelegates() {
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.backgroundColor = .red
        return cell
    }
    
    
    
}
