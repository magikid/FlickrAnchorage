#!/usr/bin/python
import flickrapi

api_key = '8ae842cd467ee53bb5413ecad09edb99'
api_secret = '4bedd2447b006d17'

flickr = flickrapi.FlickrAPI(api_key, api_secret, format='etree')

(token,frob) = flickr.get_token_part_one(perms='read')
if not token: raw_input("Press ENTER after you authorized this program")
flickr.get_token_part_two((token, frob))

photos = flickr.photos_geo_photosForLocation(lat='61.1919', lon='149.7621', accuracy='10', extras='views')
print photos
