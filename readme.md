---
title: ReadME

---

Original App Design Project - README Template
===

# Musix - Analyzer and Ratings

## Table of Contents

1. [Overview](#Overview)
2. [Product Spec](#Product-Spec)
3. [Wireframes](#Wireframes)
4. [Schema](#Schema)

## Overview

### Description

A music analytics and reviewing app that gives you statistics based on your listening habits, recommends you new albums, and allows you to rate the music you have listened to.

### App Evaluation

[Evaluation of your app across the following attributes]
Mobile: The app can give notifications for recently listened albums asking you to rate it. 
Most people listen to music on their phone making it more convenient than a website

Story: A convenient and easy place to quickly rate albums and share a virtual collection of music

Market: Millions of people listen to music everyday and everyone has opinions on it. This is a place to share those opinions.

Habit: The user would open this app whenever they want to rate an album or learn about their music habits

Scope: It will be quite technically challenging to create all the capabilities of this app
A stripped down version would be interesting
I'd say the product is clearly defined for me.

## Product Spec

### 1. User Stories (Required and Optional)

**Required Must-have Stories**

* Music Listening Analytics – Tracks and visualizes user listening habits (e.g., most-played albums, genres, artists).
* Album Rating System – Allows users to rate albums they have listened to.
* Music Recommendations – Suggests new albums based on listening history and preferences.

**Optional Nice-to-have Stories**

* Social Sharing & Reviews – Users can share their ratings and reviews, view others' ratings, and interact with a community.

### 2. Screen Archetypes

- Analyitics Screen
* Tracks and visualizes user listening habits
* ...
- Rating / Review Screen
* Album Rating System – Allows users to rate albums they have listened to.
* ...
- Home Screen 
* Music Recommendations – Suggests new albums based on listening history and preferences.

### 3. Navigation

**Tab Navigation** (Tab to Screen)

* Home – Displays recommendations based on listening history.
* Analytics – Shows user listening habits, top albums, and stats.
* Library – Contains rated albums, favorites, and listening history.

**Flow Navigation** (Screen to Screen)

 Home Screen

➡ Analytics Screen (Tap on “View My Stats”)

➡ Album Details Screen (Tap on a recommended album)

➡ Rating/Review Screen (Tap on "Rate This Album")

 Analytics Screen

➡ Home Screen (Back button or tab navigation)

➡ Library Screen (Tap on “View My Rated Albums”)

➡ Album Details Screen (Tap on an album to see stats and details)

 Library Screen

➡ Album Details Screen (Tap on any album for more info)

➡ Rating/Review Screen (Tap on “Edit My Rating”)

➡ Analytics Screen (Tap on “View My Listening Trends”)

 Album Details Screen

➡ Rating/Review Screen (Tap on “Rate This Album”)

➡ Community Screen (Tap on “See Public Reviews”)

➡ Library Screen (Back button or tab navigation)

 Rating/Review Screen

➡ Home Screen (Back button or tab navigation)

➡ Album Details Screen (Tap on “See More About This Album”)

➡ Analytics Screen (Tap on “See My Listening Stats”)

## Wireframes

[Add picture of your hand sketched wireframes in this section]
<img src="https://imgur.com/UNZVDrL" width=600>

### [BONUS] Digital Wireframes & Mockups

### [BONUS] Interactive Prototype

## Schema 

Models

Album
Represents an album or track
name: String, artist: String, imageURL: String

Artist
Represents an artist
name: String, imageURL: String

Favorite
Saved album for Profile
name: String, artist: String

## Networking

Home Screen:

Request: Fetch recent tracks.

Analytics Screen:

Requests: Fetch weekly tracks, albums, artists.

Endpoints (Last.fm):

user.getrecenttracks
user.getweeklytrackchart
user.getweeklyalbumchart
user.getweeklyartistchart

### Models

[Add table of models]
