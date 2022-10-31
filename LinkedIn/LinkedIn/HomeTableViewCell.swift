//
//  HomeTableViewCell.swift
//  LinkedIn
//
//  Created by Muharrem Köroğlu on 29.10.2022.
//

import UIKit
import Firebase

class HomeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userProfilePicture: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var postComment: UILabel!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var clapCount: UILabel!
    @IBOutlet weak var documentIDLabel: UILabel!
    
    var countTracker = true
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
    
    @IBAction func clapButton(_ sender: Any) {
        
        let firestore = Firestore.firestore()
        
        if countTracker == true {
            
            if let clapTracker = Int(self.clapCount.text!) {
                
                let clapCount = ["post_claps" : clapTracker + 1] as [String : Any]
                firestore.collection("Posts").document(self.documentIDLabel.text!).setData(clapCount, merge: true)
                
            }
            countTracker = false
            
        }else if countTracker == false {
            if let clapTracker = Int(self.clapCount.text!) {
                
                if clapTracker == 0 {
                    self.clapCount.text = "0"
                    
                }else {
                    let clapCount = ["post_claps" : clapTracker - 1] as [String : Any]
                    firestore.collection("Posts").document(self.documentIDLabel.text!).setData(clapCount, merge: true)
                   
                }
 
            }
            countTracker = true
        }
        
    }
    
    
    

}
