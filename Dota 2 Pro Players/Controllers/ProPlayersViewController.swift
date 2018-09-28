//
//  ViewController.swift
//  Dota 2 Pro Players
//
//  Created by Jora on 9/28/18.
//  Copyright © 2018 Jora. All rights reserved.
//

import UIKit

// Pagination properties
var offset = 0
var limit = 20
let step = 20

class ProPlayersViewController: UITableViewController {
  
  var isLoading = false
  
  let cellIdentifier = "PlayerCell"
  let loadingIdentifier = "ActivityCell"
  
  var players: [Player]!

  override func viewDidLoad() {
    super.viewDidLoad()
    
    if !isLoading {
      players = (offset..<limit).map{ Player(name: String($0)) }
    }
  }
}

// MARK: - UITableDataSource
extension ProPlayersViewController {
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 2
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if section == 0 {
      return players.count
    } else if section == 1 && isLoading {
      return 1
    }
    return 0
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    if indexPath.section == 0 {
      let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! PlayerTableViewCell
      cell.nameLabel.text = players[indexPath.row].name
      return cell
    } else {
      let cell = tableView.dequeueReusableCell(withIdentifier: loadingIdentifier, for: indexPath) as! ActivityIndicatorCell
      cell.activityIndicator.startAnimating()
      return cell
    }
  }
}

// MARK: - UIScrollViewDelegate
extension ProPlayersViewController {
  override func scrollViewDidScroll(_ scrollView: UIScrollView) {
    
    let offset = scrollView.contentOffset.y + tableView.adjustedContentInset.top
    let contentHeight = scrollView.contentSize.height
    let scrollViewFrameHeight = scrollView.bounds.height
    
    guard !isLoading else {return}
    
    if offset > contentHeight - scrollViewFrameHeight * 1.5
    {
      getNewPlayers()
    }

  }
  
  func getNewPlayers() {
    self.isLoading = true
    tableView.reloadSections(IndexSet(integer: 1), with: .none)
    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
      let newPlayers = (limit..<limit + step).map { Player(name: String($0))}
      self.players.append(contentsOf: newPlayers)
      self.isLoading = false
      let indexPaths = (limit..<limit + step).map{ IndexPath(row: $0, section: 0)}
      self.tableView.performBatchUpdates({
        self.tableView.reloadSections(IndexSet(integer: 1), with: .none)
        self.tableView.insertRows(at: indexPaths, with: .none)
      }, completion: nil)
      limit += step
    }
  }
}

