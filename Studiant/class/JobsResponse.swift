import Foundation
import TRON
import SwiftyJSON

struct JobsResponse: JSONDecodable {
    
    let jobs: [JobResponse]
    
    init(json: JSON) throws {
        let jobsArray = json.arrayValue
        jobs = jobsArray.map({JobResponse(json: $0)})
    }
}
