//
//  MovieListVM.swift
//  PhonePeTask
//
//  Created by Lokesh Vyas on 12/03/22.
//

import Foundation

protocol MovieListVMProtocol:AnyObject {
    func didSuccess()
    func didFail()
}

class MovieListVM {
    weak var delegate : MovieListVMProtocol?
    var movieLists: MoviesListModel?
    
    func fetchMovieList() {
        self.movieLists = try? MoviesListModel.fromJSON("MovieList") as MoviesListModel?
        self.delegate?.didSuccess()
    }
}
