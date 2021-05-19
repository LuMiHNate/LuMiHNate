//
//  CreatePostViewController.swift
//  HZ
//
//  Created by Matthew Soto on 5/18/21.
//

import UIKit
import AlamofireImage
import Parse
import SpotifyLogin

class CreatePostViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var commentView: UITextView!
    @IBOutlet weak var songsButton: UIButton!
    @IBOutlet weak var albumsButton: UIButton!
    @IBOutlet weak var playlistsButton: UIButton!
    @IBOutlet weak var selectedMusic: UILabel!
    
    var songs = [SavedTrack]()
    var albums = [SavedAlbum]()
    var playlists = [SavedPlaylist]()
    var musicCategorySelectedByUser = "Songs"
    var savedMusicId = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableView.delegate = self
        tableView.dataSource = self
        
        showUserSavedTracks(self)
    }
    
    @IBAction func savePost(_ sender: Any) {
        let post = PFObject(className: "Posts")
        var numberOfThingsInPost = 0
        
        post["user"] = userSpotifyID
        if commentView.text != "" {
            numberOfThingsInPost += 1
            post["text"] = commentView.text
        }
        if imageView.image != #imageLiteral(resourceName: "image_placeholder") {
            numberOfThingsInPost += 1
            let imageData = imageView.image?.pngData()
            let file = PFFileObject(data: imageData!)
            post["image"] = file
        }
        if savedMusicId != "" {
            numberOfThingsInPost += 1
            post[musicCategorySelectedByUser] = savedMusicId
        }
        
        if numberOfThingsInPost != 0 {
            post.saveInBackground { (success, error) in
                if success {
                    self.navigationController?.popViewController(animated: true)
                    print("success!")
                } else {
                    print("error!")
                }
            }
        }
    }
    
    @IBAction func showUserSavedTracks(_ sender: Any) {
        musicCategorySelectedByUser = "Songs"
        
        //highlight the correct button
        albumsButton.isSelected = false
        playlistsButton.isSelected = false
        songsButton.isSelected = true
        
        let url = URL(string: "https://api.spotify.com/v1/me/tracks")!
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
                let savedTracks = try decoder.decode(SavedTracks.self, from: data)
                self.songs = savedTracks.items
                self.tableView.reloadData()
                
            } catch {
                print("Couldn't decode the response")
            }
            
           }
        }
        task.resume()
    }
    
    @IBAction func showSavedAlbums(_ sender: Any) {
        musicCategorySelectedByUser = "Albums"
        
        //highlight the correct button
        albumsButton.isSelected = true
        playlistsButton.isSelected = false
        songsButton.isSelected = false
        
        let url = URL(string: "https://api.spotify.com/v1/me/albums")!
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
                let savedAlbums = try decoder.decode(SavedAlbums.self, from: data)
                self.albums = savedAlbums.items
                self.tableView.reloadData()
                
            } catch {
                print("Couldn't decode the response")
            }
            
           }
        }
        task.resume()
    }
    
    @IBAction func showPlaylists(_ sender: Any) {
        musicCategorySelectedByUser = "Playlists"
        
        //highlight the correct button
        albumsButton.isSelected = false
        playlistsButton.isSelected = true
        songsButton.isSelected = false
        
        let url = URL(string: "https://api.spotify.com/v1/me/playlists")!
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
                let savedPlaylists = try decoder.decode(SavedPlaylists.self, from: data)
                self.playlists = savedPlaylists.items
                self.tableView.reloadData()
                
            } catch {
                print("Couldn't decode the response")
            }
            
           }
        }
        task.resume()
    }
    
    // MARK: - Table View Functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if musicCategorySelectedByUser == "Songs" {
            return songs.count
        } else if musicCategorySelectedByUser == "Albums" {
            return albums.count
        } else if musicCategorySelectedByUser == "Playlists" {
            return playlists.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if musicCategorySelectedByUser == "Songs" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SongCell") as! SongCell
            let song = songs[indexPath.row].track
            cell.title.text = song.name
            cell.link.text = song.external_urls.spotify
            
            var artistList = [String]()
            for artist in song.artists {
                artistList.append(artist.name)
            }
            cell.artists.text = artistList.joined(separator: ", ")
            
            if song.album.images.count != 0 {
                let imageUrl = URL(string: song.album.images[0].url)
                let data = try? Data(contentsOf: imageUrl!)
                
                if let imageData = data {
                    cell.musicPic.image = UIImage(data: imageData)
                }
            }
            return cell
        } else if musicCategorySelectedByUser == "Albums" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SongCell") as! SongCell
            let album = albums[indexPath.row].album
            cell.title.text = album.name
            cell.link.text = album.external_urls.spotify
            
            var artistList = [String]()
            for artist in album.artists {
                artistList.append(artist.name)
            }
            cell.artists.text = artistList.joined(separator: ", ")
            
            if album.images.count != 0 {
                let imageUrl = URL(string: album.images[0].url)
                let data = try? Data(contentsOf: imageUrl!)
                
                if let imageData = data {
                    cell.musicPic.image = UIImage(data: imageData)
                }
            }
            return cell
        } else if musicCategorySelectedByUser == "Playlists" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SongCell") as! SongCell
            let playlist = playlists[indexPath.row]
            cell.title.text = playlist.name
            cell.link.text = playlist.external_urls.spotify
            cell.artists.text = ""
            
            if playlist.images.count != 0 {
                let imageUrl = URL(string: playlist.images[0].url)
                let data = try? Data(contentsOf: imageUrl!)
                
                if let imageData = data {
                    cell.musicPic.image = UIImage(data: imageData)
                }
            }
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! SongCell
        selectedMusic.text = "Selected Music: " + cell.title.text!

        if musicCategorySelectedByUser == "Songs" {
            savedMusicId = songs[indexPath.row].track.id
        } else if musicCategorySelectedByUser == "Albums" {
            savedMusicId = albums[indexPath.row].album.id
        } else if musicCategorySelectedByUser == "Playlists" {
            savedMusicId = playlists[indexPath.row].id
        }
    }
    
    // MARK: - Image Functions
    @IBAction func onCameraButton(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
        } else {
            picker.sourceType = .photoLibrary
        }
        
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.editedImage] as! UIImage
        
        let size = CGSize(width: 300, height: 300)
        let scaledImage = image.af.imageScaled(to: size)
        
        imageView.image = scaledImage
        dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
