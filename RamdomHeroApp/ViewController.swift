//
//  ViewController.swift
//  HeroRandomizer
//
//  Created by Arman Myrzakanurov on 13.11.2024.
//

import UIKit

struct Hero: Decodable {
    let name: String
    let slug: String
    let biography: Biography
    let images: HeroImage
    let powerstats: PowerStats

    struct Biography: Decodable {
        let fullName: String
    }
    
    struct PowerStats: Decodable {
        let intelligence: Int
        let strength: Int
        let speed: Int
        let durability: Int
        let power: Int
        let combat: Int
    }

    struct HeroImage: Decodable {
        let sm: String
    }
}


class ViewController: UIViewController {
    

    @IBOutlet weak var heroImage: UIImageView!
    
    @IBOutlet weak var heroName: UILabel!
    
    
    @IBOutlet weak var heroSlug: UILabel!
    
    
    @IBOutlet weak var heroFullName: UILabel!
    
    
    @IBOutlet weak var heroIntellegence: UILabel!
    
    
    @IBOutlet weak var heroStrenth: UILabel!
    
    
    @IBOutlet weak var heroSpeed: UILabel!
    
    
    @IBOutlet weak var heroDurability: UILabel!
    
    
    @IBOutlet weak var heroPower: UILabel!
    
    
    @IBOutlet weak var heroCombat: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func roll(_ sender: UIButton) {
        let randomId = Int.random(in: 1...563)
        fetchHero(by: randomId)
    }

    private func fetchHero(by id: Int) {
        let urlString = "https://akabab.github.io/superhero-api/api/id/\(id).json"
        guard let url = URL(string: urlString) else { return }
        let urlRequest = URLRequest(url: url)

        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            guard self.handleErrorIfNeeded(error: error) == false else {
                return
            }

            guard let data else { return }
            self.handleHeroData(data: data)
        }.resume()
    }

    private func handleHeroData(data: Data) {
        do {
            let hero = try JSONDecoder().decode(Hero.self, from: data)
            let heroImage = self.getImageFromUrl(string: hero.images.sm)

            DispatchQueue.main.async {
                self.heroName.text = hero.name
                self.heroSlug.text = hero.slug
                self.heroFullName.text = hero.biography.fullName
                self.heroIntellegence.text = "Intelligence: \(hero.powerstats.intelligence)"
                self.heroStrenth.text = "Strength: \(hero.powerstats.strength)"
                self.heroSpeed.text = "Speed: \(hero.powerstats.speed)"
                self.heroDurability.text = "Durability: \(hero.powerstats.durability)"
                self.heroPower.text = "Power: \(hero.powerstats.power)"
                self.heroCombat.text = "Combat: \(hero.powerstats.combat)"
                self.heroImage.image = heroImage
            }
        } catch {
            DispatchQueue.main.async {
                self.heroName.text = error.localizedDescription + "\nReRoll again!"
                self.heroSlug.text = ""
                self.heroFullName.text = ""
                self.heroIntellegence.text = ""
                self.heroSpeed.text = ""
                self.heroDurability.text = ""
                self.heroPower.text = ""
                self.heroCombat.text = ""
                self.heroImage.image = nil
            }
        }
    }

    private func getImageFromUrl(string: String) -> UIImage? {
        guard
            let heroImageURL = URL(string: string),
            let imageData = try? Data(contentsOf: heroImageURL)
        else {
            return nil
        }
        return UIImage(data: imageData)
    }

    private func handleErrorIfNeeded(error: Error?) -> Bool {
        guard let error else {
            return false
        }
        print(error.localizedDescription)
        return true
    }
}
