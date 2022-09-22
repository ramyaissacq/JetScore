//
//  SearchViewController.swift
//  775775Sports
//
//  Created by Remya on 9/17/22.
//

import UIKit

class SearchViewController: BaseViewController {
    //MARK: - IBOutlets
    @IBOutlet weak var searchBar:UISearchBar!
    @IBOutlet weak var tableView:UITableView!
    
    //MARK: - Variables
    
    var viewModel = HomeVieModel()
    var page = 1

    override func viewDidLoad() {
        super.viewDidLoad()
        initialSettings()

    }
    
    func initialSettings(){
        setTitle()
        setBackButton()
        tableView.register(UINib(nibName: "ScoresTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        viewModel.delegate = self
        
    }
    
}

extension SearchViewController:HomeViewModelDelegate{
    func diFinisfFetchMatches() {
        page += 1
        doSearch(searchText: searchBar.text ?? "")
        
    }
    
    func getCurrentPage() -> Int {
      return 0
    }
    
    func didFinishFetchRecentMatches() {
        
    }
    
    func didFinishFilterByLeague() {
        
    }
    
    func didFinishFetchBasketballScores() {
        
    }
    
    
}

//MARK: - Searchbar Delegates
extension SearchViewController:UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.trim() != ""{
            doSearch(searchText: searchText)
            
        }
        else{
            self.viewModel.matches?.removeAll()
            tableView.reloadData()
        }
        
    }
    
    func doSearch(searchText:String){
        self.viewModel.matches?.removeAll()
        self.viewModel.matches = self.viewModel.originals?.filter{($0.leagueName?.lowercased().contains(searchText.lowercased()) ?? false) || ($0.homeName?.lowercased().contains(searchText.lowercased()) ?? false) || ($0.awayName?.lowercased().contains(searchText.lowercased()) ?? false)}
        tableView.reloadData()
        
    }
    
    
}

//MARK: - TableView Delegates
extension SearchViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.viewModel.matches?.count ?? 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == (self.viewModel.matches?.count ?? 0) - 1{
            if (viewModel.pageData?.lastPage ?? 0) > page{
                viewModel.getMatchesList(page: page)
            }
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ScoresTableViewCell
        cell.callIndexSelection = {
            self.goToCategory(index: indexPath.row, category: .index)
        }
        
        cell.callAnalysisSelection = {
            self.goToCategory(index: indexPath.row, category: .analysis)
        }
        
        cell.callEventSelection = {
            self.goToCategory(index: indexPath.row, category: .event)
            
        }
        cell.callBriefingSelection = {
            self.goToCategory(index: indexPath.row, category: .breifing)
            
        }
        cell.callLeagueSelection = {
            self.goToCategory(index: indexPath.row, category: .league)
            
        }
        
        cell.configureCell(obj: self.viewModel.matches?[indexPath.row])
        return cell
        
    }
    
    func goToCategory(index:Int,category:HomeCategory){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeCategoryViewController") as! HomeCategoryViewController
        HomeCategoryViewController.matchID = self.viewModel.matches?[index].matchId
        vc.selectedMatch =  self.viewModel.matches?[index]
        vc.selectedCategory = category
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
   
    
}
