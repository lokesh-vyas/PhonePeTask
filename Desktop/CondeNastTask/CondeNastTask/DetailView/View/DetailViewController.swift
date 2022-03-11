//
//  DetailViewController.swift
//  CondeNastTask
//
//  Created by Lokesh Vyas on 10/03/22.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var detailTableView: UITableView!
    
    var articleData : Article?
    
    private var viewModel : DetailVM = {
        let viewModel = DetailVM()
        return viewModel
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerTableViewCells()
        self.viewModel.delegate = self
        self.viewModel.articleURL = articleData?.url
        self.viewModel.fetchLikesComments()
        
        // Do any additional setup after loading the view.
    }
    
    private func registerTableViewCells() {
        let textFieldCell = UINib(nibName: "DetailViewCell",
                                  bundle: nil)
        self.detailTableView.register(textFieldCell,
                                      forCellReuseIdentifier: "DetailViewCell")
        self.detailTableView.dataSource = self
        self.detailTableView.delegate = self
        detailTableView.rowHeight = 400
        detailTableView.estimatedRowHeight = 500
        self.detailTableView.reloadData()
    }
}

extension DetailViewController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailViewCell", for: indexPath) as! DetailViewCell
        cell.articleData = self.articleData
        return cell
    }
}

extension DetailViewController : DetailVMProtocol {
    func didSuccess(like: String, comments: String) {
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: 0, section: 0)
            let cell = self.detailTableView.cellForRow(at: indexPath) as? DetailViewCell
            cell?.lblLikesCount.text = "Likes : \(like)"
            cell?.lblCommentsCount.text = "Comments : \(comments)"
        }
    }
    
    func didFail() {
        print("")
    }
}
