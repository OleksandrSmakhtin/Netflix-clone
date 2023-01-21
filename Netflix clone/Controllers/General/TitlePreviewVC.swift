//
//  TitlePreviewVC.swift
//  Netflix clone
//
//  Created by Oleksandr Smakhtin on 15.01.2023.
//

import UIKit
import WebKit

class TitlePreviewVC: UIViewController {

    
    private let titleLbl: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.numberOfLines = 0
        label.textColor = .white
        return label
    }()
    
    private let overviewLbl: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.numberOfLines = 0
        label.textColor = .lightGray
        return label
    }()
    
    private let downloadBtn: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .red
        button.layer.cornerRadius = 15
        button.setTitle("Download", for: .normal)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    private let webView: WKWebView = {
        let view = WKWebView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        
        view.addSubview(webView)
        view.addSubview(titleLbl)
        view.addSubview(overviewLbl)
        view.addSubview(downloadBtn)
        
        configureConstraints()
    }
    
    
    private func configureConstraints() {
        
        let webViewConstraints = [
            webView.topAnchor.constraint(equalTo: view.topAnchor, constant: 60),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.heightAnchor.constraint(equalToConstant: 300)
        ]
        
        let titleLblConstraints = [
            titleLbl.topAnchor.constraint(equalTo: webView.bottomAnchor, constant: 20),
            titleLbl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLbl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ]
        
        let overviewLblConstraints = [
            overviewLbl.topAnchor.constraint(equalTo: titleLbl.bottomAnchor, constant: 20),
            overviewLbl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            overviewLbl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25)
        ]
        
        let downloadBtnConstraints = [
            downloadBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            downloadBtn.topAnchor.constraint(equalTo: overviewLbl.bottomAnchor, constant: 25),
            downloadBtn.widthAnchor.constraint(greaterThanOrEqualToConstant: 100)
        ]
        
        NSLayoutConstraint.activate(webViewConstraints)
        NSLayoutConstraint.activate(titleLblConstraints)
        NSLayoutConstraint.activate(overviewLblConstraints)
        NSLayoutConstraint.activate(downloadBtnConstraints)
    }
    
    func configure(with model: TitlePreviewViewModel) {
        titleLbl.text = model.title
        print("------Title: \(model.title)------")
        overviewLbl.text = model.titleOverview
        print("------Overview: \(model.titleOverview)-------")
        guard let url = URL(string: "https://www.youtube.com/embed/\(model.YTVideo.id.videoId)") else { return }
        
        print("------URL: \(url)---------")
        
        webView.load(URLRequest(url: url))
    }

}
