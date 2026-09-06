//
//  ShareViewController.swift
//  YumBox
//
//  Created by Zin Mie Mie Thet on 25/09/2024.
//

import UIKit

var Share : [SavedRecipe] = []
class ShareViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet var collection: UICollectionView!
    var isDeleteMode: Bool = false
    var selectedItems: Set<Int> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadItems()
        collection.delegate = self
        collection.dataSource = self
        let rightBarButton = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = rightBarButton
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        collection.addGestureRecognizer(longPressRecognizer)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        collection.reloadData()
        saveItems()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        Share.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let index = indexPath.item
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "itemcell", for: indexPath) as! CollectionViewCell
        cell.label.text = Share[index].name
        cell.img.image = Share[index].image
        if isDeleteMode {
            cell.contentView.layer.borderColor = selectedItems.contains(indexPath.item) ? UIColor.red.cgColor : UIColor.black.cgColor
            cell.contentView.layer.borderWidth = selectedItems.contains(indexPath.item) ? 2 : 1
        } else {
            cell.contentView.layer.borderWidth = 0
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if isDeleteMode {
            if selectedItems.contains(indexPath.item) {
                selectedItems.remove(indexPath.item)
            } else {
                selectedItems.insert(indexPath.item)
            }
            collectionView.reloadItems(at: [indexPath])
        }
    }
    
    @objc func addButtonTapped() {
        let addImage = storyboard?.instantiateViewController(identifier: "addimage") as! AddViewController
        navigationController?.pushViewController(addImage, animated: true)
    }
    
    @objc func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            isDeleteMode = true
            selectedItems.removeAll()
            collection.reloadData()
            
            let deleteButton = UIBarButtonItem(title: "Delete", style: .plain, target: self, action: #selector(deleteSelectedItems))
            navigationItem.leftBarButtonItem = deleteButton
            navigationItem.leftBarButtonItem?.tintColor = .red
        }
    }
    
    @objc func deleteSelectedItems() {
        let itemsToDelete = selectedItems.sorted(by: >)
        for index in itemsToDelete {
            Share.remove(at: index)
        }
        saveItems()
        selectedItems.removeAll()
        isDeleteMode = false
        collection.reloadData()
        navigationItem.leftBarButtonItem = nil
    }
    
    func saveItems() {
        DispatchQueue.global(qos: .background).async {
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(Share) {
                UserDefaults.standard.set(encoded, forKey: "items")
                UserDefaults.standard.synchronize()
            }
        }
    }
    
    func loadItems() {
        DispatchQueue.global(qos: .background).async { [weak self] in
            if let savedData = UserDefaults.standard.data(forKey: "items") {
                let decoder = JSONDecoder()
                if let loadedItems = try? decoder.decode([SavedRecipe].self, from: savedData) {
                    DispatchQueue.main.async {
                        Share = loadedItems
                        self?.collection.reloadData()
                        print("loaded")
                    }
                }
            }
        }
    }
}
 
