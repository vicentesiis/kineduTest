//
//  ViewController.swift
//  KineduTest
//
//  Created by Vicente Cantu Garcia on 5/24/19.
//  Copyright © 2019 Vicente Cantu Garcia. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    // MARK: - IBOulets
    @IBOutlet weak var versionSegmented: UISegmentedControl!
    
    @IBOutlet weak var freemiumNPSScore: UILabel!
    @IBOutlet weak var freemiumUsers: UILabel!
    
    @IBOutlet weak var premiumNPSScore: UILabel!
    @IBOutlet weak var premiumUsers: UILabel!
    
    var manager = Manager()
    var npsProcessed: [NPSProcessed]!
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.barStyle = .black
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.barTintColor = UIColor(named: "BlueBar")
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        showSpinner(onView: self.view)
        
        RestApi.getNPS(onResponse: { (response) in
            self.manager.proccesData(allData: response, valuesProcessed: { (npsProcessed) in
                self.npsProcessed = npsProcessed
                self.removeSpinner()
                self.addElementsToSegmented()
            })
            
        }, onError: {
            print("onError")
            self.removeSpinner()
        }, notConnection: {
            print("notConnection")
            self.removeSpinner()
        })
        
    }
    
    override func performSegue(withIdentifier identifier: String, sender: Any?) {
        let version = versionSegmented.titleForSegment(at: versionSegmented.selectedSegmentIndex)
        performSegue(withIdentifier: "DETAIL_NPS", sender: version)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let version = versionSegmented.titleForSegment(at: versionSegmented.selectedSegmentIndex)
        let nps = npsProcessed.filter({ $0.version == version }).first!
        if let detail = segue.destination as? DetailViewController {
            detail.version = version
            detail.nps = nps
        }
    }
    
    // MARK: - IBActions
    
    @IBAction func changeVersion(_ sender: UISegmentedControl) {
        let version = versionSegmented.titleForSegment(at: sender.selectedSegmentIndex)
        
        assingValues(version: version!)
    }
    
    // MARK: - Function Helpers
    
    func addElementsToSegmented() {
        
        npsProcessed.sort { return $0.version > $1.version }

        versionSegmented.removeAllSegments()

        for i in 0 ..< npsProcessed.count {
            versionSegmented.insertSegment(withTitle: npsProcessed[i].version, at: i, animated: true)
        }
        versionSegmented.selectedSegmentIndex = 0

        assingValues(version: npsProcessed[0].version)
        
    }
    
    func assingValues(version: String) {
        
        let nps = npsProcessed.filter({ $0.version == version }).first!
        
        let premium = nps.getNPSScore(.premium)
        premiumNPSScore.text = String(premium.0)
        premiumUsers.text = "Out of \(String(premium.1)) users"
        
        premium.1 < 70 ? (premiumNPSScore.textColor = UIColor(named: "Green")) : (premiumNPSScore.textColor = UIColor(named: "Red"))
        
        let freemium = nps.getNPSScore(.freemium)
        freemiumNPSScore.text = String(freemium.0)
        freemiumUsers.text = "Out of \(String(freemium.1)) users"
        
        freemium.1 < 70 ? (freemiumNPSScore.textColor = UIColor(named: "Green")) : (freemiumNPSScore.textColor = UIColor(named: "Red"))
        
    }

}
