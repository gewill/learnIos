import Moya

enum FirstAppApi {
    case getNewsList(id: String)
}

extension FirstAppApi: TargetType {
    // 定义请求路径
    var path: String {
        switch self {
        case .getNewsList(let lastId):
            return "/v2/news/index"
        }
    }
    
    // 请求方式
    var method: Moya.Method {
        return .get
    }
    
    // 如果有请求参数，可以在此处返回相应的参数
    var task: Moya.Task {
        switch self {
        case .getNewsList(let id):
            return .requestParameters(parameters: [
                "last_oid": id
            ], encoding: URLEncoding.default)
        @unknown default:
            return .requestPlain
        }
         
    }
    
    var headers: [String: String]? {
        return nil
    }
    
    // baseURL 接口前缀
    var baseURL: URL {
        return URL(string: "https://opser.api.dgtle.com")!
    }
}
