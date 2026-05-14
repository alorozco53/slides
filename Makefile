update:
	rm -rf _site/
	rm -rf Gemfile.lock
	bundle update
	bundle install

install:
	bundle install

run:
	bundle exec jekyll serve --host=0.0.0.0 --port 4001 --config _config.yml,_config.dev.yml

clean:
	rm -rf _site/
