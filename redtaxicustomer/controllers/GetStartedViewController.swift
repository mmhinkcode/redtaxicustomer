//
//  GetStartedViewController.swift
//  redtaxicustomer
//
//  Created by Hak Holding on 7/28/20.
//  Copyright © 2020 Hak Holding. All rights reserved.
//

import UIKit
//import FSPagerView

class GetStartedViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate {

    @IBOutlet weak var getStartedButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet var pageControl: UIPageControl!

    var collectionViewFlowLayout = UICollectionViewFlowLayout()

    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.getStartedButton.layer.masksToBounds = true
        self.getStartedButton.layer.cornerRadius = 22
        
        collectionViewFlowLayout.minimumLineSpacing = 0.0//-1.0
        collectionViewFlowLayout.minimumInteritemSpacing = 0.0
        collectionViewFlowLayout.scrollDirection = .horizontal
        self.collectionViewFlowLayout.itemSize = CGSize(width: self.collectionView.frame.size.width, height: self.collectionView.frame.size.height)
        self.collectionView.collectionViewLayout = self.collectionViewFlowLayout
    }
    
    // MARK:- UICollectionView DataSource
    func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int
    {
      return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PageViewCell", for: indexPath) as! PageViewCell
        
        switch indexPath.row
        {
        case 0:
            do
            {
                cell.imageView.image = UIImage(named: "red-reg")
                cell.textLabel.text = "RAPID CITY TOUR"
                cell.detailTextLabel.text = "We will give you a comfortable city tour and show you all around"
            }
            break
        case 1:
            do
            {
                cell.imageView.image = UIImage(named: "kisspng-minivan-hyundai-starex-car-hyundai-motor-company-hyundai-h1-5b335e9e761326.1500895215300932144836")
                cell.textLabel.text = "AIRPORT TRANSFER"
                cell.detailTextLabel.text = "Wherever you live in the country, Red Taxi will transport you to and from airport"
            }
            break
        case 2:
            do
            {
                cell.imageView.image = UIImage(named: "Luggagebags-suitcase-free-PNG-transparent-background-images-free-download-clipart-pics-Luggage-PNG-File")
                cell.textLabel.text = "BAGGAGE TRANSPORT"
                cell.detailTextLabel.text = "Whether it's one bag or ten bags, our agents can arrange multiple cars to"
            }
            break
        default:
            do
            {
                
            }
        }

      return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        let pageWidth = scrollView.frame.width
        let currentPage = Int((scrollView.contentOffset.x + pageWidth / 2) / pageWidth)
        self.pageControl.currentPage = currentPage
    }
    
    @IBAction func getStartedAction(_ sender: Any)
    {
        UserDefaults.standard.set(true, forKey: "get_started")
        self.performSegue(withIdentifier: "phoneNumber", sender: nil)
    }
}
