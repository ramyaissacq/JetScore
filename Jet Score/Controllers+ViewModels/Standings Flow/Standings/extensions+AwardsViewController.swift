//
//  extensions+AwardsViewController.swift
//  775775Sports
//
//  Created by Remya on 9/9/22.
//

import Foundation
import UIKit

extension AwardsViewController:AwardsViewModeldelegate{
    func didFinishTeamStandingsFetch() {
        imgLogo.setImage(with: viewModel.teamStandings?.leagueInfo?.logo, placeholder: Utility.getPlaceHolder())
        if selectedTopTitleIndex == 0{
            lblSelectedLeague.text = (viewModel.teamStandings?.leagueInfo?.nameEn ?? "") + " " + (viewModel.teamStandings?.leagueInfo?.season ?? "")
        imgLogo.isHidden = false
           emptyChecks()
        }
        self.tableViewStandings.reloadData()
        
    }
    
    func didFinishPlayerStandingsFetch(){
        if selectedTopTitleIndex == 1{
            lblSelectedLeague.text = lblLeague.text
            imgLogo.isHidden = true
           emptyChecks()
        }
        self.tableViewStandings.reloadData()
    
    }
    
    
}

extension AwardsViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionViewTop{
            return topTitles.count
        }
        else{
            return headers.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collectionViewTop{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SelectionCollectionViewCell", for: indexPath) as! SelectionCollectionViewCell
            cell.lblTitle.text = topTitles[indexPath.row]
            return cell
        }
        else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TitleCollectionViewCell", for: indexPath) as! TitleCollectionViewCell
            cell.titleType = .RedHeader
            cell.lblTitle.text = headers[indexPath.row]
            return cell
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == collectionViewTop{
            selectedTopTitleIndex = indexPath.row
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            setupViews()
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == collectionViewTop{
            let w = UIScreen.main.bounds.width / 2
            return CGSize(width: w, height: 55)
        }
        else{
            return CGSize(width: headerSizes[indexPath.row], height: 55)
        }
    }
    
    
}

extension AwardsViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if selectedTopTitleIndex == 0{
            return viewModel.teamStandings?.totalStandings?.count ?? 0
        }
        else{
            return viewModel.playerStandings?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! StandingsTableViewCell
        //cell.cellIndex = indexPath.row
        cell.headerSizes = headerSizes
        if selectedTopTitleIndex == 0{
            let standings = viewModel.getTeamRowByIndex(index: indexPath.row)
            let results = viewModel.getResultsArrayByIndex(index: indexPath.row)
            let percentageStr = viewModel.getResultsPercentageStringByIndex(index: indexPath.row)
            cell.configureTeamStandings(index: indexPath.row, standings: standings, results: results, resultsPercentage: percentageStr)
        }
        else{
            let standings = viewModel.getPlayerRowByIndex(index: indexPath.row)
            let points = viewModel.getPlayerPointsByIndex(index: indexPath.row)
            cell.configurePlayerStandings(index: indexPath.row, standings: standings, points: points)
        }
        cell.callReloadCell = {
            tableView.reloadRows(at: [indexPath], with: .none)
        }
        
        
        return cell
    }
    
    
}
