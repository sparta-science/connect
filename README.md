# Sparta Connect

### Sparta Force plate Mac OS client

[![on-github](https://github.com/sparta-science/connect/workflows/on-github/badge.svg)](https://github.com/sparta-science/connect/actions?query=workflow%3Aon-github)

[![codecov](https://codecov.io/gh/sparta-science/connect/branch/master/graph/badge.svg)](https://codecov.io/gh/sparta-science/connect)

## Features

1. [Sparkle Updates](https://sparkle-project.org/)
   - automatically downloaded
   - click "Check for updates..." menu

## Development

1. Continuous Integration
   - builds code signed app
   - trigger new build on [Github Actions](https://github.com/sparta-science/connect/actions)
   - [Self-hosted](https://github.com/sparta-science/connect/actions?query=workflow%3Aself-hosted-test+branch%3Amaster) and [onGitHub](https://github.com/sparta-science/connect/actions?query=workflow%3AOnGitHub+branch%3Amaster)
2. Sparkle updates
   - not a sandbox app to allow updating the app by Sparkle
   - [automated UI test](https://github.com/sparta-science/connect/blob/master/UITests/UpdateAppTest.swift#L19) checks that app updates to the latest release
   - [appcast.xml](https://github.com/sparta-science/connect/releases/latest/download/appcast.xml) lists released versions


## Configuring Offline Mode

`defaults write com.spartascience.SpartaConnect "offline installation" -bool true`
