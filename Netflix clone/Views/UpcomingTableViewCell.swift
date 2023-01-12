//
//  UpcomingTableViewCell.swift
//  Netflix clone
//
//  Created by Oleksandr Smakhtin on 12.01.2023.
//

import UIKit

class UpcomingTableViewCell: UITableViewCell {

    static let identifier = "UpcomingTableViewCell"
    
    
    private let playButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let posterView: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLbl: UILabel = {
        let label = UILabel()
        // enable constarints
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(posterView)
        contentView.addSubview(titleLbl)
        contentView.addSubview(playButton)
        
        applyConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func applyConstraints() {
        // for poster
        let posterViewConstraints = [
            posterView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            posterView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            posterView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15),
            posterView.widthAnchor.constraint(equalToConstant: 100)
        ]
        NSLayoutConstraint.activate(posterViewConstraints )
    }
    
    public func configure(with model: TitleViewModel) {
        
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500\(model.posteURL)") else { return }
        
        posterView.sd_setImage(with: url, completed: nil)
        titleLbl.text = model.titleName
         
        
    }
    
    

}
