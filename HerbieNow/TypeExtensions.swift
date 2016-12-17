//
//  TypeExtensions.swift
//  HerbieNow
//
//  Created by Benno Kress on 14.12.16.
//  Copyright © 2016 LMU. All rights reserved.
//

import Foundation
import JASON
import Alamofire

extension Dictionary {

    func appending(_ value: Value, forKey key: Key) -> [Key: Value] {
        var result = self
        result[key] = value
        return result
    }

}

extension DataRequest {

    /**
     Creates a response serializer that returns a JASON.JSON object constructed from the response data.

     - returns: A JASON.JSON object response serializer.
     */
    static public func JASONReponseSerializer() -> DataResponseSerializer<JASON.JSON> {
        return DataResponseSerializer { _, _, data, error in
            guard error == nil else {
                // swiftlint:disable:next force_unwrapping
                return .failure(error!)
            }

            return .success(JASON.JSON(data))
        }
    }

    /**
     Adds a handler to be called once the request has finished.

     - parameter completionHandler: A closure to be executed once the request has finished.

     - returns: The request.
     */
    @discardableResult
    public func responseJASON(completionHandler: @escaping (DataResponse<JASON.JSON>) -> Void) -> Self {
        return response(responseSerializer: DataRequest.JASONReponseSerializer(), completionHandler: completionHandler)
    }

}
