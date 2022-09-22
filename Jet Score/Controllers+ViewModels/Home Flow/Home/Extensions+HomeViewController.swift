//
//  Extensions+HomeViewController.swift
//  775775Sports
//
//  Created by Remya on 9/21/22.
//

import Foundation
import UIKit

extension HomeViewController:HomeViewModelDelegate{
    func didFinishFetchBasketballScores() {
        prepareDisplays()
    }
    
    func didFinishFilterByLeague() {
        prepareDisplays()
    }
    
    func didFinishFetchRecentMatches() {
        
        prepareDisplays()
    }
    
    func getCurrentPage() -> Int {
        return page
    }
    
    func diFinisfFetchMatches() {
        page += 1
        viewModel.filterMatches(type: selectedType)
        var arr:[String] = viewModel.scoreResponse?.todayHotLeague?.map{$0.leagueName ?? ""} ?? []
        arr.insert("All Leagues", at: 0)
        self.leagueDropDown?.dataSource = arr
        self.lblLeague.text = arr.first
        prepareDisplays()
        
    }
    
    func prepareDisplays(){
        tableView.reloadData()
        if selectedSportsType == .soccer{
        if viewModel.matches?.count ?? 0 > 0{
            noDataView.isHidden = true
        }
        else{
            noDataView.isHidden = false
        }
        }
    }
    
}

extension HomeViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionViewCategory{
        return viewModel.categories.count
        }
        else{
            return AppPreferences.getMatchHighlights().count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collectionViewCategory{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RoundSelectionCollectionViewCell", for: indexPath) as! RoundSelectionCollectionViewCell
        cell.configureCell(unselectedViewColor: Colors.fadeRedColor(), selectedViewColor: Colors.accentColor(), unselectedTitleColor: Colors.accentColor(), selectedTitleColor: .white, title: viewModel.categories[indexPath.row])
        return cell
        }
        else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HighlightsCollectionViewCell", for: indexPath) as! HighlightsCollectionViewCell
            let matches = AppPreferences.getMatchHighlights()
            cell.configureCell(obj: matches[indexPath.row])
            cell.scoresView.callBackIndex = {
                self.goToCategory(obj:matches[indexPath.row], category: .index)
            }
            
            cell.scoresView.callBackAnalysis = {
                self.goToCategory(obj:matches[indexPath.row], category: .analysis)
                
            }
            cell.scoresView.callBackLeague = {
                self.goToCategory(obj:matches[indexPath.row], category: .league)
                
            }
            cell.scoresView.callBackEvent = {
                self.goToCategory(obj:matches[indexPath.row], category: .event)
                
            }
            cell.scoresView.callBackBreifing = {
                self.goToCategory(obj:matches[indexPath.row], category: .breifing)
                
            }
            
         return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == collectionViewCategory{
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        if selectedTimeIndex == 0{
            selectedType = indexPath.row
            viewModel.filterMatches(type: selectedType)
            prepareDisplays()
        }
        else{
            selectedDate = viewModel.categories[indexPath.row]
            viewModel.getRecentMatches(date: selectedDate)
            
        }
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == collectionViewCategory{
        if categorySizes.count == 0{
            calculateCategorySizes()
        }
        return CGSize(width: categorySizes[indexPath.row], height: 55)
        }
        else{
            let w = UIScreen.main.bounds.width - 10
            return CGSize(width: w, height: 170)
        }
        
    }
    
    //calculating categorySizes
    func calculateCategorySizes(){
        for m in viewModel.categories{
            let w = m.width(forHeight: 14, font: UIFont(name: "Poppins-Regular", size: 12)!) + 16
            categorySizes.append(w)
        }
    }
    
    
}


extension HomeViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getModelCount(sport: selectedSportsType)
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (selectedSportsType == .soccer) && (selectedTimeIndex == 0){
            if indexPath.row == viewModel.getModelCount(sport: selectedSportsType)-1 && selectedLeagueID == nil{
                if page <= (viewModel.pageData?.lastPage ?? 0){
                    viewModel.getMatchesList(page: page)
                }
            }
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ScoresTableViewCell
        cell.callIndexSelection = {
            self.goToCategory(obj:self.viewModel.matches?[indexPath.row], category: .index)
        }
        
        cell.callAnalysisSelection = {
            self.goToCategory(obj:self.viewModel.matches?[indexPath.row], category: .analysis)
        }
        
        cell.callEventSelection = {
            self.goToCategory(obj:self.viewModel.matches?[indexPath.row], category: .event)
            
        }
        cell.callBriefingSelection = {
            self.goToCategory(obj:self.viewModel.matches?[indexPath.row], category: .breifing)
            
        }
        cell.callLeagueSelection = {
            self.goToCategory(obj:self.viewModel.matches?[indexPath.row], category: .league)
            
        }
        cell.callLongPress = {
            self.showMatchOptions(row: indexPath.row)
            
        }
        
        if selectedSportsType == .soccer{
        cell.configureCell(obj: viewModel.matches?[indexPath.row])
        }
        else{
            cell.configureCell(obj: viewModel.basketballMatches?[indexPath.row])
        }
        return cell
        
    }
    
    func goToCategory(obj:MatchList?,category:HomeCategory){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeCategoryViewController") as! HomeCategoryViewController
        HomeCategoryViewController.matchID = obj?.matchId
        vc.selectedMatch =  obj
        vc.selectedCategory = category
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func showMatchOptions(row:Int){
        if longPressId == nil{
        longPressId = row
            guard let obj = viewModel.matches?[row] else{return}
        Dialog.openMatchOptionsDialog {
            self.longPressId = nil
            let matchDate = Utility.getSystemTimeZoneTime(dateString: obj.matchTime ?? "")
            if matchDate > Date(){
                Utility.scheduleLocalNotification(date: matchDate, subTitle: obj.leagueName ?? "", body: "Match \(obj.homeName ?? "") Vs \(obj.awayName ?? "") will start now")
            }
            else{
                Utility.showErrorSnackView(message: "Please choose upcoming matches")
            }
            
        } callHighlights: {
            self.longPressId = nil
            AppPreferences.addToHighlights(obj: obj)
            self.collectionViewHighlights.reloadData()
            self.pageControl.numberOfPages = AppPreferences.getMatchHighlights().count
            self.highlightsStack.isHidden = false
            
        } callPin: {
            self.longPressId = nil
        } callClose: {
            self.longPressId = nil
        }
        }
  
    }
    
   
    
}


extension HomeViewController:UIGestureRecognizerDelegate{
    
}
