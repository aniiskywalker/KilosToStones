//
//  ConvertWS.swift
//  KgToStones
//
//  Created by Ana Victoria Frias on 5/18/19.
//  Copyright © 2019 Ana Victoria Frias. All rights reserved.
//

import UIKit
import AFNetworking


protocol convertDelegate {
    func didSuccessGetResult(result: Double)
    func didFailGetResult(error: String)
}

class ConvertWS: NSObject{
    var delegate: convertDelegate!
    var mutableData:NSMutableData  = NSMutableData()
    var currentElementName:String = ""
    
    func convertKilosToStones(value: Int) {
//        Este es mi petición en formato xml, en donde añadí los valores que me proporcionaron
//        TEST NUM 1
//        let soapMessage = "<?xml version='1.0' encoding='utf-8’?><soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/‘><soap:Body><ConvertWeight xmlns='http://www.webserviceX.NET/‘><Weight>\(value)</Weight><FromUnit>Kilograms</FromUnit><ToUnit>Stones</ToUnit></ConvertWeight></soap:Body></soap:Envelope>"
//        TEST NUM 2
        let soapMessage = "<?xml version='1.0' encoding='utf-8’?><soap:Envelope xmlns:soap='http://www.webserviceX.NET/‘><soap:Body><ConvertWeight xmlns='http://www.webservicex.net/ConvertWeight.asmx‘><Weight>\(value)</Weight><FromUnit>Kilograms</FromUnit><ToUnit>Stones</ToUnit></ConvertWeight></soap:Body></soap:Envelope>"
        
//        La URL (que por cierto, regresa un error 404 al dar clic)
        let urlString = "http://www.webservicex.net/ConvertWeight.asmx";
        guard let url = URL(string: urlString) else {
            print("No se pudo crear la URL")
            return
        }
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        var urlRequest = URLRequest(url: url)
        let msgLength = soapMessage.count

//        Headers
        urlRequest.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue(String(msgLength), forHTTPHeaderField: "Content-Lenght")
        urlRequest.httpMethod = "GET" //I think is get
        urlRequest.httpBody = soapMessage.data(using: String.Encoding.utf8, allowLossyConversion: false)
        
        let task = session.dataTask(with: urlRequest) {
            (data, response, error) in
//            Checo si regresa un error
            guard error == nil else {
                print("error en el WS")
                print(error!)
                self.delegate.didFailGetResult(error: error!.localizedDescription)
                return
            }
            guard let responseData = data else {
                print("Error, no se recibió data")
                return
            }
//            Aquí parseo el resultado a JSON
            do {
                guard let result = try JSONSerialization.jsonObject(with: responseData, options: [])
                    as? [String: Any] else {
                        print("Error al convertir a JSON")
                        return
                }
//             print result
                print("El resultado: " + result.description)
                
//                De acuerdo a la documentación consultada, el ws debería regresar un título, no lo pude ver ya que regresa un error
                guard let todoTitle = result["title"] as? String else {
                    print("No se pudo obtener el titulo")
                    return
                }
                print("El titulo es: " + todoTitle)
            } catch  {
                print("error al convertir a JSON")
                return
            }
        }
        task.resume()

    }
}
