//
//  DetailViewController.swift
//  MobileAxxess
//
//  Created by Nannapuraju, Dheeraj R on 9/26/20.
//  Copyright © 2020 Dheeraj. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    var data = HomeViewData()
    
    @IBOutlet weak var contentImageView: UIImageView!
    @IBOutlet weak var contentView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if(data.type == "image")
        {
            contentImageView.isHidden = false
            if (!data.imageDownloaded! && data.imageData == nil)
            {
                contentImageView?.image = UIImage.init(named: "imagenotfound")
            }
            else
            {
                contentImageView.image = UIImage.init(data: data.imageData!)
            }
        }
        else if(data.type == "text")
        {
            contentView.isHidden = false
            contentView.text = data.text
        }
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
