//
//  ViewController.swift
//  UQuiz
//
//  Created by Greed on 3/7/24.
//

import UIKit
import SnapKit

class ViewController: BaseViewController {
    
    let apiManager = TMDBAPIManager.shared
    let searchBar = UISearchBar()
    var movieList: SearchMovie = SearchMovie(results: [])

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
    }

    override func configureViewController() {
        searchBar.delegate = self
        view.addSubview(searchBar)
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(30)
            make.height.equalTo(40)
        }
    }

}

extension ViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        apiManager.request(type: SearchMovie.self, api: .movieSearchURL(query: searchBar.text!)) { value in
            self.movieList = value
            print(self.movieList)
        }
    }
}

