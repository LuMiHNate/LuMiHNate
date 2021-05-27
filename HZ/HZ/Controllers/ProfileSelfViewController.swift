//
//  ProfileSelfViewController.swift
//  HZ
//
//  Created by Hashir Khan on 5/14/21.
//

import UIKit
import SpotifyLogin
import Parse
import AlamofireImage

class ProfileSelfViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
  
    
    
    
    @IBOutlet weak var feedTable: UITableView!
    let defaults = UserDefaults.standard
    var posts = [[String: Any]]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // this is just to test that logging out works
        // you can comment this out if you don't want to be logged out when you hit the profile screen
//        userSpotifyID = ""
//        SpotifyLogin.shared.logout()
            feedTable.dataSource = self
            feedTable.delegate = self

        // Do any additional setup after loading the view.
            let query = PFQuery(className:"Posts")
            query.findObjectsInBackground { (objects: [PFObject]?, error: Error?) in
                if let error = error {
                    // Log details of the failure
                    print(error.localizedDescription)
                } else if let objects = objects {
                    // The find succeeded.
                print("Successfully retrieved \(objects.count) scores.")
                    // Do something with the found objects
                for object in objects {
                    if let user = object["user"] as? String {
                        if user == userSpotifyID {
                            if let image = object["image"] {
                                self.posts.append(["Category": "Image", "Post": image, "User": user])
                            }
                        
                            if let text = object["text"] {
                                self.posts.append(["Category": "Text", "Post": text, "User": user])
                            }
                        
                            if let song = object["Songs"] {
                                self.posts.append(["Category": "Song", "Post": song, "User": user])
                            } else if let album = object["Albums"] {
                                self.posts.append(["Category": "Album", "Post": album, "User": user])
                            } else if let playlist = object["Playlists"] {
                                self.posts.append(["Category": "Playlist", "Post": playlist, "User": user])
                            }
                        }
                    }
                }
                
                print(self.posts)
                self.feedTable.reloadData()
            }
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.feedTable.reloadData()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = posts[indexPath.row]
        let user = post["User"] as! String
        let category = post["Category"] as! String
        
        if category == "Image" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "imagePost") as! PicturePostCell
            
            //set image
            let imageFile = post["Post"] as! PFFileObject
            let urlString = imageFile.url!
            let url = URL(string: urlString)!
            cell.imagePostView.af.setImage(withURL: url)
            
            //set username
            cell.usernameImagePostLabel.text = user
            return cell
        } else if category == "Text" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "textPost") as! TextPostCell
            
            //set text field
            let text = post["Post"] as! String
            cell.textFieldTextPostLabel.text = text
            
            //set username
            cell.usernameTextPostLabel.text = user
            return cell
        } else { //music cell
            let cell = tableView.dequeueReusableCell(withIdentifier: "musicPost") as! MusicPostCell
            
            //set username
            cell.usernameMusicPostLabel.text = user
            let musicId = post["Post"] as! String
            
            if category == "Song" {
                let url = URL(string: "https://api.spotify.com/v1/tracks/\(musicId)")!
                var request = URLRequest(url: url)
                request.setValue("Bearer \(bearerAccessToken)", forHTTPHeaderField: "Authorization")
                
                let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
                let task = session.dataTask(with: request) { (data, response, error) in
                   // This will run when the network request returns
                   if let error = error {
                      print(error.localizedDescription)
                   } else if let data = data {
                    let decoder = JSONDecoder()
                    do {
                        let track = try decoder.decode(TrackInfo.self, from: data)
                        
                        //get title
                        cell.musicTitleLabel.text = track.name
                        
                        //get artists
                        let artists = track.artists
                        var artistList = [String]()
                        for artist in artists {
                            artistList.append(artist.name)
                        }
                        cell.musicArtistLabel.text = artistList.joined(separator: ", ")
                        
                        //get link
                        cell.musicLinkLabel.text = track.external_urls.spotify
                        
                        //get image link
                        if track.album.images.count != 0 {
                            let imageUrl = URL(string: track.album.images[0].url)
                            let data = try? Data(contentsOf: imageUrl!)
                            
                            if let imageData = data {
                                cell.musicImageView.image = UIImage(data: imageData)
                            }
                        }
                    } catch {
                        print("Couldn't decode the response")
                    }
                    
                   }
                }
                task.resume()

            } else if category == "Album" {
                let url = URL(string: "https://api.spotify.com/v1/albums/\(musicId)")!
                var request = URLRequest(url: url)
                request.setValue("Bearer \(bearerAccessToken)", forHTTPHeaderField: "Authorization")
                
                let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
                let task = session.dataTask(with: request) { (data, response, error) in
                   // This will run when the network request returns
                   if let error = error {
                      print(error.localizedDescription)
                   } else if let data = data {
                    let decoder = JSONDecoder()
                    do {
                        let album = try decoder.decode(AlbumInfo.self, from: data)
                        
                        //get title
                        cell.musicTitleLabel.text = album.name
                        
                        //get artists
                        let artists = album.artists
                        var artistList = [String]()
                        for artist in artists {
                            artistList.append(artist.name)
                        }
                        cell.musicArtistLabel.text = artistList.joined(separator: ", ")
                        
                        //get link
                        cell.musicLinkLabel.text = album.external_urls.spotify
                        
                        //get image link
                        if album.images.count != 0 {
                            let imageUrl = URL(string: album.images[0].url)
                            let data = try? Data(contentsOf: imageUrl!)
                            
                            if let imageData = data {
                                cell.musicImageView.image = UIImage(data: imageData)
                            }
                        }
                    } catch {
                        print("Couldn't decode the response")
                    }
                    
                   }
                }
                task.resume()

            } else if category == "Playlist" {
                let url = URL(string: "https://api.spotify.com/v1/playlists/\(musicId)")!
                var request = URLRequest(url: url)
                request.setValue("Bearer \(bearerAccessToken)", forHTTPHeaderField: "Authorization")
                
                let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
                let task = session.dataTask(with: request) { (data, response, error) in
                   // This will run when the network request returns
                   if let error = error {
                      print(error.localizedDescription)
                   } else if let data = data {
                    let decoder = JSONDecoder()
                    do {
                        let playlist = try decoder.decode(SavedPlaylist.self, from: data)
                        
                        //get title
                        cell.musicTitleLabel.text = playlist.name
                        
                        //get link
                        cell.musicLinkLabel.text = playlist.external_urls.spotify
                        
                        //get image link
                        if playlist.images.count != 0 {
                            let imageUrl = URL(string: playlist.images[0].url)
                            let data = try? Data(contentsOf: imageUrl!)
                            
                            if let imageData = data {
                                cell.musicImageView.image = UIImage(data: imageData)
                            }
                        }
                    } catch {
                        print("Couldn't decode the response")
                    }
                    
                   }
                }
                task.resume()
            }
            return cell
        }
    }
    
    
    
    func getSongById(id: String) -> [String: Any] {
        
        var trackInfo = [String: Any]()
        
        let url = URL(string: "https://api.spotify.com/v1/tracks/\(id)")!
        var request = URLRequest(url: url)
        request.setValue("Bearer \(bearerAccessToken)", forHTTPHeaderField: "Authorization")
        
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
           // This will run when the network request returns
           if let error = error {
              print(error.localizedDescription)
           } else if let data = data {
            let decoder = JSONDecoder()
            do {
                print("yo")
                let track = try decoder.decode(TrackInfo.self, from: data)
                
                //get title
                trackInfo["Title"] = track.name
                
                //get artists
                let artists = track.artists
                var artistList = [String]()
                for artist in artists {
                    artistList.append(artist.name)
                }
                trackInfo["Artists"] = artistList.joined(separator: ", ")
                
                //get link
                trackInfo["Link"] = track.external_urls.spotify
                
                //get image link
                if track.album.images.count != 0 {
                    trackInfo["ImageLink"] = URL(string: track.album.images[0].url)
                }
            } catch {
                print("Couldn't decode the response")
            }
            
           }
        }
        task.resume()
        
        return trackInfo
    }

    
    
}
