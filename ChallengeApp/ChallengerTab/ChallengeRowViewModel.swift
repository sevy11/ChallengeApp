//
//  ChallengeRowViewModel.swift
//  ChallengeApp
//
//  Created by Michael Sevy on 6/8/20.
//  Copyright © 2020 Michael Sevy. All rights reserved.
//

import Foundation
import Kanna
import Combine

final class ChallengeRowViewModel: ObservableObject, Identifiable {
    private let webScraper = WebScraper()
    
    func getChallengerDetails(challengerName: String, week: Int) {
        print("challenger: \(challengerName) for week \(week)")
        webScraper.getScoresFor(week: week) { [weak self] (response) in
            guard let self = self else { return }
            self.parseForChallengerWeeklyScoring(response: response, challenger: challengerName)
        }
    }
    
    private func parseForChallengerWeeklyScoring(response: String, challenger: String) {
//        print("response: \(response)")
        
        
        if let doc = try? HTML(html: response, encoding: .utf8) {
            
            var foundChallenger = false
            var challengerName = ""
            
            for header in doc.css("a, h4") {
                if let headerValue = header.text {
                    // Add the player
                    if Challenger.challengers.contains(headerValue) {
                        if headerValue == challenger {
                            //print("we found: \(challenger)")
                            
                            challengerName = challenger
                            foundChallenger = true
                            
                        }
                    }
                }
            }
            
            
            if foundChallenger {
                print("found \(challengerName)")
                
                for value in doc.css("\"\"") {
                    if let desc = value.text {
                        print("desc: \(desc)")
                    } else {
                        print("no text")
                    }
                }
            }

        }
    }
}



//Scores</h1>\n            </div>\n        </div>\n        <!-- /.row -->\n\n        <!-- Content Row -->\n        <div class=\"row\">\n\n            <!-- Blog Post Content Column -->\n            <div class=\"col-lg-8\">\n\n                <!-- Post Content -->\n                <div class=\"post_content\" data-show=\"49\" data-episode=\"1\">\n                    View Scoring Breakdown As: <select class=\"scoring_breakdown\" style=\"width:100%\">\n                        <option value=\"default\" >Default Scoring</option>\n                                            </select><br/>\n                    <h2>Eliminated Players:</h2>\n                    <div class=\"panel panel-default\">\n                        <div class=\"panel-body\">\n                                                                                                <span>Asaf Goren</span><br/>\n                                                                                    </div>\n                    </div>\n                    <div class=\"col-md-12\" style=\"margin-bottom:25px\">\n                        <script async src=\"//pagead2.googlesyndication.com/pagead/js/adsbygoogle.js\"></script>\n                        <!-- Responsive Side Bar -->\n                        <ins class=\"adsbygoogle\"\n                             style=\"display:block\"\n                             data-ad-client=\"ca-pub-3563612899201763\"\n                             data-ad-slot=\"7455698336\"\n                             data-ad-format=\"auto\"></ins>\n                        <script>\n                        (adsbygoogle = window.adsbygoogle || []).push({});\n                        </script>\n                    </div><br/>\n                    <h2>Scores:</h2>\n                                                                    <div class=\"panel panel-default\">\n                            <div class=\"panel-heading\">\n                                <h4>Aneesa Ferreira</h4>\n                            </div>\n                            <div class=\"panel-body\">\n                                <ul>\n                                                                                                                        <li class=\"\">Confessional (limited to 10 per episode) (2): <b>2</b></li>\n                                                                                                                                                                                                            <li class=\"\">Survive Each Episode (1): <b>5</b></li>\n                                                                                                                                                        </ul>\n                            </div>\n                            <div class=\"panel-footer\"><h4>Total: 7</h4></div>\n                        </div>\n                                                                    <div class=\"panel panel-default\">\n                            <div class=\"panel-heading\">\n                                <h4>Asaf Goren</h4>\n                            </div>\n                            <div class=\"panel-body\">\n                                <ul>\n                                                                                                                        <li class=\"\">Confessional (limited to 10 per episode) (10): <b>10</b></li>\n                                                                                                                                                                                                            <li class=\"\">Being the first team to do a challenge (1): <b>5</b></li>\n                                                                                                                                                                                                            <li class=\"\">Being Eliminated (1): <b>-10</b></li>\n                                                                                                                                                                                                            <li class=\"\">Verbal Fighting (1): <b>15</b></li>\n                                                                                                                                                                                                            <li class=\"\">Coitus (or pulling cover over bed/noises off camera) (1): <b>25</b></li>\n                                                                                                                                                                                                            <li class=\"\">Kissing On The Lips (once per setting) (1): <b>10</b></li>\n                                                                                                                                                        </ul>\n                            </div>\n                            <div class=\"panel-footer\"><h4>Total: 55</h4></div>\n                        </div>\n                                                                    <div class=\"panel panel-default\">\n                            <div class=\"panel-heading\">\n                                <h4>Ashley Mitchell</h4>\n                            </div>\n                            <div class=\"panel-body\">\n                                <ul>\n                                                                                                                        <li class=\"\">Confessional (limited to 10 per episode) (4): <b>4</b></li>\n                                                                                                                                                                                                            <li class=\"\">Survive Each Episode (1): <b>5</b></li>\n                                                                                                                                                        </ul>\n                            </d
