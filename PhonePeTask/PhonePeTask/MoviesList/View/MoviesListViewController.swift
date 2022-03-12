//
//  MoviesListViewController.swift
//  PhonePeTask
//
//  Created by Lokesh Vyas on 12/03/22.
//

import UIKit

class MoviesListViewController: UIViewController {
    
    @IBOutlet weak var tableViewMovieList: UITableView!
    
    private var viewModel : MovieListVM = {
        let viewModel = MovieListVM()
        return viewModel
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerTableViewCells()
        viewModel.delegate = self
        viewModel.fetchMovieList()
        // Do any additional setup after loading the view.
    }
    
    private func registerTableViewCells() {
        let textFieldCell = UINib(nibName: "MovieListCell",
                                  bundle: nil)
        self.tableViewMovieList.register(textFieldCell,
                                         forCellReuseIdentifier: "MovieListCell")
        self.tableViewMovieList.dataSource = self
        self.tableViewMovieList.delegate = self
        self.tableViewMovieList.reloadData()
    }
}

// MARK:- Movie List Table View
extension MoviesListViewController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.movieLists?.results.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieListCell", for: indexPath) as! MovieListCell
        cell.selectionStyle = .none
        cell.movieData = self.viewModel.movieLists?.results[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movieDetailViewController = MovieDetailViewController.instantiate(fromAppStoryboard: .main)
        movieDetailViewController.movieData = self.viewModel.movieLists?.results[indexPath.row]
        self.navigationController?.pushViewController(movieDetailViewController, animated: true)
    }
}

extension MoviesListViewController : MovieListVMProtocol {
    func didSuccess() {
        DispatchQueue.main.async {
            self.tableViewMovieList.reloadData()
        }
    }
    
    func didFail() {
    }
}
