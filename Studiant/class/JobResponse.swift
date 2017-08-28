import Foundation
import TRON
import SwiftyJSON

struct JobResponse: JSONDecodable{
    
    var idJob: String
    var descriptionJob: String
    var prixJob: String
    var adresseJob: String
    var dateJob: String
    var heureJob: String
    var statusJob: String
    var categorieJob: String
    var villeJob: String
    var idUtilisateur: String
    var geoplace : GeoplaceResponse
    var appartenir: UserResponse
    var postulants: UsersResponse
    
    
    init(json: JSON) {
        
        idJob = json["id"].stringValue
        descriptionJob = json["descriptionJob"].stringValue
        prixJob = json["prixJob"].stringValue
        adresseJob = json["adresseJob"].stringValue
        dateJob = json["dateJob"].stringValue
        heureJob = json["heureJob"].stringValue
        statusJob = json["statusJob"].stringValue
        villeJob = json["villeJob"].stringValue
        categorieJob = json["categorieJob"].stringValue
        idUtilisateur = json["utilisateurId"].stringValue
        
        geoplace = GeoplaceResponse.init(json: json["latlongJob"])
        
        appartenir = UserResponse.init(json: json["appartenir"])
        postulants = UsersResponse.init(json: json["utilisateurs"])
    
    }
    
}
