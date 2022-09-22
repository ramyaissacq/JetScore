//
//  AnalysisViewController.swift
//  775775Sports
//
//  Created by Remya on 9/12/22.
//

import UIKit

class AnalysisViewController: UIViewController {
    
    @IBOutlet weak var tableViewAnalysis: UITableView!
    
    var headerSizes = [CGFloat]()
    var viewModel = AnalysisViewModel()
    var sectionHeaders = ["Head to head","Home Team Recent Matches","Away Team Recent Matches","Home Team Odds","Away Team Odds"]
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()

        // Do any additional setup after loading the view.
    }
    
    func initialSetup(){
        tableViewAnalysis.register(UINib(nibName: "AnalysisHeaderTableViewCell", bundle: nil), forCellReuseIdentifier: "header")
        tableViewAnalysis.register(UINib(nibName: "AnalysisFooterTableViewCell", bundle: nil), forCellReuseIdentifier: "footer")
        tableViewAnalysis.register(UINib(nibName: "AnalysisOddsTableViewCell", bundle: nil), forCellReuseIdentifier: "oddCell")
        tableViewAnalysis.register(UINib(nibName: "AnalysisTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        
        //Calculating cell widths for headings
        headerSizes = [65,36,30,30,30,30,42,33]
        let itemSpacing:CGFloat = CGFloat((headerSizes.count - 1) * 5)
        let total_widths:CGFloat = headerSizes.reduce(0, +)
        let totalSpace:CGFloat = total_widths + itemSpacing
        let balance = (UIScreen.main.bounds.width - totalSpace)/CGFloat(headerSizes.count)
        headerSizes = headerSizes.map{$0+balance}
        
        viewModel.delegate = self
        viewModel.fetchAnalysisData()
       
    }
    

}

extension AnalysisViewController:AnalysisViewModelDelegate{
    func didFinishFetch() {
        tableViewAnalysis.reloadData()
    }
    
    
}

extension AnalysisViewController:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionHeaders.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section{
        case 0:
            return viewModel.analysisData?.headToHead?.count ?? 0
        case 1:
            return viewModel.analysisData?.homeLastMatches?.count ?? 0
        case 2:
            return viewModel.analysisData?.awayLastMatches?.count ?? 0
        case 3:
            return 6
        case 4:
            return 6
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 3 || indexPath.section == 4{
            let cell = tableView.dequeueReusableCell(withIdentifier: "oddCell") as! AnalysisOddsTableViewCell
            cell.sizes = headerSizes
            if indexPath.section == 3{
                if viewModel.analysisData?.homeOdds?.count ?? 0 > indexPath.row{
                cell.configureCell(row: indexPath.row, data: viewModel.analysisData?.homeOdds?[indexPath.row].first ?? "")
                }
            }
            else{
                if viewModel.analysisData?.awayOdds?.count ?? 0 > indexPath.row{
                cell.configureCell(row: indexPath.row, data: viewModel.analysisData?.awayOdds?[indexPath.row].first ?? "")
                }
            }
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! AnalysisTableViewCell
            var str = ""
            if indexPath.section == 0{
                str = viewModel.analysisData?.headToHead?[indexPath.row].first ?? ""
            }
            else if indexPath.section == 1{
                str = viewModel.analysisData?.homeLastMatches?[indexPath.row].first ?? ""
            }
            else if indexPath.section == 2{
                str = viewModel.analysisData?.awayLastMatches?[indexPath.row].first ?? ""
            }
            cell.configureCell(match: str)
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "header") as! AnalysisHeaderTableViewCell
        cell.lblTitle.text = sectionHeaders[section]
        return cell
    }
    

    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    
}
