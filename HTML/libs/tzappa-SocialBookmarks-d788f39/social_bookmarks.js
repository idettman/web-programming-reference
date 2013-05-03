/**
 * Social Bookmarks
 * @author Plamen Popov <tzappa@gmail.com>
 * @version 20110221
 * @license Creative Commons Attribution-Share Alike 3.0
 */

function social_bookmarks(id, media, url, title) {
    var icon_size = 32,
        m, b, link, html = '',
        bookmarks = {
    	'delicious': {
            'name': 'del.icio.us',
            'link': 'http://del.icio.us/post?url={url}&title={title}',
            'icon': 0
    	},
        'digg': {
            'name': 'Digg',
            'link': 'http://digg.com/submit?phase=2&url={url}&title={title}',
            'icon': 1
        },
        'facebook': {
            'name': 'Facebook',
            'link': 'http://www.facebook.com/sharer.php?u={url}&t={title}',
            'icon': 2
        },
        'friendfeed': {
            'name': 'Friendfeed',
            'link': 'http://friendfeed.com/share?url={url}&title={title}',
            'icon': 3
        },
        'google': {
            'name': 'Google Bookmarks',
            'link': 'http://www.google.com/bookmarks/mark?op=edit&bkmk={url}&title={title}',
            'icon': 4
        },
        'linkedin': {
            'name': 'LinkedIn',
            'link': 'http://www.linkedin.com/shareArticle?mini=true&url={url}&title={title}',
            'icon': 5
        },
        'myspace': {
        	'name': 'MySpace',
        	'link': 'http://www.myspace.com/index.cfm?fuseaction=postto&t={title}&u={url}',
        	'icon': 6 
        },
        'reddit': {
            'name': 'reddit',
            'link': 'http://reddit.com/submit?url={url}&title={title}',
            'icon': 7
        },
        'stumbleupon': {
            'name': 'StumbleUpon',
            'link': 'http://www.stumbleupon.com/submit?url={url}&title={title}',
            'icon': 8
        },
        'technorati': {
            'name': 'Technorati',
            'link': 'http://www.technorati.com/faves?add={url}',
            'icon': 9
        },
        'twitter': {
            'name': 'Twitter',
            'link': 'http://twitter.com/?status={title} {url}',
            'icon': 10
        },
        'windows': {
        	'name': 'Windows Live',
            'link': 'https://favorites.live.com/quickadd.aspx?url={url}&title={title}',
            'icon': 11
        },
        'yahoo': {
        	'name': 'Yahoo! My Web',
            'link': 'http://bookmarks.yahoo.com/toolbar/savebm?opener=tb&u={url}&t={title}',
            'icon': 12
        },
        'svejo': {
        	'name': 'Svejo.net',
        	'link': 'http://svejo.net/story/submit_by_url?url={url}&title={title}',
        	'icon': 13
        },
        'edno23': {
        	'name': 'Едно23',
		'link': 'http://edno23.com/pf:open?loadtext={title}&loadlink={url}&loadimg={image}',
        	'icon': 14
        }
    };
    
    if (url === undefined) {
    	url = document.location;
    }
    if (title === undefined) {
    	title = document.title;
    }
    for (m in media) {
    	if (bookmarks[media[m]] !== undefined) {
    		b = bookmarks[media[m]];
    		link = b.link.replace(/\{url\}/g, encodeURIComponent(url)).replace(/\{title\}/g, title);
    		html += '<a target="_blank" href="' + link + '" id="' + media[m] + '" title="' + b.name + '" style="background-position: ' + b.icon * icon_size * -1 + 'px 0"></a>';
    	}
    }
    document.getElementById(id).innerHTML = html;
}
