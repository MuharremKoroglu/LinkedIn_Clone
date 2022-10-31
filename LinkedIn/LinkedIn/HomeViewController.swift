//
//  HomeViewController.swift
//  LinkedIn
//
//  Created by Muharrem Köroğlu on 26.10.2022.
//

import UIKit
import Firebase

class HomeViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var homeTableView: UITableView!
    
    var postedByArray = [String]()
    var postMediaArray = [String]()
    var userProfilePictureArray = [String]()
    var postCommentArray = [String]()
    var postClapsArray = [Int]()
    var postDocumentIDArray = [String]()


    override func viewDidLoad() {
        super.viewDidLoad()

        homeTableView.delegate = self
        homeTableView.dataSource = self
        
        getDataFromFirestore()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postedByArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = homeTableView.dequeueReusableCell(withIdentifier: "CustomCell",for: indexPath) as! HomeTableViewCell
        cell.userProfilePicture.sd_setImage(with: URL(string: self.userProfilePictureArray[indexPath.row]),placeholderImage: UIImage(named: "anon-user"))
        cell.userName.text = self.postedByArray[indexPath.row]
        cell.postComment.text = self.postCommentArray[indexPath.row]
        cell.postImage.sd_setImage(with: URL(string: self.postMediaArray[indexPath.row]),placeholderImage: UIImage(named: "select-image"))
        cell.clapCount.text = String(self.postClapsArray[indexPath.row])
        cell.documentIDLabel.text = self.postDocumentIDArray[indexPath.row]
        return cell
        
    }
    
    func getDataFromFirestore () {
        
        let firestore = Firestore.firestore()
        
        firestore.collection("Posts").order(by: "post_date", descending: true).addSnapshotListener { snapshot, error in
            
            if error != nil {
                self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Something went wrong")
            }else{
                if snapshot != nil && snapshot?.isEmpty != true {
                    
                    self.postedByArray.removeAll()
                    self.postMediaArray.removeAll()
                    self.postClapsArray.removeAll()
                    self.postCommentArray.removeAll()
                    self.postDocumentIDArray.removeAll()
                    self.userProfilePictureArray.removeAll()
                    
                    for documents in snapshot!.documents {
                        let documentID = documents.documentID
                        self.postDocumentIDArray.append(documentID)
                        
                        if let postedBy = documents.get("posted_by") as? String {
                            self.postedByArray.append(postedBy)
                        }
                        if let profilePicture = documents.get("user_profile_picture") as? String {
                            self.userProfilePictureArray.append(profilePicture)
                        }
                        if let media = documents.get("post_media") as? String {
                            self.postMediaArray.append(media)
                        }
                        if let comment = documents.get("post_comment") as? String {
                            self.postCommentArray.append(comment)
                        }
                        if let claps = documents.get("post_claps") as? Int {
                            self.postClapsArray.append(claps)
                        }
                    }
                    self.homeTableView.reloadData()
                }
                
                
            }
            
            
        }
        
        
    }
 
    
    func makeAlert(title:String, message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let button = UIAlertAction(title: "Okay", style: UIAlertAction.Style.cancel)
        alert.addAction(button)
        present(alert, animated: true)
    }
    



}
