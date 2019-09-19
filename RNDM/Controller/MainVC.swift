//
//  ViewController.swift
//  RNDM
//
//  Created by Ramit sharma on 20/03/19.
//  Copyright © 2019 Ramit sharma. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore


enum ThoughtCategory : String {
    case serious = "serious"
    case funny = "funny"
    case crazy = "crazy"
    case popular = "popular"
}


class MainVC: UIViewController, UITableViewDataSource, UITableViewDelegate, ThoughtDelegate {
  
    //outlets
    
    @IBOutlet private var segmentControl: UISegmentedControl!
    @IBOutlet private var tableview: UITableView!
    
    private var thoughts = [Thought]()
    private var thoughtCollectionRef: CollectionReference!
    private var thoughtsListener: ListenerRegistration!
    private var selectedCategory = ThoughtCategory.funny.rawValue
    private var handle: AuthStateDidChangeListenerHandle?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.delegate = self
        tableview.dataSource = self
        //Dynamic Table cell size
        tableview.estimatedRowHeight = 80
        tableview.rowHeight = UITableView.automaticDimension
        thoughtCollectionRef = Firestore.firestore().collection(THOUGHTS_REF)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        handle = Auth.auth().addStateDidChangeListener({ (auth, user) in
            if user == nil {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let loginVC = storyboard.instantiateViewController(withIdentifier: "loginVC")
                self.present(loginVC, animated: true, completion: nil)
            } else {
                self.setListener()
            }
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if thoughtsListener != nil {
            thoughtsListener.remove()
            
        }
    }
    
    func thoughtOptionsTapped(thought: Thought) {
        let alert = UIAlertController(title: "Delete", message: "Do you want to delete your thought?", preferredStyle: .actionSheet)
        let deleteAction = UIAlertAction(title: "Delete Thought", style: .default) { (action) in
           
            self.delete(collection: Firestore.firestore().collection(THOUGHTS_REF).document(thought.documentId).collection(COMMENTS_REF), completion: { (error) in
                if let error = error {
                    debugPrint("Could not delete subclollection: \(error.localizedDescription)")
                }else {
                    Firestore.firestore().collection(THOUGHTS_REF).document(thought.documentId).delete(completion: { (error) in
                        if let error = error {
                            debugPrint("Could not delete thought: \(error.localizedDescription)")
                        } else {
                            alert.dismiss(animated: true, completion: nil)
                        }
                    })
                }
            })
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }

    
    func delete(collection: CollectionReference, batchSize: Int = 100, completion: @escaping (Error?) -> ()) {
        
        //Limit query to avoid out-of-memory errors on large collections.
        //When deleting a collection guaranteed to fit in memory, batching can be avoided entirely.
        collection.limit(to: batchSize).getDocuments { (docset, error) in
            // An error occured.
            guard let docset = docset else {
                completion(error)
                return
                
            }
            //There's nothing to delete.
            guard docset.count > 1 else {
                completion(nil)
                return
                
            }
            
            let batch = collection.firestore.batch()
            docset.documents.forEach { batch.deleteDocument($0.reference) }
            batch.commit { (batchError) in
                
                if let batchError = batchError {
                    
                    // Stop the deletion process and handle the error. Some elements
                    
                    // may have been deleted.
                    
                    completion(batchError)
                    
                } else {
                    
                    self.delete(collection: collection, batchSize: batchSize, completion: completion)
                    
                }
                
            }
            
        }
        
    }
    
    
    
    @IBAction func categoryChanged(_ sender: Any) {
        switch segmentControl.selectedSegmentIndex {
        case 0:
            selectedCategory = ThoughtCategory.funny.rawValue
        case 1:
            selectedCategory = ThoughtCategory.serious.rawValue
        case 2:
            selectedCategory = ThoughtCategory.crazy.rawValue
        default:
            selectedCategory = ThoughtCategory.popular.rawValue
            
        }
        thoughtsListener.remove()
        setListener()
    }
    
    //Filtering comments WRT categories
    func setListener() {
        
        if selectedCategory == ThoughtCategory.popular.rawValue {
        thoughtsListener = thoughtCollectionRef.whereField(CATEGORY, isEqualTo: selectedCategory).order(by: TIMESTAMP, descending: true).addSnapshotListener { (snapshot, error) in
            if let err = error {
                debugPrint("Error fetching docs: \(err)")
            } else {
                self.thoughts.removeAll()
                self.thoughts = Thought.parseData(snapshot: snapshot)
                self.tableview.reloadData()
            }
        }
        } else {
            thoughtsListener = thoughtCollectionRef.whereField(CATEGORY, isEqualTo: selectedCategory).order(by: TIMESTAMP, descending: true).addSnapshotListener { (snapshot, error) in
                if let err = error {
                    debugPrint("Error fetching docs: \(err)")
                } else {
                    self.thoughts.removeAll()
                    self.thoughts = Thought.parseData(snapshot: snapshot)
                    self.tableview.reloadData()
                }
            }
            
        }
            
    }

    @IBAction func Logout(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        }
        catch let signOutError as NSError {
            debugPrint("Error signing out! : \(signOutError)")
        }
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return thoughts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier:"ThoughtCell", for: indexPath) as? ThoughtCell {
            cell.configureCell(thought: thoughts[indexPath.row], delegate: self)
            return cell
            
        } else {
            return UITableViewCell()
        }
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toComments", sender: thoughts[indexPath.row])
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toComments" {
            if let destinationVC = segue.destination as? CommentsVC {
                if let thought = sender as? Thought {
                    destinationVC.thought = thought
                }
            }
        }

    }
    
}

