//
//  ViewController.swift
//  OpenLibrary
//
//  Created by Jacinto Mena Lomeña on 20/12/15.
//  Copyright © 2015 Jacinto Mena Lomeña. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var isbn: UITextField!
    
    @IBOutlet weak var resultado: UITextView!
    
    @IBOutlet weak var titulo: UILabel!
    
    @IBOutlet weak var autores: UILabel!
    
    @IBOutlet weak var portada: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func limpiar(sender: AnyObject) {
        // Se borra el resultado
        self.isbn.text = nil
        self.autores.text = nil
        self.titulo.text = nil
        self.portada.image = nil
    }
    
    @IBAction func buscar(sender: AnyObject) {
        
        if (isbn.text != nil && isbn.text!.isEmpty) {
            self.titulo.text = nil
            self.autores.text = nil
            self.portada.image = nil
        } else {
            // Se realiza la petición
            self.request()
        }
    }
    
    func request() {
        let urls = "https://openlibrary.org/api/books?jscmd=data&format=json&bibkeys=ISBN:" + self.isbn.text!
        let url = NSURL(string: urls)
        let datos : NSData? = NSData(contentsOfURL: url!)
        
        if (datos == nil)  {
            resultado.text = "Se ha producido un error en la conexión con el servidor. Pruebe más tarde."
            
        } else {
            
            
            // Se convierte el resultado en un JSON para mostrarlo
            do {
                let json = try NSJSONSerialization.JSONObjectWithData(datos!, options: NSJSONReadingOptions.MutableLeaves)
                if (json["ISBN:" + self.isbn.text!] == nil) {
                    throw NoDataError.NoDataFound
                }
                let dicLibro = json["ISBN:" + self.isbn.text!] as! NSDictionary
                let valueTitulo = dicLibro["title"] as! NSString as String
                
                // Asignamos el valor del título al campo correspondiente
                self.titulo.text = valueTitulo
                
                // Se saca la información de los autores
                var valueAutores = "Desconocido"
                
                if dicLibro["authors"] != nil {
                    let dicAutores = dicLibro["authors"] as! NSArray
                    
                    if dicAutores.count > 0 {
                        valueAutores = "";
                        var primero = true
                        for (var j = 0; j < dicAutores.count; j++) {
                            if (primero) {
                                valueAutores = (dicAutores[j] as! NSDictionary)["name"] as! NSString as String
                                primero = false
                            } else {
                                valueAutores = valueAutores + "\n" + ((dicAutores[j] as! NSDictionary)["name"] as! NSString as String)
                            }
                        }
                    }
                }
                
                // Asignamos el valor de los autores
                self.autores.text = valueAutores
                
                // Sacamos la portada si existe
                if dicLibro["cover"] != nil {
                    let dicCover = dicLibro["cover"] as! NSDictionary
                    if (dicCover["large"] != nil) {
                        let urlString = dicCover["large"] as! NSString as String
                        let imgURL: NSURL = NSURL(string: urlString)!
                        let request: NSURLRequest = NSURLRequest(URL: imgURL)
                        NSURLConnection.sendAsynchronousRequest(
                            request, queue: NSOperationQueue.mainQueue(),
                            completionHandler: {(response: NSURLResponse?,data: NSData?,error: NSError?) -> Void in
                                if error == nil {
                                    self.portada.image = UIImage(data: data!)
                                }
                        })
                    }
                }
                
            } catch NoDataError.NoDataFound {
                limpiar(self)
            } catch {
                print("Se ha producido un error no controlado")
            }
            
            
        
        }
        
    }

    @IBAction func endEdit(sender: AnyObject) {
        
        // Se lanza la búsqueda en el enter
        self.buscar(sender)
        
    }
    @IBAction func enter(sender: AnyObject) {
        
        // Se lanza la búsqueda en el enter
        self.buscar(sender)
    }
    
    
    internal enum NoDataError : ErrorType {
        case NoDataFound
        case NoAuthorFound
    }
}

