//
//  PaySheetViewCell.swift
//  SIRHCOBNOMINA
//
//  Created by Roberto Alba on 16/02/21.
//

import UIKit

extension CAShapeLayer {
    convenience init(path: UIBezierPath) {
        self.init()
        self.path = path.cgPath
    }
}


class VerticalTopAlignLabel: UILabel {

    override func drawText(in rect:CGRect) {
        guard let labelText = text else {  return super.drawText(in: rect) }

        let attributedText = NSAttributedString(string: labelText, attributes: [NSAttributedString.Key.font: font!])
        var newRect = rect
        newRect.size.height = attributedText.boundingRect(with: rect.size, options: .usesLineFragmentOrigin, context: nil).size.height

        if numberOfLines != 0 {
            newRect.size.height = min(newRect.size.height, CGFloat(numberOfLines) * font.lineHeight)
        }

        super.drawText(in: newRect)
    }

}


class EllipsedView: UIImageView {
    var imageUrlString:String?
    
    func loadImageUsingUrlString(urlString:String, frame:CGRect)  {
        imageUrlString = urlString
        
        let url = URL(string:urlString)!
        
        image = nil
        
        if let imageFromCache = imageCache.object(forKey: NSString(string: urlString)) {
            self.image = imageFromCache as? UIImage
            
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error)
                return
            }
            
            DispatchQueue.main.async {
                print(urlString)
                print("value data:\(data?.count ?? -1)")
                
                
//                let str = String(decoding: data!, as: UTF8.self)
//
//                print("data:\(str)")
                
                
                let imageToCache = UIImage(data: data!)
                
                
                if  imageToCache == nil {
                    return
                }
                
                
                
                if self.imageUrlString == urlString {
//                    self.image = self.setImage(imageToResize: imageToCache!, frame: frame)
                    self.image = imageToCache
                }
                
                if imageToCache != nil {
                
                    imageCache.setObject(imageToCache!, forKey: NSString(string: urlString))
                
                    self.image = imageToCache
                }
                
                
            }
            
        }.resume()
        
    }
    
    func setImage(imageToResize: UIImage, frame: CGRect) -> UIImage?
    {
        let width = frame.size.width
        let height = frame.size.height
        
        var scaleFactor: CGFloat
        
        if(width > height)
        {
            scaleFactor = frame.size.height / height;
            
            scaleFactor = 165 / height;
        }
        else
        {
            scaleFactor = frame.size.width / width;
        }
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: width * scaleFactor, height: height * scaleFactor), false, 0.0)
        
        imageToResize.draw(in: CGRect(x: 0, y: 0, width: width * scaleFactor, height: height * scaleFactor))
        
        
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return resizedImage
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.mask = CAShapeLayer(path: .init(ovalIn: bounds))
    }
}



class PaySheetViewCell: UITableViewCell {

    @IBOutlet weak var labelRecordNumber: UILabel!
    @IBOutlet weak var imageViewEmployee: EllipsedView!
//    @IBOutlet weak var labelEmployeeName: VerticalTopAlignLabel!
    
    @IBOutlet weak var labelEmployeeName: UITextView!
//    @IBOutlet weak var labelEmployeeCampus: VerticalTopAlignLabel!
    
    @IBOutlet weak var labelEmployeeCampus: UITextView!
//    @IBOutlet weak var labelEmployeeCategory: VerticalTopAlignLabel!
    
