//
//  ViewController.swift
//  CondeNastTask
//
//  Created by Lokesh Vyas on 10/03/22.
//

import UIKit

class TopHeadlineListView: UIViewController {
    
    // IBOutlet
    @IBOutlet weak var collectionView: UICollectionView!
    
    // Properties
    private var viewModel : TopHeadlineVM = {
        let viewModel = TopHeadlineVM()
        return viewModel
    }()
    
    private let numberOfColumns = 2
    private let cellPadding: CGFloat = 6
        
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupCollectionView()
        viewModel.delegate = self
        viewModel.fetchAllData()
        // Do any additional setup after loading the view.
    }
    
    private func setupCollectionView() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        collectionView?.backgroundColor = .clear
        collectionView?.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
}
// MARK: - Collection View Data Source Delegate
extension TopHeadlineListView: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.data?.articles.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HeadlineCell", for: indexPath) as? HeadlineCell
        cell?.articleModel = viewModel.data?.articles[indexPath.row]
        return cell ?? UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailViewController = DetailViewController.instantiate(fromAppStoryboard: .main)
        detailViewController.articleData = viewModel.data?.articles[indexPath.row]
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
}

// MARK: - Collection View Flow Layout Delegate
extension TopHeadlineListView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
      let itemSize = (collectionView.frame.width - (collectionView.contentInset.left + collectionView.contentInset.right + 10)) / 2
      return CGSize(width: itemSize, height: itemSize)
    }
}


extension TopHeadlineListView : TopHeadlineVMProtocol {
    func didSuccess() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    func didFail() {
        // Failure condition
    }
}






