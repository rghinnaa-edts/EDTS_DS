//
//  ViewController.swift
//  EDTS_DS
//
//  Created by Rizka Ghinna Auliya on 08/04/26.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        // Do any additional setup after loading the view.
    }

    @IBAction func action(_ sender: Any) {
        let vc = UIStoryboard(name: "CoachmarkViewController", bundle: nil).instantiateViewController(withIdentifier: "CoachmarkPage")
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

