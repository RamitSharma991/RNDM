//
//  ViewController.swift
//  RNDM
//
//  Created by Ramit sharma on 20/03/19.
//  Copyright © 2019 Ramit sharma. All rights reserved.
//

import UIKit


enum ThoughtCategory : String {
    case serious = "serious"
    case funny = "funny"
    case crazy = "crazy"
    case popular = "popular"
}


class MainVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    //outlets
    
    @IBOutlet private var segmentControl: UISegmentedControl!
    @IBOutlet private var tableview: UITableView!
    
    private var thoughts = [Thought]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.delegate = self
        tableview.dataSource = self
        //Dynamic Table cell size
        tableview.estimatedRowHeight = 80
        tableview.rowHeight = UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return thoughts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier:"ThoughtCell", for: indexPath) as? ThoughtCell {
            cell.configureCell(thought: thoughts[indexPath.row])
            return cell
            
        } else {
            return UITableViewCell()
        }
        
    }
    
    
}

