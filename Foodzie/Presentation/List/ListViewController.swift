//
//  ListViewController.swift
//  Foodzie
//
//  Created by Inna Kuts on 07.07.2021.
//

import Foundation
import UIKit

class ListViewController: UIViewController {
    var viewModel: ListViewModelProtocol!
    @IBOutlet weak var tableView: UITableView!
    var places: [Place] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        bind()
    }

    @IBAction func onClose(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    private func configureTableView() {
        tableView.register(UINib(nibName: PlaceCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: PlaceCell.reuseIdentifier)
    }
    
    private func bind() {
        viewModel.onPlacesUpdate = { [weak self] places in
            self?.places = places
        }
    }
    
}

extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let placeCell = tableView.dequeueReusableCell(withIdentifier: PlaceCell.reuseIdentifier) as? PlaceCell else {
            return UITableViewCell()
        }
        places[safe: indexPath.row].map(placeCell.update(with:))
        return placeCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        places[safe: indexPath.row].map(viewModel.select(place:))
    }
    
}
