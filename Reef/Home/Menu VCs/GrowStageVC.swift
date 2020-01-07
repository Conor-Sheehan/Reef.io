//
//  GrowStageVC.swift
//  Reef
//
//  Created by Conor Sheehan on 10/21/19.
//  Copyright © 2019 Infinitry. All rights reserved.
//

import UIKit
import SafariServices

class GrowStageVC: UIViewController, SFSafariViewControllerDelegate {

    // UI ELEMENTS
    @IBOutlet weak var growStageName: UILabel!
    @IBOutlet weak var stageDescription: UITextView!
    @IBOutlet weak var growStageImage: UIImageView!
    
    var growStage = 0
    let growStageImages: [UIImage] = [#imageLiteral(resourceName: "GrowStageVC Seedling Image"),#imageLiteral(resourceName: "Vegetative Image"),#imageLiteral(resourceName: "Flowering Image")]
    let growStageNames = ["Seedling", "Vegetative", "Flowering"]
    let growStageDescriptions =
        ["During the seedling stage, your new sprout will start to develop it’s first leaves with only one blade. It will enter vegetative stage once it grows leaves with 5-7 blades.\n\n Healthy seedlings look green and vibrant. With Reef, the only time you need to water your plant is during seedling stage. Water lightly, daily as your sprouts' roots are sensitive at this size.",
        "Vegetative is when your plant will start growing rapidly. It’s roots will start to expand dramatically in Reef’s DWC basin. Your plant will start to drink a lot more water and nutrients from the ecosystem.\n\n During this time, you should start topping your plant to take advantage of the full grow space capacity. Learn how and when to top your plant below.",
        "Flowering is the time that you get to see your harvest blooming from the seeds that you planted. Reef will switch the ecosystem to 12 hours of daylight to induce flowering. Your plant will be consuming the most water and nutrients during this stage, so make sure to refill the tank often.\n\n During this time, you should not keep topping your plant as it can disrupt its natural cycles. Read the guide below to determine the right time to harvest."]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load the app delegate to access brain and bluetooth protocol
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            growStage = appDelegate.appBrain.growStage
        }
        
        growStageName.text = growStageNames[growStage]
        stageDescription.text = growStageDescriptions[growStage]
        growStageImage.image = growStageImages[growStage]

    }
    
    override func viewWillAppear(_ animated: Bool) {
         self.navigationController?.isNavigationBarHidden = false
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    
    
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
           controller.dismiss(animated: true, completion: nil)
       }
    
    @IBAction func learnMoreTapped(_ sender: Any) {
        let safariVC = SFSafariViewController(url: NSURL(string: "https://www.leafly.com/news/growing/marijuana-plant-growth-stages")! as URL)
        self.present(safariVC, animated: true, completion: nil)
        safariVC.delegate = self
    }
    

}
