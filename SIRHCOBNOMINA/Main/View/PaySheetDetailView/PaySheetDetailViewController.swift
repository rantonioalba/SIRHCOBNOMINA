//
//  PaySheetDetailViewController.swift
//  SIRHCOBNOMINA
//
//  Created by Roberto Alba on 24/02/21.
//

//import UIKit

import Foundation
import UIKit

extension UIView {
    func screenshotForCroppingRect(croppingRect:CGRect) -> UIImage? {

        UIGraphicsBeginImageContextWithOptions(croppingRect.size, false, UIScreen.main.scale);

        let context = UIGraphicsGetCurrentContext()
        if context == nil {
            return nil;
        }

        context!.translateBy(x: -croppingRect.origin.x, y: -croppingRect.origin.y)
        self.layoutIfNeeded()
        self.layer.render(in: context!)

        let screenshotImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return screenshotImage
    }

    @objc  var screenshot : UIImage? {
        return self.screenshotForCroppingRect(croppingRect: self.bounds)
    }
}

extension UIScrollView {
    
    var screenshotOfVisibleContent : UIImage? {
        var croppingRect = self.bounds
        croppingRect.origin = self.contentOffset
        return self.screenshotForCroppingRect(croppingRect: croppingRect)
    }
    
}

extension UIImage {
    
    class func imageWithColor(color:UIColor, size:CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        let context = UIGraphicsGetCurrentContext()
        if context == nil {
            return nil
        }
        color.set()
        context?.fill(CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

extension UIImage {
    
    class func verticalAppendedTotalImageSizeFromImagesArray(imagesArray:[UIImage]) -> CGSize {
        var totalSize = CGSize.zero
        for im in imagesArray {
            let imSize = im.size
            totalSize.height += imSize.height
            totalSize.width = max(totalSize.width, imSize.width)
        }
        return totalSize
    }
    
    
    class func verticalImageFromArray(imagesArray:[UIImage]) -> UIImage? {
        
        var unifiedImage:UIImage?
        let totalImageSize = self.verticalAppendedTotalImageSizeFromImagesArray(imagesArray: imagesArray)
        
        UIGraphicsBeginImageContextWithOptions(totalImageSize,false, 0)
        
        var imageOffsetFactor:CGFloat = 0
        
        for img in imagesArray {
            img.draw(at: CGPoint(x: 0, y: imageOffsetFactor))
            imageOffsetFactor += img.size.height;
        }
        unifiedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return unifiedImage
    }
}



class PaySheetDetailViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: PaySheetDetailViewModel!
    
    @IBOutlet weak var elipsedCenterXConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var imageViewEmployee: CustomImageView!
    
    @IBOutlet weak var labelStatus: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.register(UINib(nibName: "PaySheetDetailViewCell", bundle: nil), forCellReuseIdentifier: "cellId")
        
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 10.0, bottom: 0, right: 10.0)
        
        
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 55/255.0, green: 180/255.0, blue: 89/255.0, alpha: 1.0)
        
        self.navigationController?.navigationBar.isOpaque = true
        
        self.navigationController?.navigationBar.tintColor  = UIColor.white
        
        self.navigationController?.navigationItem.hidesBackButton = false
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "back"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(tapButtonBack(_:)))
        
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "share-rounded-white"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(tapButtonShare(_:)))
        
//        self.navigationItem.title = viewModel.title
        
        
        let labelTittleView = UILabel()
        
        labelTittleView.text = viewModel.title
        
        labelTittleView.textColor = UIColor.white
        
        labelTittleView.adjustsFontSizeToFitWidth = true
        
        self.navigationItem.titleView = labelTittleView
        
        if viewModel.isEmployeeDischargd() {
            self.elipsedCenterXConstraint.constant = -65.0
            
            self.labelStatus.text = viewModel.descriptionEmployeeDischarged()
            
        } else {
            self.labelStatus.isHidden = true
        }
        
        
        let urlString = viewModel.urlEmployeeJPG()
        
        
        if UIApplication.shared.canOpenURL(URL(string: urlString + ".jpg")!) {
            self.imageViewEmployee.loadImageUsingUrlString(urlString: urlString + ".jpg", frame: CGRect.zero)

            if self.imageViewEmployee.image == nil {
                self.imageViewEmployee.loadImageUsingUrlString(urlString: urlString + ".JPG", frame: CGRect.zero)
                
                if self.imageViewEmployee.image == nil {
                    if UIApplication.shared.canOpenURL(URL(string: urlString + ".jpeg")!) {
                        self.imageViewEmployee.loadImageUsingUrlString(urlString: urlString + ".jpeg", frame: CGRect.zero)
                    
                        if self.imageViewEmployee.image == nil {
                            self.imageViewEmployee.loadImageUsingUrlString(urlString: urlString + ".JPEG", frame: CGRect.zero)
                            
                            if self.imageViewEmployee.image == nil {
                                
                                if UIApplication.shared.canOpenURL(URL(string: urlString + ".png")!) {
                                    self.imageViewEmployee.loadImageUsingUrlString(urlString: urlString + ".png", frame: CGRect.zero)
                                
                                    if self.imageViewEmployee.image == nil {
                                        self.imageViewEmployee.loadImageUsingUrlString(urlString: urlString + ".PNG", frame: CGRect.zero)
                                        
                                        if self.imageViewEmployee.image == nil {
                                            self.imageViewEmployee.image = UIImage(named: "user")
                                        }
                                    }
                                }
                            }
                        }
                    }
                }

            }
        }
        
    }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        viewModel.viewDidDissapear()
    }
    
    @objc func tapButtonBack(_ sender:UIBarButtonItem)  {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    
    @objc func tapButtonShare(_ sender:UIBarButtonItem)  {
        
        let image1 = self.navigationController?.navigationBar.screenshot
        
        let image2 = self.tableView.screenshot
        
        
        
        let contextHeight:CGFloat = tableView.contentSize.height + (image1?.size.height)!;
        let contextFrame:CGRect = CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: contextHeight)

        UIGraphicsBeginImageContextWithOptions(contextFrame.size, false, 0.0)
        let context:CGContext = UIGraphicsGetCurrentContext()!
        UIGraphicsPushContext(context)


        //1 draw navigation image in context
        image1!.draw(in: self.navigationController!.navigationBar.frame)
        
        image1?.draw(in: CGRect(x: 0, y: 0, width: self.view.frame.width, height: (image1?.size.height)!))


        //2 draw tableview image in context
        let y:CGFloat = (image1?.size.height)!
        let h:CGFloat = tableView.contentSize.height;
        let w:CGFloat = tableView.frame.size.width;
        
        image2!.draw(in:   CGRect(x:0, y:y, width:w, height:h))



        // Clean up and get the new image.
        UIGraphicsPopContext();
        let mergeImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext();
        
        

//        let items = [self.imageView.image!]
        let items = [mergeImage]
        let activityController = UIActivityViewController(activityItems: items, applicationActivities: nil)

        self.present(activityController, animated: true, completion: nil)
        
    }

}

