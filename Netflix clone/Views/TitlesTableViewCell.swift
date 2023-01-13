//
//  UpcomingTableViewCell.swift
//  Netflix clone
//
//  Created by Oleksandr Smakhtin on 12.01.2023.
//

import UIKit

class TitlesTableViewCell: UITableViewCell {

    static let identifier = "UpcomingTableViewCell"
    
    
    private let playButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "play.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30))
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let posterView: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
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
            posterView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            posterView.widthAnchor.constraint(equalToConstant: 100)
        ]
        // for titleLbl
        let titleLblConstraints = [
            titleLbl.leadingAnchor.constraint(equalTo: posterView.trailingAnchor, constant: 20),
            titleLbl.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ]
        // for playBtn
        let playButtonConstraints = [
            playButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            playButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ]
        
        NSLayoutConstraint.activate(posterViewConstraints)
        NSLayoutConstraint.activate(titleLblConstraints)
        NSLayoutConstraint.activate(playButtonConstraints)
    }
    
    public func configure(with model: TitleViewModel) {
        
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500\(model.posterURL)") else { return }
        
        posterView.sd_setImage(with: url, completed: nil)
        titleLbl.text = model.titleName
         
        
    }
    
    

}
