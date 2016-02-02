# The DocPad Configuration File
# It is simply a CoffeeScript Object which is parsed by CSON
path = require('path')

docpadConfig = {

# =================================
# Template Data
# These are variables that will be accessible via our templates
# To access one of these within our templates, refer to the FAQ: https://github.com/bevry/docpad/wiki/FAQ
	prompts: false,

	# renderPasses: 2,

	templateData:

	# Specify some site properties
		site:
		# The production url of our website
		# If not set, will default to the calculated site URL (e.g. http://localhost:9778)
			url: "http://know.soom.la"

		# Here are some old site urls that you would like to redirect from
			oldUrls: [
				'www.website.com',
				'website.herokuapp.com'
			]

		# The default title of our website
			title: "GROW Knowledge Base"

		# The website description (for SEO)
			description: """
				GROW Analytics platform knowledge base website to teach you everything you need to know about GROW. Easy integration with your favorite mobile SDKs and God Mode Analytics to allow you to compare to others.
				Also, docs for SOOMLA - the open source framework that allows you to easily develop: virtual economy, in-app purchase (IAP), and social functions.
        """

		# The website keywords (for SEO) separated by commas
			keywords: """
        game programming framework, virtual economy, in app purchase, gaming, indie developers
        """

		# The website's styles
			styles: [
				'/styles/tocify.css'
				'/styles/highlightcode.css'
				'/styles/footer.css'
				'/styles/knowledge.css',
				'/styles/animate.css'
			]

		# The website's scripts
			scripts: [
        '/scripts/jquery-ui-1-10-4-min.js',
        '/vendor/log.js'
        '/vendor/modernizr.js'
        '/scripts/jquery-tocify-min.js'
        '/scripts/knowledge-base.js'
			]


		topLevelNavItems: [
			{
				id: 'unity',
				title: 'Unity',
				link: '/unity'
			}
			{
				id: 'cocos2dx',
				title: 'Cocos2d-x',
				link: '/cocos2dx'
			}
			{
				id: 'university',
				title: 'University',
				link: '/university'
			}
			{
				id: 'downloads',
				title: 'Downloads',
				link: 'http://dashboard.soom.la/downloads'
			}
			{
				id: 'soomla',
				title: 'Soomla',
				link: '/soomla'
			}
		]

		soomlaModules: {
			'unity': [
				{
					id: 'store',
					title: 'Store'
				}
				{
					id: 'profile',
					title: 'Profile'
				}
			],
			'cocos2dx': [
				{
					id: 'store',
					title: 'Store'
				}
				{
					id: 'profile',
					title: 'Profile'
				}
			],
			'ios': [
				{
					id: 'store',
					title: 'Store'
				}
				{
					id: 'profile',
					title: 'Profile'
				}
			],
			'android': [
				{
					id: 'store',
					title: 'Store'
				}
				{
					id: 'profile',
					title: 'Profile'
				}
			],
			'university': [
				{
					id: 'articles',
					title: 'Articles'
				},
				{
					id: 'videos',
					title: 'Videos'
				}
			]
		}



	# -----------------------------
	# Helper Functions

	# Get the prepared site/document title
	# Often we would like to specify particular formatting to our page's title
	# we can apply that formatting here
		getPreparedTitle: ->
			# if we have a document title, then we should use that and suffix the site's title onto it
			if @document.title
				"#{@document.title} | #{@site.title}"
				# if our document does not have it's own title, then we should just use the site's title
			else
				@site.title

	# Get the prepared site/document description
		getPreparedDescription: ->
			# if we have a document description, then we should use that, otherwise use the site's description
			@document.description or @site.description

	# Get the prepared site/document keywords
		getPreparedKeywords: ->
			# Merge the document keywords with the site keywords
			@site.keywords.concat(@document.keywords or []).join(', ')

		getGruntedStyles: ->
			_ = require 'underscore'
			styles = []
			gruntConfig = require('./grunt-config.json')
			_.each gruntConfig, (value, key) ->
			styles = styles.concat _.flatten _.pluck value, 'dest'
			styles = _.filter styles, (value) ->
				return value.indexOf('.min.css') > -1
			_.map styles, (value) ->
				return value.replace 'out', ''

		getGruntedScripts: ->
			_ = require 'underscore'
			scripts = []
			gruntConfig = require('./grunt-config.json')
			_.each gruntConfig, (value, key) ->
				scripts = scripts.concat _.flatten _.pluck value, 'dest'
			scripts = _.filter scripts, (value) ->
				return value.indexOf('.min.js') > -1
			_.map scripts, (value) ->
				return value.replace 'out', ''

# =================================
# Collections

# Here we define our custom collections
# What we do is we use findAllLive to find a subset of documents from the parent collection
# creating a live collection out of it
# A live collection is a collection that constantly stays up to date
# You can learn more about live collections and querying via
# http://bevry.me/queryengine/guide


# That contains all the documents that will be going to the out path posts
	collections:

		soomla: ->
			@getCollection('documents').findAllLive({relativeOutDirPath: path.join('soomla')},[position:1])

		soomla_unity_store: ->
			@getCollection('documents').findAllLive({relativeOutDirPath: path.join('soomla','unity','store')},[position:1])

		soomla_unity_profile: ->
			@getCollection('documents').findAllLive({relativeOutDirPath: path.join('soomla','unity','profile')},[position:1])

		soomla_unity_samples: ->
			@getCollection('documents').findAllLive({relativeOutDirPath: path.join('soomla','unity','samples')},[position:1])

		soomla_ios_store: ->
			@getCollection('documents').findAllLive({relativeOutDirPath: path.join('soomla', 'ios', 'store')},[position:1])

		soomla_ios_profile: ->
			@getCollection('documents').findAllLive({relativeOutDirPath: path.join('soomla','ios','profile')},[position:1])

		soomla_ios_samples: ->
			@getCollection('documents').findAllLive({relativeOutDirPath: path.join('soomla','ios','samples')},[position:1])

		soomla_android_store: ->
			@getCollection('documents').findAllLive({relativeOutDirPath: path.join('soomla','android','store')},[position:1])

		soomla_android_profile: ->
			@getCollection('documents').findAllLive({relativeOutDirPath: path.join('soomla','android','profile')},[position:1])

		soomla_android_samples: ->
			@getCollection('documents').findAllLive({relativeOutDirPath: path.join('soomla','android','samples')},[position:1])

		soomla_cocos2dx_store: ->
			@getCollection('documents').findAllLive({relativeOutDirPath: path.join('soomla','cocos2dx','cpp','store')},[position:1])

		soomla_cocos2dx_profile: ->
			@getCollection('documents').findAllLive({relativeOutDirPath: path.join('soomla','cocos2dx','cpp','profile')},[position:1])

		soomla_cocos2dx_samples: ->
			@getCollection('documents').findAllLive({relativeOutDirPath: path.join('soomla','cocos2dx','cpp','samples')},[position:1])

		soomla_cocos2djs_store: ->
			@getCollection('documents').findAllLive({relativeOutDirPath: path.join('soomla','cocos2dx','js','store')},[position:1])

		soomla_cocos2djs_profile: ->
			@getCollection('documents').findAllLive({relativeOutDirPath: path.join('soomla','cocos2dx','js','profile')},[position:1])

		soomla_cocos2djs_samples: ->
			@getCollection('documents').findAllLive({relativeOutDirPath: path.join('soomla','cocos2dx','js','samples')},[position:1])

		cocos2djs_grow: ->
			@getCollection('documents').findAllLive({relativeOutDirPath: path.join('cocos2dx','js')},[position:1])

		cocos2dx_grow: ->
			@getCollection('documents').findAllLive({relativeOutDirPath: path.join('cocos2dx','cpp')},[position:1])

		unity_grow: ->
			@getCollection('documents').findAllLive({relativeOutDirPath: path.join('unity')},[position:1])

		university_articles: ->
			@getCollection('documents').findAllLive({relativeOutDirPath: path.join('university','articles')},[position:1])

		samples: ->
			@getCollection('documents').findAllLive({relativeOutDirPath: path.join('samples')},[position:1])

# =================================
# Environments

# DocPad's default environment is the production environment
# The development environment, actually extends from the production environment

# The following overrides our production url in our development environment with false
# This allows DocPad's to use it's own calculated site URL instead, due to the falsey value
# This allows <%- @site.url %> in our template data to work correctly, regardless what environment we are in

	environments:
		static:
			maxAge: false
		development:
			maxAge: false
			templateData:
				site:
					url: false

	watchOptions:
		preferredMethods: ['watchFile','watch']
#  watchOptions:
#    catchupDelay: 0
	regenerateDelay: 0

# =================================
# DocPad Events

# Here we can define handlers for events that DocPad fires
# You can find a full listing of events on the DocPad Wiki

	events:

	# Server Extend
	# Used to add our own custom routes to the server before the docpad routes are added
		serverExtend: (opts) ->
			# Extract the server from the options
			{server} = opts
			docpad = @docpad

			# As we are now running in an event,
			# ensure we are using the latest copy of the docpad configuraiton
			# and fetch our urls from it
			latestConfig = docpad.getConfig()
			oldUrls = latestConfig.templateData.site.oldUrls or []
			newUrl = latestConfig.templateData.site.url

			# Redirect any requests accessing one of our sites oldUrls to the new site url
			server.use (req,res,next) ->
				if req.headers.host in oldUrls
					res.redirect(newUrl+req.url, 301)
				else
					next()

# Write After
# Used to minify our assets with grunt
#
# Gur: commented out because it conflicts with the default behavior of the
# docpad grunt plugin, which registers to this hook by default
#
#    writeAfter: (opts,next) ->
#
#      # Prepare
#      safeps = require('safeps')
#      docpad = @docpad
#      rootPath = docpad.getConfig().rootPath
#      gruntPath = path.join(rootPath, 'node_modules', '.bin', 'grunt')
#
#      command = [gruntPath, 'default']
#
#      # Execute
#      safeps.spawn(command, {cwd:rootPath,output:true}, next)
#
#      # Chain
#      @

	plugins:
		grunt:
			writeAfter: []
			environments:
				development:
					enabled: false
		ignoreincludes:
			ignoredExtensions: ['inc', 'min', 'map']
		livereload:
			enabled: false

}

# Export our DocPad Configuration
module.exports = docpadConfig