extension PaySheetDetailViewController:UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItems(inSection: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! PaySheetDetailViewCell
        
        cell.selectionStyle = .none
        
        cell.configureCellAtIndexPath(indexPath: indexPath, viewModel: viewModel)
        
        return cell
    }
}

extension PaySheetDetailViewController:UITableViewDelegate {
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return viewModel.titleForHeaderInSection(section: section)
//    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 120
        } else if section  == 3 {
            return 60.0
        }
        return 40.0
    }
    
//    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
//        return 40.0
//    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        
        
        if section == 0 {
        
            let urlString = viewModel.urlEmployeeJPG()
            
            let imageView = EllipsedView()
            
            
            if UIApplication.shared.canOpenURL(URL(string: urlString + ".jpg")!) {
                imageView.loadImageUsingUrlString(urlString: urlString + ".jpg", frame: CGRect.zero)

                if imageView.image == nil {
                    imageView.loadImageUsingUrlString(urlString: urlString + ".JPG", frame: CGRect.zero)
                    
                    if imageView.image == nil {
                        if UIApplication.shared.canOpenURL(URL(string: urlString + ".jpeg")!) {
                            imageView.loadImageUsingUrlString(urlString: urlString + ".jpeg", frame: CGRect.zero)
                        
                            if imageView.image == nil {
                                imageView.loadImageUsingUrlString(urlString: urlString + ".JPEG", frame: CGRect.zero)
                                
                                if imageView.image == nil {
                                    
                                    if UIApplication.shared.canOpenURL(URL(string: urlString + ".png")!) {
                                        imageView.loadImageUsingUrlString(urlString: urlString + ".png", frame: CGRect.zero)
                                    
                                        if imageView.image == nil {
                                            imageView.loadImageUsingUrlString(urlString: urlString + ".PNG", frame: CGRect.zero)
                                            
                                            if imageView.image == nil {
                                                imageView.image = UIImage(named: "user")
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }

                }
            }
            
            view.addSubview(imageView)
            
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 5.0).isActive = true
            imageView.widthAnchor.constraint(equalToConstant: 90.0).isActive = true
            imageView.heightAnchor.constraint(equalToConstant: 115.0).isActive  = true
            
            
            if viewModel.isEmployeeDischargd() {
                imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -65.0).isActive = true
                
                let label = UILabel()
                
                label.text = "BAJA POR RENUNCIA"
                label.font = UIFont(name: "Araboto-Bold", size: 12.0)
                label.textAlignment  = .center
                label.backgroundColor = UIColor(red: 99/255.0, green: 111/255.0, blue: 123/255.0, alpha: 1.0)
                label.textColor = UIColor.white
                
                view.addSubview(label)
                label.translatesAutoresizingMaskIntoConstraints = false
                
                label.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 5.0).isActive = true
                label.centerYAnchor.constraint(equalTo: imageView.centerYAnchor, constant: 0.0).isActive = true
                label.heightAnchor.constraint(equalToConstant: 20.0).isActive = true
                label.widthAnchor.constraint(equalToConstant: 130.0).isActive = true
                label.layer.cornerRadius = 5.0
                label.layer.masksToBounds = true
                
                
            } else {
                imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0.0).isActive = true
            }
            
        } else {
        
            let label = UILabel()
            
            
            label.backgroundColor = UIColor(red: 193/255.0, green: 236/255.0, blue: 208/255.0, alpha: 1.0)
            
            label.text = viewModel.titleForHeaderInSection(section: section)
            
            label.font = UIFont(name: "Araboto-Medium", size: 15.0)
            
            label.textColor = UIColor(red: 79/255.0, green: 100/255.0, blue: 103/255.0, alpha: 1.0)
            
            label.textAlignment = .center
            
            label.numberOfLines = 0
            
            view.addSubview(label)
            label.translatesAutoresizingMaskIntoConstraints = false
            
            label.topAnchor.constraint(equalTo: view.topAnchor, constant: 0.0).isActive = true
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10.0).isActive = true
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10.0).isActive = true
            label.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0.0).isActive = true
        
        }
        
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200.0
    }
}