    @IBOutlet weak var labelEmployeeCategory: UITextView!
    
    
    @IBOutlet weak var viewStausEmployee: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func configureCellAtIndexPath(indexPath:IndexPath, viewModel:PaySheetViewModel)  {
        self.labelRecordNumber.text = "\(indexPath.item + 1)"
        self.labelEmployeeName.text = "\(viewModel.employeeNameAtIndexPath(indexPath: indexPath))\n\(viewModel.employeeDataOfAdmission(indexPath: indexPath))\n\(viewModel.employeeSyndicate(indexPath: indexPath))"
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = -5
        
        
        var attributedString = NSMutableAttributedString(string: self.labelEmployeeName.text!, attributes: [NSAttributedString.Key.font : UIFont(name: "Araboto-Medium", size: 15.0)!, NSAttributedString.Key.foregroundColor : UIColor(red: 105/255.0, green: 114/255.0, blue: 129/255.0, alpha: 1.0), NSAttributedString.Key.paragraphStyle : paragraphStyle])
        
        attributedString.addAttributes([NSAttributedString.Key.font : UIFont(name: "Araboto-Normal", size: 13.0)!], range: NSRange(location: viewModel.employeeNameAtIndexPath(indexPath: indexPath).count + 1, length: viewModel.employeeDataOfAdmission(indexPath: indexPath).count + 1 + viewModel.employeeSyndicate(indexPath: indexPath).count))
        
        
        self.labelEmployeeName.attributedText = attributedString
        
        
        self.labelEmployeeCampus.text = "\(viewModel.employeeCampusAtIndexPath(indexPath: indexPath))\n\(viewModel.employeeWorkCenter(indexPath: indexPath))"
        
        attributedString = NSMutableAttributedString(string: self.labelEmployeeCampus.text!, attributes: [NSAttributedString.Key.font : UIFont(name: "Araboto-Medium", size: 15.0)!, NSAttributedString.Key.foregroundColor : UIColor(red: 105/255.0, green: 114/255.0, blue: 129/255.0, alpha: 1.0), NSAttributedString.Key.paragraphStyle : paragraphStyle])
        
        attributedString.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "Araboto-Normal", size: 13.0)!, range: NSRange(location: viewModel.employeeCampusAtIndexPath(indexPath: indexPath).count + 1, length: viewModel.employeeWorkCenter(indexPath: indexPath).count))
        
        self.labelEmployeeCampus.attributedText = attributedString
        
        
        
        self.labelEmployeeCategory.text = "\(viewModel.employeeCategoryAtIndexPath(indexPath: indexPath))\n\(viewModel.employeeFunctionSecond(indexPath: indexPath))\n\(viewModel.employeeFortnightStart(indexPath: indexPath)) \(viewModel.employeeFortnightEnd(indexPath: indexPath))"
        
        
        attributedString = NSMutableAttributedString(string: self.labelEmployeeCategory.text!, attributes: [NSAttributedString.Key.font : UIFont(name: "Araboto-Medium", size: 15.0)!, NSAttributedString.Key.foregroundColor : UIColor(red: 105/255.0, green: 114/255.0, blue: 129/255.0, alpha: 1.0), NSAttributedString.Key.paragraphStyle : paragraphStyle])
        
        
        attributedString.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "Araboto-Normal", size: 13.0)!, range: NSRange(location: viewModel.employeeCategoryAtIndexPath(indexPath: indexPath).count + 1, length: viewModel.employeeFunctionSecond(indexPath: indexPath).count + 1 + viewModel.employeeFortnightStart(indexPath: indexPath).count + viewModel.employeeFortnightEnd(indexPath: indexPath).count + 1))
        
        self.labelEmployeeCategory.attributedText = attributedString
        
        
        
        
        let urlString = viewModel.urlEmployeeJPG(indexPath: indexPath)
        
                
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
        
        if viewModel.isEmployeeDischargd(indexPath: indexPath) {
            viewStausEmployee.backgroundColor = UIColor(red: 228/255.0, green: 84/255.0, blue: 84/255.0, alpha: 1.0)
        } else {
            viewStausEmployee.backgroundColor = UIColor(red: 48/255.0, green: 181/255.0, blue: 88/255.0, alpha: 1.0)
        }
        

