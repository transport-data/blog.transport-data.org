AUTHOR = "Transport Data Commons Initiative"
CC_LICENSE = "CC-BY-NC-ND"
SITENAME = "Transport Data Commons"
SITEURL = ""

AUTHOR_FEED_ATOM = None
AUTHOR_FEED_RSS = None
CATEGORY_FEED_ATOM = "feeds/{slug}.atom.xml"
FEED_ALL_ATOM = "feeds/all.atom.xml"
TRANSLATION_FEED_ATOM = None

DEFAULT_PAGINATION = False

PATH = "content"
PAGE_PATHS = ["page"]
ARTICLE_PATHS = [
    "",
    "event",
]
STATIC_PATHS = [
    "static",
]
PLUGIN_PATHS = [
    "./pelican-plugins",
]
PLUGINS = []

ARTICLE_URL = "{category}/{date:%Y-%m-%d}-{slug}"
ARTICLE_SAVE_AS = "{category}/{date:%Y-%m-%d}-{slug}/index.html"
PAGE_URL = "{slug}/"
PAGE_SAVE_AS = "{slug}/index.html"

TIMEZONE = "Europe/Rome"

DEFAULT_LANG = "en"

# 'pelican-bootstrap3' theme
THEME = "pelican-bootstrap3"

CUSTOM_CSS = "static/css/tdc.css"
HIDE_SIDEBAR = True
HIDE_SITENAME = True
SITELOGO = "static/logo-text.svg"

MENUITEMS = [
    ("Discuss", "https://github.com/orgs/transport-data/discussions"),
    ("Tools", "https://docs.transport-data.org"),
]

# Necessary to squash an exception with pelican-bootstrap3
# See https://github.com/getpelican/pelican-themes/issues/460
PLUGINS.append("i18n_subsites")
JINJA_ENVIRONMENT = {"extensions": ["jinja2.ext.i18n"]}
