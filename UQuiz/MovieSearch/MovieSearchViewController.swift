//
//  ViewController.swift
//  UQuiz
//
//  Created by Greed on 3/7/24.
//

import UIKit

class MovieSearchViewController: BaseViewController {
    
    let viewModel = MovieSearchViewModel()
    let mainView = MovieSearchView()

    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func configureViewController() {
        mainView.searchBar.delegate = self
    }

}

extension MovieSearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        viewModel.inputAPIRequest.value = searchBar.text
    }
    
}

