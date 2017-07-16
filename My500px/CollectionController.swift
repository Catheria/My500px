//
//  CollectionController.swift
//  My500px
//
//  Created by MailE on 7/16/17.
//  Copyright © 2017 MailE. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import CLCollection

class CollectionController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var category: Category500px!
    var listPreview = [Photo500px]()
    let cacheQueue: DispatchQueue = DispatchQueue(label: "500px.queue", qos: .background, attributes: .concurrent, autoreleaseFrequency: .inherit, target: nil)
    
    lazy var flowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: 130, height: 120)
        let _w: CGFloat = (self.view.bounds.width - (130 * 2))/3
        layout.sectionInset = UIEdgeInsets(top: 0, left: _w, bottom: 0, right: _w)
        layout.footerReferenceSize = CGSize(width: self.view.bounds.width, height: 80)
        return layout
    }()
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: self.flowLayout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CollectionCell.self, forCellWithReuseIdentifier: CollectionCell.identify)
        collectionView.contentInset = UIEdgeInsets(top: 64 + 20, left: 0, bottom: 20, right: 0)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = UIColor.clear
        collectionView.register(CLReuseView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: CLReuseView.identify)
        return collectionView
    }()
    
    var page: Int = 1
    var collection: CLCollection!
    var titleLabel: UILabel!
    var descriptionLabel: UILabel!
    private var arrAllStartingDownload = [Photo500px]()
    
    lazy var refresher: UIRefreshControl = {
        let refresher = UIRefreshControl()
        refresher.tintColor = UIColor.red
        refresher.addTarget(self, action: #selector(CollectionController.reloadData), for: .valueChanged)
        return refresher
    }()
    
    lazy var indicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        indicator.center = self.view.center
        indicator.startAnimating()
        return indicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        automaticallyAdjustsScrollViewInsets = false
        title = category.name
        view.backgroundColor = UIColor.white
        view.addSubview(indicator)
        requestAPI {
            self.updateCollectionView()
        }
    }
    
    func reloadData() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.arrAllStartingDownload.removeAll()
            self.listPreview.removeAll()
            self.page = 1
            self.collectionView.reloadData()
            self.requestAPI {
                self.updateCollectionView()
            }
            self.refresher.endRefreshing()
        }
    }
    
    func startLoadingImage(track: Photo500px, cell: CollectionCell) {
        if !arrAllStartingDownload.contains(track) {
            cacheQueue.async { [weak self] in
                if let url = URL(string: track.previewURL) {
                    do {
                        self?.arrAllStartingDownload.append(track)
                        let data = try Data(contentsOf: url)
                        let image = UIImage(data: data)
                        track.thumbnail = image
                        DispatchQueue.main.async {
                            let transition = CATransition()
                            transition.duration = 0.25
                            transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
                            transition.type = kCATransitionFade
                            cell.imageView.layer.add(transition, forKey: "image")
                            cell.imageView.image = image
                        }
                    } catch {}
                }
            }
        }
    }
    
    func requestAPI(_ closure: @escaping () -> Void) {
        Session.requestCategory(category.name, page: String(page)) { (arrPhotos: [Photo500px]) in
            self.listPreview += arrPhotos
            closure()
        }
    }
    func updateCollectionView() {
        DispatchQueue.main.async {
            self.indicator.stopAnimating()
            if self.view.subviews.contains(self.collectionView) {
                self.collectionView.reloadData()
            }else {
                self.view.addSubview(self.collectionView)
                self.collectionView.addSubview(self.refresher)
            }
            print("Finish Request")
            self.page += 1
        }
    }
    
    func addTextAt(index: Int) {
        let b = listPreview[index]
        titleLabel.text = b.title
        let nameAuthor = b.author ?? ""
        descriptionLabel.text = "Author: " + nameAuthor
    }
    
    // MARK: - CollectionView DataSource & Delegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listPreview.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let b = listPreview[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionCell.identify, for: indexPath) as! CollectionCell
        cell.titleLabel.text = b.title
        cell.descriptionLabel.text = b.author
        cell.imageView.af_setImage(withURL: URL(string: b.previewURL)!, placeholderImage: nil, filter: nil, progress: nil, progressQueue: cacheQueue, imageTransition: UIImageView.ImageTransition.crossDissolve(1.0), runImageTransitionIfCached: false) { (response: DataResponse<UIImage>) in
            if let image = response.result.value {
                b.thumbnail = image
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? CollectionCell,
            let _ = listPreview[indexPath.row].thumbnail {
            let screen = UIScreen.main.bounds
            let closeView = CloseView(frame: CGRect(x: 10, y: 10, width: 30, height: 30))
            closeView.isOpaque = false
            closeView.delegate = self
            titleLabel = UILabel(frame: CGRect(x: 10, y: screen.height - 60, width: screen.width - 10 * 2, height: 20))
            titleLabel.textColor = UIColor.white
            titleLabel.font = UIFont.systemFont(ofSize: 16)
            descriptionLabel = UILabel(frame: CGRect(x: 10, y: screen.height - 34, width: screen.width - 10 * 2, height: 20))
            descriptionLabel.textColor = UIColor.white
            descriptionLabel.font = UIFont.systemFont(ofSize: 14)
            
            collection = CLCollection()
            collection.senderView = cell.imageView
            collection.dataSource = self
            collection.delegate = self
            collection.initialIndex = indexPath.row
            collection.decoratorView = [closeView, titleLabel, descriptionLabel]
            addTextAt(index: indexPath.row)
            
            let blackView = UIView()
            blackView.backgroundColor = UIColor.black
            collection.dimmingView = blackView
            collection.present()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CLReuseView.identify, for: indexPath) as! CLReuseView
        if kind == UICollectionElementKindSectionFooter {
            view.delegate = self
            view.loadMoreButton.setTitle("Load More !!", for: .normal)
        }
        return view
    }
}

extension CollectionController: CLReuseViewDelegate {
    func didTap(view: CLReuseView) {
        view.isUserInteractionEnabled = false
        requestAPI {
            self.updateCollectionView()
            view.isUserInteractionEnabled = true
        }
    }
}

extension CollectionController: CloseViewDelegate {
    func closeViewDidTap(view: CloseView) {
        collection.dismiss()
    }
}



extension CollectionController: CLCollectionDataSource {
    func numberOfViewForCollection(collection: CLCollection) -> Int {
        return listPreview.count
    }
    func collection(collection: CLCollection, imgDefaultAtIndex index: Int) -> UIImage? {
        return listPreview[index].thumbnail
    }
    func collection(collection: CLCollection, urlPathAt index: Int) -> String {
        return listPreview[index].imageURL
    }
}

extension CollectionController: CLCollectionDelegate {
    func collectionScrollViewDidEndDecelerating(collection: CLCollection, index: Int) {
        let indexPath = IndexPath(row: index, section: 0)
        collectionView.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition.centeredVertically, animated: false)
        performSelector(onMainThread: #selector(CollectionController.changeSenderView(indexPath:)), with: indexPath, waitUntilDone: true)
    }
    
    @objc func changeSenderView(indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? CollectionCell {
            collection.senderView = cell.imageView
            addTextAt(index: indexPath.row)
        }
    }
}
