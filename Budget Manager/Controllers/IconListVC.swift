//
//  IconListVC.swift
//  Budget Manager
//
//  Created by CTIS Student on 23.02.2021.
//  Copyright © 2021 CTIS. All rights reserved.
//

import UIKit
import SFSafeSymbols

struct Icon {
    var iconName: String
}

class IconListVC: UIViewController {
    
    var seledtedIcon = ""
    var selectedI = ""
    
    var icons: [SFSymbol] = []
    
    fileprivate let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.collectionViewLayout = CustomImageLayout()
        cv.contentMode = .scaleAspectFit
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(CustomCell.self, forCellWithReuseIdentifier: "iconCell")
        return cv
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getAllSFSymbols()
        self.view.backgroundColor = .black
        view.addSubview(collectionView)
        collectionView.backgroundColor = .black
        collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40).isActive = true
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        
        
    }
    func getAllSFSymbols() {
        icons.append(contentsOf: SFSymbol.allCases)
    }
}

extension IconListVC: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource{
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
////        return CGSize(width: collectionView.frame.width, height: collectionView.frame.width)
//        let imgWidth = collectionView.frame.width/1.0
//          return CGSize(width: imgWidth, height: imgWidth)
//
//
//    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return icons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "iconCell", for: indexPath) as! CustomCell
        cell.backgroundColor = .black
        cell.icon = self.icons[indexPath.row]
        cell.bg.contentMode = .scaleAspectFill

        return cell
    }
    func collectionView(_ collectionView: UICollectionView,
    didSelectItemAt indexPath: IndexPath) {

        seledtedIcon = icons[indexPath.row].rawValue
        selectedI = icons[indexPath.row].rawValue
        self.performSegue(withIdentifier: "unwindFromIconListVCToAddCategoryVC", sender: self)
        self.performSegue(withIdentifier: "unwindFromIconListVCToEditCategoryVC", sender: self)

    }
    
    
}

class CustomCell: UICollectionViewCell {
    
    var icon: SFSymbol? {
        didSet{
            guard let icon = icon else { return}
            bg.image = UIImage(systemName: icon.rawValue)
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

class CustomImageLayout: UICollectionViewFlowLayout {

var numberOfColumns:CGFloat = 3.0

override init() {
    super.init()
    setupLayout()
}

required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setupLayout()
}

override var itemSize: CGSize {
    set { }
    get {
        let itemWidth = (self.collectionView!.frame.width - (self.numberOfColumns - 1)) / self.numberOfColumns
        return CGSize(width: itemWidth, height: itemWidth)
    }
}

func setupLayout() {
    minimumInteritemSpacing = 1 // Set to zero if you want
    minimumLineSpacing = 1
    scrollDirection = .vertical
}
}