//        else
//        if UIApplication.shared.canOpenURL(URL(string: urlString + ".jpeg")!) {
//            self.imageViewEmployee.loadImageUsingUrlString(urlString: urlString + ".jpeg", frame: CGRect.zero)
//
//            if self.imageViewEmployee.image == nil {
//                self.imageViewEmployee.loadImageUsingUrlString(urlString: urlString + ".JPEG", frame: CGRect.zero)
//            }
//        }
//
//        else
//        if UIApplication.shared.canOpenURL(URL(string: urlString + ".png")!) {
//            self.imageViewEmployee.loadImageUsingUrlString(urlString: urlString + ".png", frame: CGRect.zero)
//
//            if self.imageViewEmployee.image == nil {
//                self.imageViewEmployee.loadImageUsingUrlString(urlString: urlString + ".PNG", frame: CGRect.zero)
//            }
//        }
        
        
//        self.imageViewEmployee.loadImageUsingUrlString(urlString: urlString + ".jpeg", frame: CGRect.zero)
//
//        self.imageViewEmployee.loadImageUsingUrlString(urlString: urlString + ".JPEG", frame: CGRect.zero)
//
//        self.imageViewEmployee.loadImageUsingUrlString(urlString: urlString + ".png", frame: CGRect.zero)
//
//        self.imageViewEmployee.loadImageUsingUrlString(urlString: urlString + ".PNG", frame: CGRect.zero)
            
//        if self.imageViewEmployee.image == nil {
//            self.imageViewEmployee.loadImageUsingUrlString(urlString: urlString + ".JPG", frame: CGRect.zero)
//
//
//            if self.imageViewEmployee.image == nil {
//                self.imageViewEmployee.loadImageUsingUrlString(urlString: urlString + ".jpeg", frame: CGRect.zero)
//
//                if self.imageViewEmployee.image == nil {
//                    self.imageViewEmployee.loadImageUsingUrlString(urlString: urlString + ".JPEG", frame: CGRect.zero)
//
//
//                    if self.imageViewEmployee.image == nil {
//                        self.imageViewEmployee.loadImageUsingUrlString(urlString: urlString + ".png", frame: CGRect.zero)
//
//                        if self.imageViewEmployee.image == nil {
//                            self.imageViewEmployee.loadImageUsingUrlString(urlString: urlString + ".PNG", frame: CGRect.zero)
//                        }
//                    }
//                }
//            }
//        }
    }
}


let imageCache = NSCache<NSString, AnyObject>()

class CustomImageView: UIImageView {
    var imageUrlString:String?
    
    func loadImageUsingUrlString(urlString:String, frame:CGRect)  {
        imageUrlString = urlString
        
        let url = URL(string:urlString)!
        
        image = nil
        
        if let imageFromCache = imageCache.object(forKey: NSString(string: urlString)) {
            self.image = imageFromCache as? UIImage
            
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error)
                return
            }
            
            DispatchQueue.main.async {
                print(urlString)
                print("value data:\(data?.count ?? -1)")
                
                
//                let str = String(decoding: data!, as: UTF8.self)
//
//                print("data:\(str)")
                
                
                let imageToCache = UIImage(data: data!)
                
                
                if  imageToCache == nil {
                    return
                }
                
                
                
                if self.imageUrlString == urlString {
//                    self.image = self.setImage(imageToResize: imageToCache!, frame: frame)
                    self.image = imageToCache
                }
                
                if imageToCache != nil {
                
                    imageCache.setObject(imageToCache!, forKey: NSString(string: urlString))
                
                    self.image = imageToCache
                }
                
                
            }
            
        }.resume()
        
    }
    
    func setImage(imageToResize: UIImage, frame: CGRect) -> UIImage?
    {
        let width = frame.size.width
        let height = frame.size.height
        
        var scaleFactor: CGFloat
        
        if(width > height)
        {
            scaleFactor = frame.size.height / height;
            
            scaleFactor = 165 / height;
        }
        else
        {
            scaleFactor = frame.size.width / width;
        }
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: width * scaleFactor, height: height * scaleFactor), false, 0.0)
        
        imageToResize.draw(in: CGRect(x: 0, y: 0, width: width * scaleFactor, height: height * scaleFactor))
        
        
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return resizedImage
    }
}
