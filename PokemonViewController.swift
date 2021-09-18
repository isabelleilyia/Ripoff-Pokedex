import UIKit

class PokemonViewController: UIViewController {
    var url: String!
    var caught = false
    let defaults = UserDefaults.standard
    var caughtPoke: [String?] = []
    var x: String? = ""
    var ID: String? = ""

    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var numberLabel: UILabel!
    @IBOutlet var type1Label: UILabel!
    @IBOutlet var type2Label: UILabel!
    @IBOutlet var catchButton: UIButton!
    @IBOutlet var sprite: UIImageView!
    @IBOutlet var pokeDescription: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func capitalize(text: String) -> String {
        return text.prefix(1).uppercased() + text.dropFirst()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        nameLabel.text = ""
        numberLabel.text = ""
        type1Label.text = ""
        type2Label.text = ""
        
    //    loadPokeDescription(number: Int)
        loadPokemon()
        ID = "1"

    }

    func loadPokemon() {
        URLSession.shared.dataTask(with: URL(string: url)!) { (data, response, error) in
            guard let data = data else {
                return
            }

            do {
                let result = try JSONDecoder().decode(PokemonResult.self, from: data)
                DispatchQueue.main.async {
                    self.navigationItem.title = self.capitalize(text: result.name)
                    self.nameLabel.text = self.capitalize(text: result.name)
                    self.numberLabel.text = String(format: "#%03d", result.id)
                    self.checkForCatchStatus(Name: self.nameLabel.text)
                    
                    let url = URL(string: result.sprites.front_default)
                    do {
                        let data1 = try Data(contentsOf: url!)
                        self.sprite.image = UIImage(data: data1)
                    }
                    catch let error {
                        print(error)
                    }
                    for typeEntry in result.types {
                        if typeEntry.slot == 1 {
                            self.type1Label.text = typeEntry.type.name
                        }
                        else if typeEntry.slot == 2 {
                            self.type2Label.text = typeEntry.type.name
                        }
                    }
                    self.loadPokeDescription(number: result.id)
                }
            }
            catch let error {
                print(error)
            }
        }.resume()
    }
    
    func loadPokeDescription (number: Int) {
        guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon-species?limit=151") else {
            return
            }
            
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                guard let data = data else {
                    return
                }
                do {
                    let entries = try JSONDecoder().decode(PokemonListForDescriptions.self, from: data)
                    let url1 = "https://pokeapi.co/api/v2/pokemon-species/\(number)"
                   // print(url1)
                    self.loadPoke1(url: url1)
                }
                catch let error {
                    print(error)
                }
            }.resume()
    }
        
    func loadPoke1 (url: String) {
        URLSession.shared.dataTask(with: URL(string: url)!) { (data, response, error) in
            guard let data = data else {
                return
            }

            do {
                let result = try JSONDecoder().decode(PokemonDescription.self, from: data)
                DispatchQueue.main.async {
                    for entries in result.flavor_text_entries.reversed() {
                        self.pokeDescription.text = entries.flavor_text
                    }
                }
            }
            catch let error {
                print(error)
            }
        }.resume()
    }
        
    @IBAction func toggleCatch() {

        if caught == true {
            catchButton.setTitle("Catch", for: .normal)
            caughtPoke = caughtPoke.filter {$0 != x}
            caught = false
            
        } else {
            catchButton.setTitle("Release", for: .normal)
            caughtPoke.append(x!)
            caught = true
        }
        saveCatchStatus()
    }
    
    func saveCatchStatus () {
      //defaults.set(caughtPokemon[nameLabel.text!], forKey: nameLabel.text!)
        defaults.set(caughtPoke, forKey: "ListOfCaughtPokes")
    }
    
    
    func checkForCatchStatus (Name: String?) {
        caught = false
        x = Name
        if defaults.stringArray(forKey: "ListOfCaughtPokes") != nil {
            caughtPoke = defaults.stringArray(forKey: "ListOfCaughtPokes")!
        }
        for name in caughtPoke {
            if Name! == name {
                caught = true
                catchButton.setTitle("Release", for: .normal)
                caughtPoke.append(x!)
            }
        }
    }
    
}
