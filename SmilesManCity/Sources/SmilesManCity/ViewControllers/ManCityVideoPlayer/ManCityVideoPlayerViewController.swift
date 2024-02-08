//
//  File.swift
//  
//
//  Created by Muhammad Shayan Zahid on 06/07/2023.
//

import UIKit
import YouTubeiOSPlayerHelper
import SmilesUtilities
import AVKit
import AVFoundation
import SmilesLanguageManager
import SmilesFontsManager

public class ManCityVideoPlayerViewController: UIViewController {
    
    // MARK: - OUTLETS -
    @IBOutlet weak var welcomeTitleLabel: UILabel!
    @IBOutlet weak var youtubePlayerView: YTPlayerView!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var playButton: UIButton!
    var customPop:(()->Void)?
    // MARK: - PROPERTIES -
    public var videoUrl: String?
    public var username: String?
    var isFirstTime = false
    
    // MARK: - LIFECYCLE -
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.initialSetup()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
    }
    
    // MARK: - ACTIONS -
    @IBAction func playButtonTapped(_ sender: UIButton) {
        self.playVideo()
    }
    
    // MARK: - METHODS -
    func initialSetup() {
        welcomeTitleLabel.isHidden = !isFirstTime
        let thumbnailUrl = AppCommonMethods.extractThumbnailFromYoutube(url: self.videoUrl ?? "")
        thumbnailImageView.setImageWithUrlString(thumbnailUrl) { image in
            if let image {
                self.thumbnailImageView.image = image
            }
        }
        
        self.welcomeTitleLabel.fontTextStyle = .smilesTitle1
        self.welcomeTitleLabel.text = SmilesLanguageManager.shared.getLocalizedString(for: "WelcomeUser") + " " + (username ?? "")
    }
    
    private func setupNavigationBar() {
        
        title = SmilesLanguageManager.shared.getLocalizedString(for: "Manchester City Fan Club")
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .white
        appearance.titleTextAttributes = [.foregroundColor: UIColor.black, .font: SmilesFonts.circular.getFont(style: .bold, size: 16)]
        self.navigationItem.standardAppearance = appearance
        self.navigationItem.scrollEdgeAppearance = appearance
        let btnBack: UIButton = UIButton(type: .custom)
        btnBack.setImage(UIImage(named: AppCommonMethods.languageIsArabic() ? "back_arrow_ar" : "back_arrow", in: .module, compatibleWith: nil), for: .normal)
        btnBack.addTarget(self, action: #selector(self.onClickBack), for: .touchUpInside)
        btnBack.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        let barButton = UIBarButtonItem(customView: btnBack)
        self.navigationItem.leftBarButtonItem = barButton
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
    }
    
    @objc func onClickBack() {
        if let customPop{
            customPop()
        }else{
            self.navigationController?.popViewController()
        }
    }
    
    func playVideo() {
        thumbnailImageView.isHidden = true
        playButton.isHidden = true
        
        if let videoUrl = URL(string: self.videoUrl ?? "") {
            if videoUrl.absoluteString.contains("youtube.com") || videoUrl.absoluteString.contains("youtu.be") {
                // do something here
                let youtubeId = AppCommonMethods.extractYoutubeId(fromLink: videoUrl.absoluteString)
                youtubePlayerView.load(withVideoId: youtubeId, playerVars: ["origin": "http://www.youtube.com", "autoplay": 1, "playsinline": 1, "showinfo": 1, "rel" : 0])
                youtubePlayerView.delegate = self
            } else {
                let player = AVPlayer(url: videoUrl as URL)
                
                let playerLayer  = AVPlayerLayer(player: player)
                self.view.layer.addSublayer(playerLayer)
                playerLayer.frame = self.view.frame
                
                player.play()
            }
        }
    }
}

extension ManCityVideoPlayerViewController: YTPlayerViewDelegate {
    public func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        playerView.playVideo()
    }
}
