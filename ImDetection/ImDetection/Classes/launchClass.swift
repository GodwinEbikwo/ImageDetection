//
//  launchClass.swift
//  FinalProject
//
//  Created by Godwin Adejo Ebikwo on 07/10/2018.
//  Copyright © 2018 Godwin Adejo Ebikwo. All rights reserved.
//

import Foundation
import SceneKit

class launchClass: UIViewController
{
    @IBOutlet var spinner: UIActivityIndicatorView!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let time = 3.0
        spinner.startAnimating()
        DispatchQueue.main.asyncAfter(deadline: .now() + time)
        {
            self.performSegue(withIdentifier: "show", sender:self)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) { super.viewWillAppear(animated) }
    override func viewWillDisappear(_ animated: Bool) { super.viewWillDisappear(animated) }
}
