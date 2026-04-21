//
//  CoachmarkViewController.swift
//  rghinnaa-experimental
//
//  Created by Rizka Ghinna Auliya on 06/03/26.
//

import UIKit

class CoachmarkViewController: UIViewController {
    
    @IBOutlet weak var vCard1: UIView!
    @IBOutlet weak var vCard2: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.async {
            self.showCoachmark()
        }
        
    }
    
    func showCoachmark() {
        let coachmark = EDTSCoachmark(frame: .zero)

        coachmark.stepConjunction = "dari"
        
        coachmark.configureSteps(steps: [
            CoachmarkStepConfig(
                title: "Step 1",
                description: "This step shows both start and end targets with dual spotlights",
                targetView: vCard1
            ),
            
            CoachmarkStepConfig(
                title: "Step 2",
                description: "This step shows both start and end targets with dual spotlights",
                targetView: vCard2,
                isHideSpotlight: true
            )
        ])

        coachmark.show()
    }
}
