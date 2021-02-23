//
//  IconListVC.swift
//  Budget Manager
//
//  Created by CTIS Student on 23.02.2021.
//  Copyright © 2021 CTIS. All rights reserved.
//

import UIKit

struct Icon {
    var iconName: String
}

class IconListVC: UIViewController {
    
    var seledtedIcon = ""
    var selectedI = ""
    
    
    let icons = [
        Icon(iconName: "scissors"),
        Icon(iconName: "bandage"),
        Icon(iconName: "paintbrush")
    ]
    
    fileprivate let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(CustomCell.self, forCellWithReuseIdentifier: "iconCell")
        return cv
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
        collectionView.backgroundColor = .black
        collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 40).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40).isActive = true
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        // Do any additional setup after loading the view.
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

extension IconListVC: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/2.5, height: collectionView.frame.width/2)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return icons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "iconCell", for: indexPath) as! CustomCell
        cell.backgroundColor = .yellow
        cell.icon = self.icons[indexPath.row]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView,
    didSelectItemAt indexPath: IndexPath) {

        seledtedIcon = icons[indexPath.row].iconName
        selectedI = icons[indexPath.row].iconName
        self.performSegue(withIdentifier: "unwindFromIconListVCToAddCategoryVC", sender: self)
        self.performSegue(withIdentifier: "unwindFromIconListVCToEditCategoryVC", sender: self)

    }
    
    
}

class CustomCell: UICollectionViewCell {
    
    var icon: Icon? {
        didSet{
            guard let icon = icon else { return}
            bg.image = UIImage(systemName: icon.iconName)
        }
        
    }
    
    fileprivate let bg: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "scissors")
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
        
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(bg)
        bg.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        bg.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        bg.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        bg.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
