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
        self.resultado.text = nil
    }
    
    @IBAction func buscar(sender: AnyObject) {
        
        if (isbn.text != nil && isbn.text!.isEmpty) {
            self.resultado.text = nil
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
            let texto = NSString(data:datos!, encoding:NSUTF8StringEncoding)
            
            // Se muestra el resultado de la petición
            resultado.text = texto as! String
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
}

