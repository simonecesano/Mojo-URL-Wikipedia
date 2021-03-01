use strict;
use Test::More tests => 11;

use Mojo::URL::Wikipedia { mixin => 1 };

is(Mojo::URL::Wikipedia->new->pageprops("Albert Einstein", "Rosa Luxemburg"),
   'https://en.wikipedia.org/w/api.php?action=query&format=json&prop=pageprops&titles=Albert+Einstein%7CRosa+Luxemburg',
   'titles');


is(Mojo::URL::Wikipedia->new->pageprops("Albert Einstein", "Rosa Luxemburg", { lang => 'de' }),
   'https://de.wikipedia.org/w/api.php?action=query&format=json&prop=pageprops&titles=Albert+Einstein%7CRosa+Luxemburg',
   'titles german');

is(Mojo::URL::Wikipedia->new->extracts("Albert Einstein", "Rosa Luxemburg", { lang => 'de' }),
   'https://de.wikipedia.org/w/api.php?action=query&format=json&prop=extracts&exintro=&explaintext=&redirects=1&titles=Albert+Einstein%7CRosa+Luxemburg',
   'pageprops');

is(Mojo::URL::Wikipedia->new->file('Einstein_1921_portrait2.jpg'),
   'https://upload.wikimedia.org/wikipedia/commons/f/f5/Einstein_1921_portrait2.jpg',
   'image');

is(Mojo::URL::Wikipedia->new->file('Einstein_1921_portrait2.jpg', 120),
   'https://upload.wikimedia.org/wikipedia/commons/thumb/f/f5/Einstein_1921_portrait2.jpg/120px-Einstein_1921_portrait2.jpg',
   'thumbnail');

is(Mojo::URL::Wikipedia->new->file('Einstein_1921_portrait2.jpg', "120px"),
   'https://upload.wikimedia.org/wikipedia/commons/thumb/f/f5/Einstein_1921_portrait2.jpg/120px-Einstein_1921_portrait2.jpg',
   'thumbnail with px');

is(Mojo::URL::Wikipedia->new->geosearch_bbox(40.7, -74.0),
   'https://en.wikipedia.org/w/api.php?action=query&list=geosearch&format=json&gslimit=500&gsbbox=40.7%7C-74%7C40.6%7C-73.9',
   'geosearch 1');

is(Mojo::URL::Wikipedia->new->geosearch_bbox(41.9028, 12.4964),
   'https://en.wikipedia.org/w/api.php?action=query&list=geosearch&format=json&gslimit=500&gsbbox=41.9028%7C12.4964%7C41.8028%7C12.5964',
   'geosearch 2');

is(Mojo::URL::Wikipedia->new->geosearch_bbox(-34.6037, -58.3816),
   'https://en.wikipedia.org/w/api.php?action=query&list=geosearch&format=json&gslimit=500&gsbbox=-34.6037%7C-58.3816%7C-34.7037%7C-58.2816',
   'geosearch 3');

is(Mojo::URL::Wikipedia->new->geosearch_bbox(-25.7479, 28.2293),
   'https://en.wikipedia.org/w/api.php?action=query&list=geosearch&format=json&gslimit=500&gsbbox=-25.7479%7C28.2293%7C-25.8479%7C28.3293',
   'geosearch 4');

is(Mojo::URL::Wikipedia->new->entity('Q937'),
   'https://www.wikidata.org/wiki/Special:EntityData/Q937.json',
   'wikidata entity');
