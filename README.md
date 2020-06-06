# Sparta Connect
### Sparta Force plate Mac OS client
![OnGitHub](https://github.com/sparta-science/connect/workflows/OnGitHub/badge.svg)

## Features
1. [Sparkle Updates](https://sparkle-project.org/)
  - automatically downloaded
  - click "Check for updates..." menu

## Development
1. Continuous Integration
  - builds code signed app
  - triggle new build on [Github Actions](https://github.com/sparta-science/connect/actions)
  - [Self-hosted](https://github.com/sparta-science/connect/actions?query=workflow%3Aself-hosted-test+branch%3Amaster) and [onGitHub](https://github.com/sparta-science/connect/actions?query=workflow%3AOnGitHub+branch%3Amaster)
2. Sparkle updates
  - not sandbox app to allow updating the app
  - latest build updates to the latest release
  - appcast.xml lists released versions
