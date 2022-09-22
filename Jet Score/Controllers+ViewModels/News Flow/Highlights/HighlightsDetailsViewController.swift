//
//  HighlightsDetailsViewController.swift
//  775775Sports
//
//  Created by Remya on 9/3/22.
//

import UIKit
import AVKit

class HighlightsDetailsViewController: BaseViewController {
    //MARK: - IBOutlets
    @IBOutlet weak var videoView:UIView!
    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var lblTime:UILabel!
    @IBOutlet weak var tableViewVideos:UITableView!
    @IBOutlet weak var videoTableHeight:NSLayoutConstraint!
    @IBOutlet weak var scroll:UIScrollView!
    
    //MARK: - Variables
    var tableViewVideoObserver: NSKeyValueObservation?
    var selectedVideo:VideoList?
    var videoList:[VideoList]?
    let smallVideoPlayerViewController = AVPlayerViewController()
    var player:AVPlayer?
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSettings()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        player?.pause()
        player = nil
        smallVideoPlayerViewController.removeFromParent()
    }
    
    
    func initialSettings(){
        setBackButton()
        tableViewVideos.register(UINib(nibName: "VideoTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        tableViewVideoObserver = tableViewVideos.observe(\.contentSize, options: .new) { (_, change) in
            guard let height = change.newValue?.height else { return }
            self.videoTableHeight.constant = height
        }
        configureVideoPlayer()
        displaySelectedVideo()
        
    }
    
    func configureVideoPlayer(){
        // smallVideoPlayerViewController.showsPlaybackControls = false
        player = AVPlayer()
        smallVideoPlayerViewController.player = player
        videoView.addSubview(smallVideoPlayerViewController.view)
        smallVideoPlayerViewController.view.frame = videoView.bounds
        //smallVideoPlayerViewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
    }
    
    func displaySelectedVideo(){
        //player.replaceCurrentItem(with: AVPlayerItem(url: streamingURL))
        lblTitle.text = selectedVideo?.title
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Utility.dateFormat.ddMMyyyyWithTimeZone.rawValue
        lblTime.text = Utility.formatDate(date: dateFormatter.date(from: selectedVideo?.createTime ?? ""), with: .ddMMyyyyWithTimePretty)
       
        guard let videoUrl = URL(string: selectedVideo?.path ?? "") else{return}
        player?.replaceCurrentItem(with: AVPlayerItem(url: videoUrl))
        player?.play()
       
    }
}

extension HighlightsDetailsViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videoList?.count ?? 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! VideoTableViewCell
        cell.configureCell(obj: videoList?[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedVideo = videoList?[indexPath.row]
        displaySelectedVideo()
        scroll.setContentOffset(.zero, animated: true)
        
    }
    
    
}
