//
//  FeedViewController.swift
//  InstaCloneFirebase
//
//  Created by Farih Muhammad on 22/09/2024.
//

import UIKit
import Firebase
import SDWebImage

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var userEmailArray = [String]()
    var userCommentArray = [String]()
    var likesArray = [Int]()
    var userImageArray = [String]()
    var documentIdArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
        getDataFromFirestore()
    }
    
    func getDataFromFirestore(){
        
        let fireStoreDatabase = Firestore.firestore()
        
        fireStoreDatabase.collection("Posts").order(by: "date_posted", descending: true).addSnapshotListener { snapshot, error in
            if let errorMessage = error {
                print(errorMessage.localizedDescription)
            } else {
                if let safeSnapshot = snapshot {
                    
                    self.userEmailArray.removeAll()
                    self.userImageArray.removeAll()
                    self.userCommentArray.removeAll()
                    self.likesArray.removeAll()
                    self.documentIdArray.removeAll()
                    
                    for document in safeSnapshot.documents{
                        self.documentIdArray.append(document.documentID)
                        
                        if let userComment = document.get("post_comment") as? String {
                            if let userEmail = document.get("posted_by") as? String {
                                if let likeCount = document.get("likes") as? Int {
                                    if let userImage = document.get("image_url") as? String {
                                        self.userEmailArray.append(userEmail)
                                        self.userImageArray.append(userImage)
                                        self.userCommentArray.append(userComment)
                                        self.likesArray.append(likeCount)
                                    }
                                }
                            }
                        }
                    }
                    
                    self.tableView.reloadData()
                }
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userEmailArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FeedCell
        cell.userEmailLabel.text = userEmailArray[indexPath.row]
        cell.likeLabel.text = String(likesArray[indexPath.row])
        cell.commentLabel.text = userCommentArray[indexPath.row]
        cell.documentID = documentIdArray[indexPath.row]
        cell.userImageView.sd_setImage(with: URL(string: self.userImageArray[indexPath.row]))
        return cell
    }
    
    
}
