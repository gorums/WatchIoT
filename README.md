WatchIoT [![Build Status](https://travis-ci.org/gorums/WatchIoT.svg)](https://travis-ci.org/gorums/WatchIoT) [![Code Climate](https://codeclimate.com/github/gorums/WatchIoT/badges/gpa.svg)](https://codeclimate.com/github/gorums/WatchIoT) [![Test Coverage](https://codeclimate.com/github/gorums/WatchIoT/badges/coverage.svg)](https://codeclimate.com/github/gorums/WatchIoT/coverage) [![Inline docs](http://inch-ci.org/github/gorums/watchiot.svg?branch=master)](http://inch-ci.org/github/gorums/watchiot) [![endorse](https://api.coderwall.com/gorums/endorsecount.png)](https://coderwall.com/gorums)
==

**A monitor services, resources and IoT**

Multi-Platform
--

You can monitor different platforms, like the resources of your server on linux, windows or any application in the cloud and the smart devices (Internet of Thing).

Configurable
--

The power of Watch IoT is whole configurable, you can configure what server or resource you will monitor, what parameters you will receive and when the system will throw an alert for you.

Notification
--

The notifications via email and sms are in real time about what is happened with your services or resources. Feel secure, you have all under control and you can sleep relaxing we are going to stay alert for you.

Bidirectional
--

Watch IoT can request your services or you services can request Watch IoT, dependent your necessities. You can specify period of time when send the request you services or who you expect for the request.

Scripting
--

You have two way of parser the request/response. Using configured params or can create scripting to parse your values. You can take decision using the scripts about who would be notified.

Charting
--

All history data can be shown using charting and you can see how your services have worked. The charting always is a great tool for understand health of your services and resources.

Changelog
--

*1 september 2015*

Dashboard work begin

*15 august 2015*

Finished the first part of the home page

*1 june 2015*

Create watchIoT project on github, first commit

TODO
--

**13 September 2015**

> Define Route

 [ ] watchiot.org/user_name/space/project

> Integration with avatar

 [X] see how do it on rails.

> Login/register with github

 [ ] add username field.

 [ ] see how do it on rails.

> Dashboard page

 [ ] This page contain a create space and last project notification.

> Spaces page

 [ ] Create a space (name, description and categories).

 [ ] Spaces list.

 [ ] Projects by space.

 [ ] Edit space.

 [ ] Delete space if dont have projects.

 [ ] Setting space.

> Space page

 [ ] Edit space (description and categories).

 [ ] Delete space if dont have projects.

 [ ] Setting space.

 [ ] Projects by space.

 [ ] Add new project (name, description and categories).

 [ ] Edit project.

 [ ] Setting project.

> Setting space page

 [ ] Public or private.

 [ ] if public nobody have permission, such the owner.

 [ ] if public user can subscriber to receive alert.

 [ ] if private can to assign users.

 [ ] Permission by team members.

 [ ] Permission to edit space description and add category.

 [ ] Permission to create project.

 [ ] Permission to receive notification (email, sms).

> Project page

 [ ] Edit project

 [ ] Delete project only by the owner

 [ ] Setting project.

 [ ] Define notification (email, sms, webhook)

 [ ] Define the via to recollect info (request by us or waiting for request)

 [ ] Define client url or ip

 [ ] Define parameters

 [ ] Define stages (default: normal{green}, warning{yellow}, fire{red})

 [ ] Configure stages in correlation with parameters (simple condition, script)

> Setting project page

 [ ] Public or private (if space is private it can't be public).

 [ ] Permission by team members.

 [ ] Permission to edit project description and add category.

 [ ] Permission to receive notification (email, sms).

> Setting account page

 [ ] Get token.

 [ ] upgrade plan.

 [ ] Add team members (send an email invite his with a temporal passwd).

 [ ] Edit user info.

 [ ] Delete account.

> Chart page

 [ ] Show chart project group by space using the parameters metric and stages.