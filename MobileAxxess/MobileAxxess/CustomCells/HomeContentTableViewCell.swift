//
//  HomeContentTableViewCell.swift
//  MobileAxxess
//
//  Created by Nannapuraju, Dheeraj R on 9/26/20.
//  Copyright © 2020 Dheeraj. All rights reserved.
//

import UIKit

class HomeContentTableViewCell: UITableViewCell {

    @IBOutlet weak var listImage: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var imageWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageHightConstraint: NSLayoutConstraint!
    @IBOutlet weak var contentText: UITextView!
    @IBOutlet weak var textViewHeightConstraint: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureView(_ data : HomeViewData)
    {
        dateLabel.text = data.date
        imageHightConstraint.constant = 0
        imageWidthConstraint.constant = 0
        textViewHeightConstraint.constant = 0
        listImage.image = nil
        
        if(data.type == "image")
        {
            contentText.isHidden = true
            contentText.text = ""
            listImage.isHidden = false
            imageHightConstraint.constant = 100
            imageWidthConstraint.constant = 100
            if(data.imageDownloaded!)
            {
                listImage.image = UIImage.init(data: data.imageData!)
            }
            else if (!data.imageDownloaded! && data.imageData == nil)
            {
                listImage?.image = UIImage.init(named: "imagenotfound")
            }
        }
        else
        {
            contentText.isHidden = false
            listImage.isHidden = true
            contentText.text = data.text
            let newSize = heightForView(text: data.text ?? "", font: UIFont.systemFont(ofSize: 14), width: contentText.frame.size.width) + 10
            textViewHeightConstraint.constant = newSize > 100 ? 100 : newSize
        }
    }
    
    func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRect.init(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        label.sizeToFit()
        return label.frame.height
    }
}
