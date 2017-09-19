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
    var typePaiementJob: String
    var idUtilisateur: String
    var idPostulant: String
    var geoplace : GeoplaceResponse
    var appartenir: UserResponse
    var postulants: UsersResponse
    
    
    init(json: JSON) {
        print(json)
        idJob = json["id"].stringValue
        descriptionJob = json["descriptionJob"].stringValue
        prixJob = json["prixJob"].stringValue
        adresseJob = json["adresseJob"].stringValue
        dateJob = json["dateJob"].stringValue
        heureJob = json["heureJob"].stringValue
        statusJob = json["statutJob"].stringValue
        villeJob = json["villeJob"].stringValue
        categorieJob = json["categorieJob"].stringValue
        typePaiementJob = json["typePaiementJob"].stringValue
        idUtilisateur = json["utilisateurId"].stringValue
        idPostulant = json["postulantId"].stringValue
        
        geoplace = GeoplaceResponse.init(json: json["latlongJob"])
        
        appartenir = UserResponse.init(json: json["appartenir"])
        postulants = UsersResponse.init(json: json["utilisateurs"])
    
    }
    
}
