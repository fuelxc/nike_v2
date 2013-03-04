NikeV2
====================

![Build Status](https://travis-ci.org/fuelxc/nike_v2.png)

Learn more about the Nike+ API at [https://developer.nike.com/](https://developer.nike.com/).

## Installation
``` bash
gem install nike_v2
```

### Comming Soon
Once Nike releases the OAuth api this gem will include the ability to fetch the access token too

## Examples

In order to utilize the Nike+ API in its current state, you'll need to do the following:
* Sign up for a Nike+ account at [http://nikeplus.nike.com/plus/](http://nikeplus.nike.com/plus/)
* Log into the developer portal and generate an access token at [https://developer.nike.com/](https://developer.nike.com/)

``` ruby
require 'nike_v2'

# Initialize a person
person = NikeV2::Person.new(access_token: 'a1b2c3d4')
# Fetch persons summary
person.summary
# Fetch a persons activities
person.activities
# Load more data for an activity
activity = person.activities.first
activity.fetch_data
# Fetch GPS Data for an activity
activity.gps_data
```

The activities api allows you to directly pass arguements to the Nike+ api.  It also allows you to prefetch the metrics for each activity returned
``` ruby
#fetch 99 activities
person.activities(:count => 99)
#prefetch the metrics for activities
person.activities(:build_metrics => true)
```

We also smart load the metrics for activities now so you don't have to explicity load them
``` ruby
person.activities.total_fuel #fetches the metrics if they aren't already loaded
 => 394
```

## Making it Better
 
* Fork the project.
* Make your feature addition or bug fix in a new topic branch within your repo.
* Add specs for any new or modified functionality.
* Commit and push your changes to Github
* Send a pull request

## Inspiration
I used Kevin Thompson's NikeApi gem as inspiration.  Find it here: https://github.com/kevinthompson/nike_api


## Copyright

Copyright (c) 2013 SmashTank Apps, LLC.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.