# Makefile for https://blog.transport-data.org
#
# Usage:
#   make clean                Remove the generated files
#   make devserver            Serve and regenerate together
#   make html                 (Re)generate the web site
#   make pull-static [GO=1]   Retrieve static files using rsync
#   make rsync-upload [GO=1]  Upload the web site via rsync+ssh
#   make setup                Install Python, Pelican, and dependencies
#
# Set the DEBUG variable to 1 to enable debugging, e.g. make DEBUG=1 html

# Use Pelican from the environment configured by uv
PELICAN?=uv run pelican

# Directories
BASEDIR=$(CURDIR)
INPUTDIR=$(BASEDIR)/content
OUTPUTDIR=$(BASEDIR)/output

PELICAN_PLUGINS_DIR?=/dev/null
PELICAN_THEMES_DIR?=/dev/null

# Pelican configuration file
CONF_FILE=$(BASEDIR)/config.py

# Default options to Pelican
PELICANOPTS=--settings=$(CONF_FILE) --output=$(OUTPUTDIR) $(INPUTDIR)

# For 'pull-static' target: requires SSH credentials
# with access to this host and directory
PULL_SOURCE=u444606-sub1@u444606.your-storagebox.de:./www
PULL_OPTS=-e 'ssh -p 23'

# For 'rsync-upload' target: requires SSH credentials
# with access to this host and directory
RSYNC_TARGET=root@blog.transport-data.org:/var/www/transport-data

# Options
DEBUG ?= 0
ifeq ($(DEBUG), 1)
  PELICANOPTS +=  --debug
endif

RSYNC_OPTS=-cCPrvz

GO =? 0
ifneq ($(GO), 1)
  RSYNC_OPTS += --dry-run
endif

help:
	@# Show lines of this file until the first blank line
	@sed -Ee '/./!Q;s/^# ?(.*)/\1/' ${MAKEFILE_LIST}
	@echo ''

clean:
	# Remove outputs
	[ ! -d $(OUTPUTDIR) ] || rm -rf $(OUTPUTDIR)

	# Remove uv virtual environment
	rm -rf .venv uv.lock

	# Remove symlink to PELICAN_PLUGINS_DIR
	rm -f pelican-plugins

devserver:
	$(PELICAN) --autoreload --listen --relative-urls $(PELICANOPTS)

# html: pull-static  # Temporarily disabled
html:
	$(PELICAN) $(PELICANOPTS)

pull-static:
	rsync $(RSYNC_OPTS) --times --update --info=SKIP $(PULL_OPTS) $(PULL_SOURCE)/ .

rsync-upload: html
	rsync $(RSYNC_OPTS) --delete --filter=". .rsync-filter" $(OUTPUTDIR)/ $(RSYNC_TARGET)

setup:
	# Create an environment with Python and dependencies
	uv sync

	# Connect plugins
	ln -sf $(PELICAN_PLUGINS_DIR) ./pelican-plugins

	# Connect theme
	$(PELICAN)-themes --symlink $(PELICAN_THEMES_DIR)/pelican-bootstrap3

.PHONY: help clean devserver html pull-static rsync-upload setup
