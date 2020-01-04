//
//  HomeMovieViewController.swift
//  Movie_Clean_Swift
//
//  Created by Álvaro Fernandes on 30/12/19.
//  Copyright (c) 2019 Álvaro Fernandes. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol HomeMovieDisplayLogic: class {
  func reloadTableView()
}

class HomeMovieViewController: UITableViewController {
    
  var interactor: HomeMovieBusinessLogic?
  var router: (NSObjectProtocol & HomeMovieRoutingLogic & HomeMovieDataPassing)?
    
    override func loadView() {
        super.loadView()
        setup()
    }
    
    private func setup() {
        let viewController = self
        let interactor = HomeMovieInteractor()
        let presenter = HomeMoviePresenter()
        let router = HomeMovieRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        interactor?.load()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        if let headerView = tableView.tableHeaderView {
            let height = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
            var headerFrame = headerView.frame
            if height != headerFrame.size.height {
                headerFrame.size.height = height
                headerView.frame = headerFrame
                tableView.tableHeaderView = headerView
            }
        }
        
        if let footerView = tableView.tableFooterView {
            let height = CGFloat.footerViewSpacing
            var footerFrame = footerView.frame
            if height != footerFrame.size.height {
                 footerFrame.size.height = height
                 footerView.frame = footerFrame
                 tableView.tableFooterView = footerView
             }
        }
    }
    
    private func setupTableView() {

        tableView.separatorColor = .clear
        tableView.backgroundColor = .clear
        tableView.layer.backgroundColor = UIColor.clear.cgColor
        tableView.register(HomeMovieCell.self, forCellReuseIdentifier: "MovieCell")
        
        let tableHeaderView = HomeMovieHeader()
        tableHeaderView.delegate = self
        tableView.tableHeaderView = tableHeaderView
        
        let tableFooterView = HomeMovieFooter()
        tableFooterView.delegate = self
        tableView.tableFooterView = tableFooterView
    }

}

extension HomeMovieViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return interactor?.numberOfRows ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell") as? HomeMovieCell,
            let viewModel: HomeMovieModels.ViewModel = interactor?.cellForRow(at: indexPath.row)
        else {
            return UITableViewCell()
        }
        cell.configureCell(viewModel: viewModel)

        return cell
    }
        
}

extension HomeMovieViewController: HomeMovieDisplayLogic {
    
    func reloadTableView() {
        tableView.reloadData()
    }
    
}

extension HomeMovieViewController: HomeMovieHeaderDelegate {
    
    func changeForPopular() {
        interactor?.changeForPopular()
    }
    
    func changeForNew() {
        interactor?.changeForNew()
    }
    
    func searchBarFilter(_ text: String) {
        interactor?.filterMovies(text)
    }
    
}

extension HomeMovieViewController: HomeMovieFooterDelegate {
    
    func getMore() {
        interactor?.load()
    }
 
}

