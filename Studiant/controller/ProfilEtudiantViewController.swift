//
//  ProfilEtudiantViewController.swift
//  Studiant
//
//  Created by Lucas REYRE on 16/07/2017.
//  Copyright © 2017 Studiant. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FacebookCore
import Haneke
import TRON
import SwiftSpinner
import FirebaseMessaging

class ProfilEtudiantViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate,
                                    UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var prenomTextField: UITextField!
    @IBOutlet weak var nomTextField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var descriptionTextField: UITextView!
    
    @IBOutlet weak var diplomeTextField: UITextField!
    @IBOutlet weak var permisSwitch: UISwitch!
    var id: String?
    var fromFacebook: Bool?
    var myUser : User!
    var strBase64 : String!
    
    //let tron = TRON(baseURL: "https://loopbackstudiant.herokuapp.com/api/")
    let tron = TRON(baseURL: "https://www.studiant.fr/mangoApi/demos/users_create.php")
    let tronImport = TRON(baseURL: "https://www.studiant.fr/studiantApi/")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.contentOffset.x = 0
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        profilePicture.isUserInteractionEnabled = true
        profilePicture.addGestureRecognizer(tapGestureRecognizer)

        if fromFacebook == true
        {
            initForm()
        }
        
        profilePicture.layer.cornerRadius = profilePicture.frame.size.width / 2
        profilePicture.clipsToBounds = true
        // Do any additional setup after loading the view.
    }
    
    func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            var imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        var image = info[UIImagePickerControllerOriginalImage] as! UIImage
        image = self.resizeImage(image: image, newWidth: 250)!
        profilePicture.image = image
        
        let imageData: NSData = UIImagePNGRepresentation(image) as! NSData
        strBase64 = imageData.base64EncodedString(options: .lineLength64Characters)
        dismiss(animated:true, completion: nil)
        
    }
    
    func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage? {
        
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    func initForm() {
        FBSDKGraphRequest(graphPath: "/me", parameters: ["fields": "id, name, email"]).start {
            (connexion, result, err) in
            if err != nil{
                print("Failed to start graph request: ",err)
                return
            }
            
            print(result)
            let myResult = result as AnyObject
            let name = myResult.value(forKey: "name") as! String
            let nameArray = name.components(separatedBy: " ")
            
            self.id = myResult.value(forKey: "id") as! String
            let url = URL(string: "https://graph.facebook.com/" + self.id! + "/picture?height=200&width=200")
            self.profilePicture.hnk_setImageFromURL(url!)
            self.emailTextField.text = myResult.value(forKey: "email") as! String
            self.prenomTextField.text = nameArray[0]
            self.nomTextField.text = nameArray[1]
            
            
            //print(myResult.value(forKey: "email"))
        }

    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField.tag {
        case 0...2:
            break
        default:
            print("default")
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        if textField.tag == 2 {
            scrollView.setContentOffset(CGPoint(x: 0, y: 150), animated: true)
        }else {
            scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        }
            
        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        scrollView.setContentOffset(CGPoint(x: 0, y: 180), animated: true)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            descriptionTextField.resignFirstResponder()
            scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
            return false
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print(textField.tag)
        if textField.tag == 0{
            prenomTextField.becomeFirstResponder()
        } else if textField.tag == 1 {
            nomTextField.becomeFirstResponder()
        } else if textField.tag == 2 {
            //scrollView.setContentOffset(CGPoint(x: 0, y: 100), animated: true)
            diplomeTextField.becomeFirstResponder()
        }else if textField.tag == 3{
            descriptionTextField.becomeFirstResponder()
        }
        return true
        
    }
    
    @IBAction func validerAction(_ sender: Any) {
        SwiftSpinner.show("Inscription en cours")
        
        let user = User.init(nomUtilisateur: nomTextField.text!, prenomUtilisateur: prenomTextField.text!, mailUtilisateur: emailTextField.text!)
        user.typeUtilisateur = 1
        user.typeConnexionUtilisateur = 1
        user.diplomeUtilisateur = diplomeTextField.text
        user.descriptionUtilisateur = descriptionTextField.text
        user.permisUtilisateur = permisSwitch.isOn
        let token = Messaging.messaging().fcmToken
        
        let postRequest: APIRequest<UserResponse, ErrorResponse> = tron.request("Utilisateurs/")
        postRequest.method = .post
        
        if fromFacebook == true{
            user.idExterneUtilisateur = id
            //user.photoUtilisateur = "https://graph.facebook.com/" + self.id! + "/picture?height=200&width=200"
            user.typeConnexionUtilisateur = 0
            
            if let a = strBase64 {
                let postRequestImport: APIRequest<UserResponse, ErrorResponse> = tronImport.request("import.php")
                postRequestImport.method = .post
                postRequestImport.parameters = ["picture": strBase64!,
                                                "secret": "cQEWS7UoI39I7Uk1FxC0YcuG8ge3kXEWArhu2DM1"]
                print(" : ", postRequestImport.path)
                postRequestImport.perform(withSuccess: { (usersImportResponse) in
                    user.photoUtilisateur = usersImportResponse.photoUtilisateur
                    postRequest.parameters = ["nomUtilisateur": user.nomUtilisateur!,
                                              "prenomUtilisateur": user.prenomUtilisateur!,
                                              "photoUtilisateur": user.photoUtilisateur!,
                                              "mailUtilisateur" : user.mailUtilisateur!,
                                              "typeUtilisateur": user.typeUtilisateur,
                                              "idExterneUtilisateur": user.idExterneUtilisateur!,
                                              "typeConnexionUtilisateur": user.typeConnexionUtilisateur!,
                                              "descriptionUtilisateur": user.descriptionUtilisateur!,
                                              "diplomeUtilisateur": user.diplomeUtilisateur!,
                                              "permisUtilisateur": user.permisUtilisateur!,
                                              "firebaseToken": token!]
                    
                    self.addUser(postRequest: postRequest)
                    
                    
                }) { (error) in
                    print(error)
                    SwiftSpinner.hide()
                    print("Error")
                }
            }else{
                postRequest.parameters = ["nomUtilisateur": user.nomUtilisateur!,
                                          "prenomUtilisateur": user.prenomUtilisateur!,
                                          "photoUtilisateur": user.photoUtilisateur!,
                                          "mailUtilisateur" : user.mailUtilisateur!,
                                          "typeUtilisateur": user.typeUtilisateur,
                                          "idExterneUtilisateur": user.idExterneUtilisateur!,
                                          "typeConnexionUtilisateur": user.typeConnexionUtilisateur!,
                                          "descriptionUtilisateur": user.descriptionUtilisateur!,
                                          "diplomeUtilisateur": user.diplomeUtilisateur!,
                                          "permisUtilisateur": user.permisUtilisateur!,
                                          "firebaseToken": token!]
                self.addUser(postRequest: postRequest)
   
            }
            
        }else if fromFacebook == false{
            let postRequestImport: APIRequest<UserResponse, ErrorResponse> = tronImport.request("import.php")
            postRequestImport.method = .post
            postRequestImport.parameters = ["picture": strBase64!,
                                            "secret": "cQEWS7UoI39I7Uk1FxC0YcuG8ge3kXEWArhu2DM1"]
            print(" : ", postRequestImport.path)
            postRequestImport.perform(withSuccess: { (usersImportResponse) in
                user.photoUtilisateur = usersImportResponse.photoUtilisateur
                print("perform with success import ", user.photoUtilisateur!)
                
                postRequest.parameters = ["nomUtilisateur": user.nomUtilisateur!,
                                          "prenomUtilisateur": user.prenomUtilisateur!,
                                          "photoUtilisateur": user.photoUtilisateur!,
                                          "mailUtilisateur" : user.mailUtilisateur!,
                                          "typeUtilisateur": user.typeUtilisateur,
                                          "typeConnexionUtilisateur": user.typeConnexionUtilisateur!,
                                          "descriptionUtilisateur": user.descriptionUtilisateur!,
                                          "diplomeUtilisateur": user.diplomeUtilisateur!,
                                          "permisUtilisateur": user.permisUtilisateur!,
                                          "firebaseToken": token!]
                
                self.addUser(postRequest: postRequest)
                
                
            }) { (error) in
                print(error)
                SwiftSpinner.hide()
                print("Error")
            }
        }
        
    }
    
    
    func addUser(postRequest : APIRequest<UserResponse, ErrorResponse>) {
        postRequest.perform(withSuccess: { (usersResponse) in
            self.myUser = User.init(idUtilisateur: usersResponse.idUtilisateur, typeUtilisateur: 1)
            self.myUser.idMangoPayUtilisateur = usersResponse.idMangoPayUtilisateur
            self.myUser.photoUtilisateur = usersResponse.photoUtilisateur
            KeychainService.saveUser(user: self.myUser)
            SwiftSpinner.hide()
            print(usersResponse)
            self.performSegue(withIdentifier: "dashboardEtudiantSegue", sender: self)
        }) { (error) in
            print(error)
        }
    }

}
