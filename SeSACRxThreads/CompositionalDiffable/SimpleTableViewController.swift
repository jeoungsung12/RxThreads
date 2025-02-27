//
//  SimpleTableViewController.swift
//  SeSACRxThreads
//
//  Created by 정성윤 on 2/26/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class SimpleTableViewController: UIViewController {
    
    private lazy var tableView = {
        let view = UITableView()
        view.dataSource = self
        view.delegate = self
        view.register(UITableViewCell.self, forCellReuseIdentifier: "simpleCell")
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }

}

extension SimpleTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "simpleCell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        content.text = "그냥 텍스트"
        content.secondaryText = "두번째 텍스트"
        content.image = UIImage(systemName: "star")
        content.textProperties.font = .boldSystemFont(ofSize: 20)
        content.imageToTextPadding = 100
        cell.contentConfiguration = content
        //최소 버전 14.0
        
        return cell
    }
    
}
