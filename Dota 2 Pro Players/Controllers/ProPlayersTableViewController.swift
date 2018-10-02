//
//  ViewController.swift
//  Dota 2 Pro Players
//
//  Created by Jora on 9/28/18.
//  Copyright © 2018 Jora. All rights reserved.
//

import UIKit

class ProPlayersTableViewController: UITableViewController {
  
  let cellIdentifier = "PlayerCell"
  let loadingIdentifier = "ActivityCell"
  let segueIdentifier = "toParticipants"
  
  private var token: NSKeyValueObservation?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    refreshControl = UIRefreshControl()
    refreshControl?.addTarget(self, action: #selector(fetchProPlayers), for: .valueChanged)
    
    token = ProPlayersService.service.observe(\.players) { _, _ in
      DispatchQueue.main.async {
        self.tableView.reloadData()
        self.refreshControl?.endRefreshing()
      }
    }
    
    ProPlayersService.service.fetchProPlayers()
  }
  
  @objc func fetchProPlayers() {
    ProPlayersService.service.fetchProPlayers()
  }
}

// MARK: - UITableDataSource
extension ProPlayersTableViewController {
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return ProPlayersService.service.players.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! PlayerTableViewCell
    cell.player = ProPlayersService.service.players[indexPath.row]
    return cell
  }
}

// MARK: - UITableViewDelegate
extension ProPlayersTableViewController {
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    performSegue(withIdentifier: segueIdentifier, sender: tableView)
  }
}

// MARK: - Prepare for Segue
extension ProPlayersTableViewController {
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard segue.identifier == segueIdentifier, tableView.indexPathForSelectedRow?.row != nil else { return }
    let vc = segue.destination as! PlayedWithTableViewController
    let index = tableView.indexPathForSelectedRow!.row
    vc.accountId = ProPlayersService.service.players[index].accountId
    vc.navigationItem.title = ProPlayersService.service.players[index].name
  }
}


//// MARK: - UITableDataSource
//extension ProPlayersViewController {
//  override func numberOfSections(in tableView: UITableView) -> Int {
//    return 2
//  }
//
//  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//    if section == 0 {
//      return players.count
//    } else if section == 1 && isLoading {
//      return 1
//    }
//    return 0
//  }
//
//  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//    if indexPath.section == 0 {
//      let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! PlayerTableViewCell
//      cell.nameLabel.text = players[indexPath.row].name
//      return cell
//    } else {
//      let cell = tableView.dequeueReusableCell(withIdentifier: loadingIdentifier, for: indexPath) as! ActivityIndicatorCell
//      cell.activityIndicator.startAnimating()
//      return cell
//    }
//  }
//}
//
//// MARK: - UIScrollViewDelegate
//extension ProPlayersViewController {
//  override func scrollViewDidScroll(_ scrollView: UIScrollView) {
//
//    let offset = scrollView.contentOffset.y + tableView.adjustedContentInset.top
//    let contentHeight = scrollView.contentSize.height
//    let scrollViewFrameHeight = scrollView.bounds.height
//
//    guard !isLoading else {return}
//
//    if offset > contentHeight - scrollViewFrameHeight * 1.5
//    {
//      getNewPlayers()
//    }
//
//  }

//  func getNewPlayers() {
//    self.isLoading = true
//    tableView.reloadSections(IndexSet(integer: 1), with: .none)
//    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//      let newPlayers = (limit..<limit + step).map { Player(name: String($0))}
//      self.players.append(contentsOf: newPlayers)
//      self.isLoading = false
//      let indexPaths = (limit..<limit + step).map{ IndexPath(row: $0, section: 0)}
//      self.tableView.performBatchUpdates({
//        self.tableView.reloadSections(IndexSet(integer: 1), with: .none)
//        self.tableView.insertRows(at: indexPaths, with: .none)
//      }, completion: nil)
//      limit += step
//    }
//  }
//}

