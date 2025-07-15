//
//  ViewController.swift
//  TravelProject
//
//  Created by hwan on 7/13/25.
//

import UIKit

final class MagazineViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    private var magazineInfo: [Magazine] = MagazineInfo.magazine
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(
            UINib(nibName: MagazineCell.id, bundle: nil),
            forCellReuseIdentifier: MagazineCell.id
        )
    }
}

extension MagazineViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        magazineInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MagazineCell.id, for: indexPath) as? MagazineCell else {
            return UITableViewCell()
        }
        
        cell.set(info: magazineInfo[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}
