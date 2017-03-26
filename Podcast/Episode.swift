//
//  Episode.swift
//  Podcast
//
//  Created by Natasha Armbrust on 9/14/16.
//  Copyright © 2016 Cornell App Development. All rights reserved.
//

import UIKit
import SwiftyJSON

class Episode: NSObject {
    
    var id: Int
    var title: String
    var seriesId: Int
    var seriesTitle: String
    var dateCreated: Date
    var descriptionText: String
    var smallArtworkImageURL: URL?
    var largeArtworkImageURL: URL?
    var audioURL: URL?
    var duration: String
    var tags: [Tag]
    var numberOfRecommendations: Int
    var isBookmarked: Bool
    var isRecommended: Bool
    
    //dummy data initializer - will remove in future when we have real data  
    override convenience init() {
        self.init(id: 0, title: "", dateCreated: Date(), descriptionText: "", smallArtworkImageURL:nil, seriesId: 0, largeArtworkImageURL: nil, audioURL: nil, duration: "1:45", seriesTitle: "", tags: [], numberOfRecommendations: 0, isRecommended: false, isBookmarked: false)
    }
    
    //all attribute initializer
    init(id: Int, title: String, dateCreated: Date, descriptionText: String, smallArtworkImageURL: URL?, seriesId: Int, largeArtworkImageURL: URL?, audioURL: URL?, duration: String, seriesTitle: String, tags: [Tag], numberOfRecommendations: Int, isRecommended: Bool, isBookmarked: Bool) {
        self.id = id
        self.title = title
        self.dateCreated = dateCreated
        self.descriptionText = descriptionText
        self.smallArtworkImageURL = smallArtworkImageURL
        self.largeArtworkImageURL = largeArtworkImageURL
        if audioURL == nil { //TAKE THIS OUT LATER ONLY FOR PLAYER STATIC DATA
            self.audioURL = URL(string: "https://play.podtrac.com/npr-510298/npr.mc.tritondigital.com/NPR_510298/media/anon.npr-mp3/npr/ted/2017/02/20170215_ted_tedpod.mp3?orgId=1&d=3241&p=510298&story=515438384&t=podcast&e=515438384&ft=pod&f=510298")
        } else {
            self.audioURL = audioURL
        }
        self.seriesId = seriesId
        self.isRecommended = isRecommended
        self.isBookmarked = isBookmarked
        self.numberOfRecommendations = numberOfRecommendations
        self.seriesTitle = seriesTitle
        self.duration = duration
        self.tags = tags

        super.init()
    }
    
     convenience init(json: JSON) {
        let id = json["id"].intValue
        let title = json["title"].stringValue
        let dateString = json["pubDate"].stringValue
        let descriptionText = json["summary"].stringValue
        let isRecommended = json["is_recommended"].boolValue
        let isBookmarked = json["is_bookmarked"].boolValue
        let numberOfRecommendations = json["n_recommendations"].intValue
        let seriesTitle = json["seriesTitle"].stringValue
        let seriesId = json["seriesId"].intValue
        let duration = json["duration"].stringValue
        let tags = json["tags"].arrayValue.map({ (tag: JSON) in Tag(name: tag.stringValue) })
        let audioURL = URL(string: json["audioUrl"].stringValue)
        let dateCreated = DateFormatter.parsingDateFormatter.date(from: dateString) ?? Date()
        let smallArtworkURL = URL(string: json["imageUrlSm"].stringValue)
        let largeArtworkURL = URL(string: json["imageUrlLg"].stringValue)
        
        self.init(id: id, title: title, dateCreated: dateCreated, descriptionText: descriptionText, smallArtworkImageURL: smallArtworkURL, seriesId: seriesId, largeArtworkImageURL: largeArtworkURL, audioURL: audioURL, duration: duration, seriesTitle: seriesTitle, tags: tags, numberOfRecommendations: numberOfRecommendations, isRecommended: isRecommended, isBookmarked: isBookmarked)
     }
    
    // Returns data - time - series in a string
    func dateTimeSeriesString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        var length = duration + " min"
        if let colon = duration.range(of: ":", options: .backwards) {
            // Found a colon
            let hours = Int(duration.substring(to: colon.lowerBound))
            var minutes = Int(duration.substring(from: colon.upperBound))
            
            length = String(minutes!) + " min"
            if hours != 0 {
                minutes = 60 * hours! + minutes!
                length = String(minutes!) + " min"
            }
        }
        
        // Check if series title is empty because some are
        return seriesTitle != "" ? "\(dateFormatter.string(from: dateCreated)) • \(length) • \(seriesTitle)" : "\(dateFormatter.string(from: dateCreated)) • \(length)"
    }
 
}
