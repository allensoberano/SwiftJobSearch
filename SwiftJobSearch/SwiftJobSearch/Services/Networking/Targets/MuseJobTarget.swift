//
//  MuseJobTarget.swift
//  SwiftJobSearch
//
//  Created by Allen Soberano on 6/12/22.
//

import Foundation
import Moya

enum MuseJobTarget {
    case engineeringJobs
}

extension MuseJobTarget: TargetType {
    var baseURL: URL {
        return URL(string: Secrets.Muse.apiUrl)!
    }
    
    var path: String {
        switch self {
        case .engineeringJobs:
            return "/api/public/jobs"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .engineeringJobs:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .engineeringJobs:
            return .requestParameters(parameters: ["category": "Software Engineer", "category": "Software Engineering", "page": 1, "api_key": Secrets.Muse.ap], encoding: <#T##ParameterEncoding#>)
        }
    }
    
    var headers: [String : String]? {
        ["Content-Type": "application/json"]
    }
    

}
