build:
	@bundle exec jekyll build
	@cp -r _site/* ../gatewayd-io.github.io
	@cd ../gatewayd-io.github.io && git add . && git commit -m "Update docs" && git push origin && cd ../docs

run:
	@bundle exec jekyll serve --watch
