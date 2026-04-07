FLUTTER ?= flutter
FIREBASE ?= firebase
API_BASE_URL ?= https://dailyder-bot.fly.dev
DEV_AUTH_ENABLED ?= false

BUILD_DIR := build/web
FLUTTER_DART_DEFINES := --dart-define=API_BASE_URL=$(API_BASE_URL) --dart-define=DEV_AUTH_ENABLED=$(DEV_AUTH_ENABLED)

.PHONY: help build deploy clean

help:
	@echo "Targets:"
	@echo "  make build   Build the Flutter web app with API_BASE_URL=$(API_BASE_URL)"
	@echo "  make deploy  Build and deploy to Firebase Hosting"
	@echo "  make clean   Remove the Flutter web build output"

build:
	$(FLUTTER) build web $(FLUTTER_DART_DEFINES)

deploy: build
	$(FIREBASE) deploy --only hosting

clean:
	rm -rf $(BUILD_DIR)
