//
//  NetworkEndpointTests.swift
//  horse_racing
//
//  Created by Kapil Maharjan on 15/12/2024.
//

import XCTest
@testable import horse_racing

class NetworkEndpointTests: XCTestCase {
    
    func text_with_racing_endpoint_request_is_valid(){
        let endpoint = Endpoint.racing(method: "nextraces", count: 10)
        
        XCTAssertEqual(endpoint.host,"api.neds.com.au","The host should be api.neds.com.au")
        XCTAssertEqual(endpoint.path,"/rest/v1/racing/","The endpoint should be /rest/v1/racing/")
        XCTAssertEqual(endpoint.methodType,.GET,"The method should be GET")
        XCTAssertEqual(endpoint.queryItems,["method":"nextraces","count":"10"],"The query items should be method:nextraces,count:10")
        
        
        XCTAssertEqual(endpoint.url?.absoluteString,"https://api.neds.com.au/rest/v1/racing/?method=nextraces&count=10","The generated doesnot match output")

    }
}
