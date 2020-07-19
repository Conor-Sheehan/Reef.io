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
    let growStageImages: [UIImage] = [#imageLiteral(resourceName: "GrowStageVC Seedling Image"), #imageLiteral(resourceName: "Vegetative Image"), #imageLiteral(resourceName: "Flowering Image")]
    let growStageNames = ["Seedling", "Vegetative", "Flowering"]
    let growStageDescriptions =
        ["",
        "",
        "."]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Load the app delegate to access brain and bluetooth protocol

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
        let safariVC = SFSafariViewController(url:
          NSURL(string: "https://www.leafly.com/news/growing/marijuana-plant-growth-stages")! as URL)
        self.present(safariVC, animated: true, completion: nil)
        safariVC.delegate = self
    }

}
