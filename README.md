
HZ
===

## Table of Contents
1. [Overview](#Overview)
1. [Product Spec](#Product-Spec)
1. [Wireframes](#Wireframes)
2. [Schema](#Schema)

## Overview
### Description
Social platform for music lovers using Spotify API Integration.

### App Evaluation
- **Category:** Social Media
- **Story:** Meeting new people through music, and discovering new music through people.
- **Market:** Spotify users are hz's market. Ultilizing Spotify's API and the idea of the app itself, hz has unlimited potential for scaling with multiple features.
- **Habit:** Essentially we will be building a niche social media combined with music sharing. hz will be as addictive as other platforms with a quite sizable userbase.
- **Scope:** Based on how far we can take this application, can also easily scale down the features with respect to our time restrictions.

## Product Spec

### 1. User Stories

**Required Must-have Stories**

- [x] User can register/login to hz
- [x] User can login to Spotify
- [ ] User can view posts on feed
- [X] User can create a post on feed
- [X] User can view their profile & others
- [ ] User can toggle whether they prefer their profile and enable posts to be private

**Optional Nice-to-have Stories**

- [ ] User can develop their own taste preferences by selecting their favorite musicians
- [ ] Users can view other users' posts by selecting a specific musician
- [ ] User can connect with other users based on the attributes of the current song they are listening to
- [ ] User can privately chat with other users

### 2. Screen Archetypes

* Sign up/Login 
*[ Create a new account. Flow into setup screen (only for new users/account). Asks for name/username, bithday, and location. list associated required story here]
* [Enter into existing account. Asks for username and password...]
* Home page [list second screen here]
* Upper bar [logoff , settings]
* Bottom bar
* home button [brings to home page]
* profile button[brings to profile page]
* Now playing button[brings to Now playing page]
* Discovery button[brings to discovery page]
* Chat button[brings to chat page]
* Profile page
* [Detail page:Image, account holder's name, public and private playlist ]
* Now playing page
* [current song and list of who is listening the same song]
* Discovery page[new songs,most popular song,liked  by user singer's songs]
* Chat page[chat list]


### 3. Navigation

**Tab Navigation** (Tab to Screen)

1. Main Feed/Home
1. Profile
1. Now Playing
1. Discovery
1. Chat page

**Flow Navigation** (Screen to Screen)

* Profile page[list first screen here]
* Music room [list screen navigation here]
* Post room[list screen navigation here]

* Now Playing [list second screen here]
* Music Room[list screen navigation here]
* Post Room[list screen navigation here]
* Message Room[list screen navigation here]

* Discovery [list third screen here]
* Details[list screen navigation here]

* Chat page[fourth screen here]
* Message Room[list screen navigation here]

## Wireframes
<p align="center"><img src ="https://i.imgur.com/EernKaK.jpg" width=800></p><br>

[PDF of Hand/Digital Sketched Wireframe](https://github.com/LuMiHNate/hz/blob/main/wireframes/first_wireframe.pdf)

### [BONUS] Digital Wireframes & Mockups

<p align="center"><img src ="https://i.imgur.com/tL6KvMZ.png" width=900></P><br>

[Digital Wireframe Mockup](https://github.com/LuMiHNate/hz/blob/main/wireframes/Wireframe-2/hz-digital-wireframe-mockup.png)

### [BONUS] Interactive Prototype
<br>
<img src ="https://github.com/LuMiHNate/hz/blob/main/wireframes/Wireframe-2/hz-interactive-prototype.gif" width=500>

[Interactive Prototype](https://github.com/LuMiHNate/hz/blob/main/wireframes/Wireframe-2/hz-interactive-prototype.gif)

## Schema 

### Models

| Property      | Type     | Description |
| ------------- | -------- | ------------|
| objectId      | String   | unique id for the user post (default field) |
| author        | Pointer to User| image author |
| image         | File     | image that user posts |
| caption       | String   | image caption by author |
| commentsCount | Number   | number of comments that has been posted to an image |
| likesCount    | Number   | number of likes for the post |
| createdAt     | DateTime | date when post is created (default field) |
| loggedIn     | Boolean | user is connected to their Spotify account |
| location     | String | country where the user resides |
| isFavorited     | Boolean | when user "likes" a post |
| song     | JSON Objects | user's desired Spotify song |
| playlist     | JSON Objects | user's desired Spotify playlist |
| nowPlaying     | JSON Objects | calls to play desired Spotify song |
| albumArt     | JSON Objects | calls to display album artwork from Spotify |
| isFollowed     | Boolean | indicates whether user is following another user |
| isAdded     | JSON Objects | adds song to Spotify liked music |
| isPublic     | Boolean | indicates whether a user has a public or private profile |
| wallpaper     | File | image profile wallpaper |

### Networking
#### Add list of network requests by screen:

* **Home Feed Screen**
  * (Read/GET) Query all posts where user is author
  
          let query = PFQuery(className:"Post")
          query.whereKey("author", equalTo: currentUser)
          query.order(byDescending: "createdAt")
          query.findObjectsInBackground { (posts: [PFObject]?, error: Error?) in
             if let error = error { 
                print(error.localizedDescription)
             } else if let posts = posts {
                print("Successfully retrieved \(posts.count) posts.")
            // TODO: Do something with posts...
             }
          }
      
     
  * (Create/POST) Create a new like on a post
  * (Delete) Delete existing like
  * (Create/POST) Create a new comment on a post
  
        let comment = PFObject(className: "Comments")
           comment["text"] = text
           comment["post"] = selectedPost
           comment["author"] = PFUser.current()!
           selectedPost.add(comment, forKey: "comments")
           selectedPost.saveInBackground { (success, error) in
               if success{
                   print("Comment saved")
               }else {
                   print("Error saving comment")
               }
           }
  * (Delete) Delete existing comment
  
* **Create Post Screen**
  * (Create/POST) Create a new post object
  
  
            let user = post["author"] as! PFUser
            cell.usernameLabel.text = user.username
            // !>?
            cell.captionLabel.text = post["caption"] as! String
            
            let imageFile = post["image"] as! PFFileObject
            let urlString = imageFile.url!
            let url = URL(string: urlString)!
            cell.photoView.af_setImage(withURL: url)
            post.saveInBackground { (success, error) in
            if success{
                print("Post saved")
            }else {
                print("Error saving Post")
                
            }
        }
        

* **Profile Screen**
  * (Read/GET) Query logged in user object
  
                 PFUser.logInWithUsername(inBackground: username, password: password) { (user, error) in
                     if user != nil{
                         self.performSegue(withIdentifier: "loginSegue", sender: nil)
                     }else{
                         print("Error:\( String(describing: error?.localizedDescription))")
                     }
                 }
             }
  * (Update/PUT) Update user profile image

##### Basic snippets for each Parse network request:

|    CRUD       | HTTP Verb| Description |
| ------------- | -------- | ------------|
| Create        | POST     | Creates resources |
| Read          | GET      | Fetching posts for a user's feed |
| Update        | PUT      | 	Changes and/or replaces resources or collections |
| Delete        | DELETE   | 	Deletes resources|

##### List endpoints if using existing API: https://developer.spotify.com/:

| HTTP Verb | Endpoint | Description |
| ----------| -------- | ------------|
|  GET      | /users   |Gets a User's Profile |
|  GET      | /me      |Gets Current User's Profile|
|  GET      | /search  |Search for an Item |
|  GET      |/new-releases|Gets All New Releases|
|  GET      |/categories|Get All Categories |
|  GET      |/recommendations|Get Recommendations|
|  GET      | /artists/{id} |Get an Artist |

<!-- 
Spotify Social Media: Mobile App Dev - App Brainstorming

## Team Name Ideas:
1. LuMiHNate

## App Name Ideas:
1. **Wavelength**
2. Blast
3. MyTune
4. hertz
5. Frequency
6. **hz**

## Similar Existing Apps
1. Tastebuds https://tastebuds.fm/ *(music dating app)*

###### **Instagram (reference)**
######    - **Category:** Photo & Video / Social 
######    - **Mobile:** Website is view only, uses camera, mobile first experience.
######    - **Story:** Allows users to share their lives in pictures and enhance their content with filters
######    - **Market:** Anyone that takes pictures could enjoy this app. Ability to follow and hashtag based on interests and categories allows users with unique interests to engage with relevant content.
######    - **Habit:** Users can post throughout the day many times. Features like "Stories" encourage more candid posting as well. Users can explore endless pictures in any category imaginable whenever they want. Very habbit forming!
######    - **Scope:** Instagram started out extremely narrow focused, just posting pics and viewing feeds. Has expanded to a somewhat larger scope including "Instagram Stories" (a la SnapChat) and messenger features. 


-->
