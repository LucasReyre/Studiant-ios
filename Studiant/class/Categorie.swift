//
//  categorie.swift
//  Studiant
//
//  Created by Lucas REYRE on 27/07/2017.
//  Copyright © 2017 Studiant. All rights reserved.
//

import Foundation
import UIKit

public class Categorie {
    
    var categorieStringArray = ["Cours particuliers",
                                "Informatique",
                                "Jardinage",
                                "Baby-sitting",
                                "Déménagement",
                                "Bricolage",
                                "Evènementiel",
                                "Nettoyage/Repassage",
                                "Animaux",
                                "Mécanique/Réparation",
                                "Transport/Livraison",
                                "Beauté/Bien être",
                                "Administration",
                                "Autres"]
    
    var color = UIColor()
    var picto = UIImage()
    var stringToWork: String!
    
    
    
    init(withString: String) {
        self.stringToWork = withString
        
        switch withString {
        case categorieStringArray[0]:
            color = self.hexStringToUIColor(hex: "ce0000")
            picto = UIImage(named: "cours")!
        case categorieStringArray[1]:
            color = self.hexStringToUIColor(hex: "0080ff")
            picto = UIImage(named: "informatique")!
        case categorieStringArray[2]:
            color = self.hexStringToUIColor(hex: "04b431")
            picto = UIImage(named: "jardinage")!
        case categorieStringArray[3]:
            color = self.hexStringToUIColor(hex: "f3e520")
            picto = UIImage(named: "baby")!
        case categorieStringArray[4]:
            color = self.hexStringToUIColor(hex: "ff9400")
            picto = UIImage(named: "demenagement")!
        case categorieStringArray[5]:
            color = self.hexStringToUIColor(hex: "585858")
            picto = UIImage(named: "bricomecarepa")!
        case categorieStringArray[6]:
            color = self.hexStringToUIColor(hex: "9438ff")
            picto = UIImage(named: "evenementiel")!
        case categorieStringArray[7]:
            color = self.hexStringToUIColor(hex: "f6cef5")
            picto = UIImage(named: "nettoyage")!
        case categorieStringArray[8]:
            color = self.hexStringToUIColor(hex: "fea887")
            picto = UIImage(named: "animaux")!
        case categorieStringArray[9]:
            color = self.hexStringToUIColor(hex: "929292")
            picto = UIImage(named: "bricomecarepa")!
        case categorieStringArray[10]:
            color = self.hexStringToUIColor(hex: "945100")
            picto = UIImage(named: "transportlivraison")!
        case categorieStringArray[11]:
            color = self.hexStringToUIColor(hex: "D16FD6")
            picto = UIImage(named: "bienetre")!
        case categorieStringArray[12]:
            color = self.hexStringToUIColor(hex: "ef80b3")
            picto = UIImage(named: "administration")!
        case categorieStringArray[13]:
            color = self.hexStringToUIColor(hex: "0433ff")
            picto = UIImage(named: "autres")!
        default:
            color = self.hexStringToUIColor(hex: "0433ff")
            picto = UIImage(named: "autres")!
            break
            
        }
        
    }
    
    func getCategorie() -> Categorie {
        
        
        return self
    }
    
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.characters.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    
}
