# Project 4 - *Fancier Twitter*

**Fancier Twitter** is a Twitter app using the [Twitter API](https://dev.twitter.com/docs).

Time spent: **12** hours spent in total

## User Stories

The following **required** functionality is completed:

Hamburger menu:
[x] Dragging anywhere in the view should reveal the menu.
[x] The menu should include links to your profile, the home timeline, and the mentions view.
Profile Page:
[x] Contains the user header view
[x] Contains a section with the users basic stats: # tweets, # following, # followers
[x] Shows the user timeline
Home Timeline:
[x] Tapping on a user image should bring up that user's profile page

Please list two areas of the assignment you'd like to **discuss further with your peers** during the next class (examples include better ways to implement something, how to extend your app in certain ways, etc):

1. How to use the debugger in XCode.
2. Not really a discussion but I'd like a sample solution to the homework.

## Video Walkthrough

Here's two walkthrough of implemented user stories:

<img src='http://i.giphy.com/l2JhIKITbDCZ14l5C.gif' title='Video Walkthrough' width='' alt='Video Walkthrough' />

GIF created with [LiceCap](http://www.cockos.com/licecap/).
Icons courtesy of [Flat Icon](http://www.flaticon.com/).
## Notes

In this iteration, I fixed the issue with reply. Although I mention the author in the status update, I didn't attach the path parameter that the POST call requires. I also fixed the Twitter favorite count to use the actual favorite_count field, as opposed to favourite_count, however, it's still showing up as 0 for me. 

In addition, I have simplified a lot of the view controller communications to just a one way communication from the parent view controller to the child view controller via segues. I have made design decisions where the children view controllers don't need to talk back to the parent view controllers. This means that I'm limiting my exposure to better designs and use of delegate patterns. As this is the last personal assignment, I'm coming up with technical areas of focus to pursue in the group project.  

One last thing I find particularly challenging with these more complicated homework is the right way to do things. What's the right way to show view modal controllers? The root view controller is always the `HamburgerViewController`, so when I tried to present a view off of any of the contentViewControllers, I'd get a warning saying that I'm showing a view controller off of the view hierarchy. However, everything still "worked", despite the warning. I decided to present any modals off of the root view controller and let the root view controller handle all the interactions with the modal. That suppressed the warning and hopefully is an acceptable way to do things.

## License

    Copyright [2016] [Estella Lai]

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.